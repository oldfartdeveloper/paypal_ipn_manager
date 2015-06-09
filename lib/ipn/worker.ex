# This represents a worker in a pool of workers that take each IPN sent to us by PayPal and:
#
# 1.  Make sure that PayPal acknowledges that it sent the IPN to us and not some imposter
# 2.  Write it to the Hedgeye background daemon
defmodule Ipn.Worker do
  use GenServer

  def start_link([]) do
    :gen_server.start_link(__MODULE__, [], [])
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(data, from, state) do
    IO.puts("received '#{state}'")
    {:reply, [], state}
  end

end
