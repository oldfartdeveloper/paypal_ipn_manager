defmodule Ipn.Web do
  use Plug.Router

  plug :match
  plug :dispatch

  def start_server do
    Plug.Adapters.Cowboy.http(__MODULE__, nil, port: 5454)
  end

  # The PayPal IPN calls here
  post "/payments/ipn" do
    conn
    |> process
    Plug.Conn.send_resp(conn, 200, "OK")
  end

  defp process(conn) do
    Ipn.Delegator.handle(conn.query_string)
  end

  # A fake PayPal acknowledgement server.  Until we start talking to a real PayPal server.
  post "/fake/acknowledge" do
    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> verified
  end

  defp verified(conn) do
    result = Ipn.FakePaypalAck.response(conn.params)
    Plug.Conn.send_resp(conn, 200, result)
  end

  match _ do
    Plug.Conn.send_resp(conn, 404, "not found")
  end
end
