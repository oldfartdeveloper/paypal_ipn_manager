defmodule Ipn.ReceiveIpn do
  use Plug.Router

  plug :match
  plug :dispatch

  def start_server do
    Ipn.Delegate.start()
    Plug.Adapters.Cowboy.http(__MODULE__, nil, port: 5454)
  end

  # The PayPal IPN calls here
  post "/payments/ipn" do
    conn
    |> process_ipn
    |> respond
  end

  defp process_ipn(conn) do
    conn.query_string
    |> Ipn.Supervisor.handle
    Plug.Conn.assign(conn, :response, "OK")
  end

  defp respond(conn) do
    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, conn.assigns[:response])
  end

  match _ do
    Plug.Conn.send_resp(conn, 404, "not found")
  end

end
