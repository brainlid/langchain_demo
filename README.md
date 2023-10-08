# ![Logo with chat chain links](./elixir-langchain-link-logo_32px.png) LangChainDemo

This project is a demonstration example using the [Elixir LangChain](https://github.com/brainlid/langchain) library and [Phoenix LiveView](https://www.phoenixframework.org/).

To start your LangChain Demo project:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4004`](http://localhost:4004) from your browser.

## Conversations

Visit the [Conversations](http://localhost:4004/conversations) page for having a conversation with ChatGPT.

You can cancel a request in flight, delete a message, edit a message, and resubmit the conversation.

Features:
- Conversations are written to a SQLite database in the project directory.
- Conversations are performed using the [Elixir LangChain](https://github.com/brainlid/langchain) library.
- Uses Phoenix LiveView [Async Operations](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#module-async-operations).
- Use <kbd>ctrl+enter</kbd> to submit a message.

![Example GIF showing usage with editing and resubmitting](./ConversationDemo.gif)