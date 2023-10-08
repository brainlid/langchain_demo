defmodule LangChainDemoWeb.PageControllerTest do
  use LangChainDemoWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Conversations"
  end
end
