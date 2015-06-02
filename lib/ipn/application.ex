defmodule Ipn.Application do
  use Application

  def start(_type, _args) do
    response = Ipn.Delegator.start('foo', 'bar')
    Ipn.Web.start_server
    response
  end
end
