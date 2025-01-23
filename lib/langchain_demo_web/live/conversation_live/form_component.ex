defmodule LangChainDemoWeb.ConversationLive.FormComponent do
  use LangChainDemoWeb, :live_component

  alias LangChainDemo.Conversations
  alias LangChainDemo.Conversations.Conversation
  alias LangChainDemo.Messages

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage conversation records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="conversation-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" phx-debounce="500" />
        <.input
          field={@form[:model]}
          type="select"
          label="Model"
          options={Conversation.model_options()}
        />

        <.input
          type="range"
          field={@form[:temperature]}
          min={0.0}
          max={2.0}
          step={0.1}
          ticks={false}
          label={"Temperature (#{@form[:temperature].value})"}
          phx-debounce="250"
          help="Between 0 and 2. Higher values like 0.8 make the output more random, while lower values like 0.2 make it more focused and deterministic."
        />

        <.input
          type="range"
          field={@form[:frequency_penalty]}
          min={-2.0}
          max={2.0}
          step={0.1}
          ticks={false}
          label={"Frequency Penalty (#{@form[:frequency_penalty].value})"}
          phx-debounce="250"
          help="Between -2 and 2. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim."
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save Conversation</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{conversation: conversation} = assigns, socket) do
    changeset = Conversations.change_conversation(conversation)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"conversation" => conversation_params}, socket) do
    changeset =
      socket.assigns.conversation
      |> Conversations.change_conversation(conversation_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"conversation" => conversation_params}, socket) do
    save_conversation(socket, socket.assigns.action, conversation_params)
  end

  defp save_conversation(socket, :edit, conversation_params) do
    case Conversations.update_conversation(socket.assigns.conversation, conversation_params) do
      {:ok, conversation} ->
        notify_parent({:saved, conversation})

        {:noreply,
         socket
         |> put_flash(:info, "Conversation updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_conversation(socket, :new, conversation_params) do
    case Conversations.create_conversation(conversation_params) do
      {:ok, conversation} ->
        # create a default system message
        Messages.create_message(conversation.id, %{
          role: :system,
          content: "You are a helpful assistant."
        })

        notify_parent({:saved, conversation})

        {:noreply,
         socket
         |> put_flash(:info, "Conversation created successfully")
         |> push_navigate(to: ~p"/conversations/#{conversation.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
