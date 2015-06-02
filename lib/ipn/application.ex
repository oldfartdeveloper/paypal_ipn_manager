defmodule Ipn.Application do
  use Application

  def start(_, _) do
    response = Ipn.Supervisor.start
    Ipn.Web.start_server
    response
  end
end
