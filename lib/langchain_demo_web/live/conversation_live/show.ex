defmodule LangChainDemoWeb.ConversationLive.Show do
  use LangChainDemoWeb, :live_view
  alias LangChainDemoWeb.ConversationLive.FormComponent
  alias LangChainDemoWeb.ConversationLive.MessageFormComponent
  alias LangChainDemo.Conversations
  alias LangChainDemo.Conversations.Conversation
  alias LangChainDemo.Messages
  alias LangChainDemo.Messages.Message
  alias LangChain.ChatModels.ChatOpenAI
  alias LangChain.Chains.LLMChain
  alias Phoenix.LiveView.AsyncResult

  @impl true
  def mount(%{"id" => id} = _params, _session, socket) do
    conversation = Conversations.get_conversation!(id)

    socket =
      socket
      |> assign_conversation(conversation)
      |> assign_messages()
      |> assign_llm_chain()
      |> assign(:async_result, %AsyncResult{})

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => _id} = params, _, socket) do
    changeset = Messages.change_message(%Message{})

    {:noreply,
     socket
     |> assign_form(changeset)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, _params) do
    socket
    |> assign(:page_title, socket.assigns.conversation.name)
    |> assign(:message, nil)
  end

  defp apply_action(socket, :edit, _params) do
    socket
    |> assign(:page_title, "Edit Conversation")
    |> assign(:message, nil)
  end

  defp apply_action(socket, :edit_message, %{"msg_id" => msg_id}) do
    socket
    |> assign(:page_title, "Edit Message")
    |> assign(:message, Messages.get_message!(socket.assigns.conversation.id, msg_id))
  end

  @impl true
  def handle_event("validate", %{"message" => message_params}, socket) do
    changeset =
      %Message{}
      |> Messages.change_message(message_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"message" => message_params}, socket) do
    conversation = socket.assigns.conversation

    params =
      message_params
      |> Map.put("role", "user")

    case Messages.create_message(conversation.id, params) do
      {:ok, _message} ->
        {:noreply,
         socket
         |> assign_messages()
         # re-build the chain based on the current messages
         |> assign_llm_chain()
         |> run_chain()
         |> put_flash(:info, "Message sent successfully")
         # reset the changeset
         |> assign_form(Message.changeset(%Message{}, %{}))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    message = Messages.get_message!(socket.assigns.conversation.id, id)
    {:ok, _} = Messages.delete_message(message)

    {:noreply, assign_messages(socket)}
  end

  def handle_event("resubmit", _params, socket) do
    socket =
      socket
      |> assign_llm_chain()
      |> run_chain()
      |> put_flash(:info, "Conversation re-submitted")

    {:noreply, socket}
  end

  # cancel the async process
  def handle_event("cancel", _params, socket) do
    socket =
      socket
      |> cancel_async(:running_llm)
      |> assign(:async_result, %AsyncResult{})
      |> put_flash(:info, "Cancelled")
      |> close_pending_as_cancelled()

    {:noreply, socket}
  end

  # handles async function returning a successful result
  def handle_async(:running_llm, {:ok, :ok = _success_result}, socket) do
    # discard the result of the successful async function. The side-effects are
    # what we want.
    socket =
      socket
      |> assign(:async_result, AsyncResult.ok(%AsyncResult{}, :ok))

    {:noreply, socket}
  end

  # handles async function returning an error as a result
  def handle_async(:running_llm, {:ok, {:error, reason}}, socket) do
    socket =
      socket
      |> put_flash(:error, reason)
      |> assign(:async_result, AsyncResult.failed(%AsyncResult{}, reason))
      |> close_pending_as_cancelled()

    {:noreply, socket}
  end

  # handles async function exploding
  def handle_async(:running_llm, {:exit, reason}, socket) do
    socket =
      socket
      |> put_flash(:error, "Call failed: #{inspect(reason)}")
      |> assign(:async_result, %AsyncResult{})
      |> close_pending_as_cancelled()

    {:noreply, socket}
  end

  # Close out any pending delta messages as cancelled and save what we've
  # received so far. This works when we initiate a cancel or we receive an error
  # from the async function.
  defp close_pending_as_cancelled(socket) do
    chain = socket.assigns.llm_chain

    # the task exited with an incomplete delta
    if chain.delta != nil do
      # most likely was cancelled. An incomplete
      # delta can be converted to a "cancelled" message
      updated_chain = LLMChain.cancel_delta(chain, :cancelled)

      # save the cancelled message
      Messages.create_message(
        socket.assigns.conversation.id,
        Map.from_struct(updated_chain.last_message)
      )

      socket
      |> assign(:llm_chain, updated_chain)
      |> assign_messages()
    else
      socket
    end
  end

  @impl true
  def handle_info({:chat_response, %LangChain.MessageDelta{} = delta}, socket) do
    updated_chain = LLMChain.apply_delta(socket.assigns.llm_chain, delta)

    socket =
      cond do
        # if this completed the delta and it's not a message, create the message
        updated_chain.delta == nil ->
          {:ok, _message} =
            Messages.create_message(
              socket.assigns.conversation.id,
              Map.from_struct(updated_chain.last_message)
            )

          socket
          |> assign_messages()
          |> assign(:llm_chain, updated_chain)
          |> flash_error_if_stopped_for_limit()

        true ->
          socket
      end

    {:noreply, assign(socket, :llm_chain, updated_chain)}
  end

  def handle_info({FormComponent, {:saved, %Conversation{} = conversation}}, socket) do
    {:noreply, assign_conversation(socket, conversation)}
  end

  def handle_info({MessageFormComponent, {:saved, %Message{} = _message}}, socket) do
    {:noreply, assign_messages(socket)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp role_icon(:system), do: "hero-cloud-solid"
  defp role_icon(:user), do: "hero-user-solid"
  defp role_icon(:assistant), do: "fa-user-robot"
  defp role_icon(:function_call), do: "fa-function"
  defp role_icon(:function), do: "fa-function"

  # Support both %Message{} and %MessageDelta{}
  defp message_block_classes(%{role: :system} = _message) do
    "bg-blue-50 text-blue-700 rounded-t-xl"
  end

  defp message_block_classes(%{role: :user} = _message) do
    "bg-white text-gray-600 font-medium"
  end

  defp message_block_classes(%{status: :length, role: :assistant} = _message) do
    "bg-red-50 text-red-800 font-medium"
  end

  defp message_block_classes(%{status: :cancelled, role: :assistant} = _message) do
    "bg-yellow-50 text-yellow-800 font-medium"
  end

  defp message_block_classes(%{role: :assistant} = _message) do
    "bg-gray-50 text-gray-600 font-medium"
  end

  defp edited_color(%Message{edited: true}), do: "text-orange-600"
  defp edited_color(%Message{edited: false}), do: "text-gray-600"

  defp display_date(%NaiveDateTime{} = datetime) do
    datetime
    |> DateTime.from_naive!("Etc/UTC")
    |> DateTime.shift_zone!("America/Denver")
    |> Calendar.strftime("%m/%d/%Y %H:%M:%S")
  end

  defp assign_conversation(socket, conversation) do
    socket
    |> assign(:conversation, conversation)
  end

  defp assign_messages(socket) do
    conversation = socket.assigns.conversation
    assign(socket, :messages, Messages.list_messages(conversation.id))
  end

  defp flash_error_if_stopped_for_limit(
         %{assigns: %{llm_chain: %LLMChain{last_message: %LangChain.Message{status: :length}}}} =
           socket
       ) do
    put_flash(socket, :error, "Stopped for limit")
  end

  defp flash_error_if_stopped_for_limit(socket) do
    socket
  end

  defp assign_llm_chain(socket) do
    conversation = socket.assigns.conversation

    # convert the DB stored message to LLMChain messages
    chain_messages =
      conversation.id
      |> Messages.list_messages()
      |> Messages.db_messages_to_langchain_messages()

    llm_chain =
      LLMChain.new!(%{
        llm:
          ChatOpenAI.new!(%{
            model: conversation.model,
            temperature: conversation.temperature,
            frequency_penalty: conversation.frequency_penalty,
            receive_timeout: 60_000 * 2,
            stream: true
          }),
        verbose: false
      })
      |> LLMChain.add_messages(chain_messages)

    assign(socket, :llm_chain, llm_chain)
  end

  def run_chain(socket) do
    chain = socket.assigns.llm_chain
    live_view_pid = self()

    callback_fn = fn
      %LangChain.MessageDelta{} = delta ->
        send(live_view_pid, {:chat_response, delta})

      %LangChain.Message{} = _message ->
        # disregard the full-message callback. We'll use the delta
        # send(live_view_pid, {:chat_response, message})
        :ok
    end

    socket
    |> assign(:async_result, AsyncResult.loading())
    |> start_async(:running_llm, fn ->
      case LLMChain.run(chain, callback_fn: callback_fn) do
        # return the errors for display
        {:error, reason} ->
          {:error, reason}

        # Don't return a large success result. The callbacks return what we
        # want.
        _other ->
          :ok
      end
    end)
  end
end
