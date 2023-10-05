defmodule LangchainDemo.Repo do
  use Ecto.Repo,
    otp_app: :langchain_demo,
    adapter: Ecto.Adapters.SQLite3
end
