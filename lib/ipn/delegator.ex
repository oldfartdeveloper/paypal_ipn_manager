defmodule Ipn.Delegator do
  use Application

  defp pool_name() do
    :ipn_pool
  end

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    poolboy_config = [
      {:name, {:local, pool_name()}},
      {:worker_module, Ipn.Worker},
      {:size, 2},
      {:max_overflow, 1}
    ]

    children = [
      :poolboy.child_spec(pool_name(), poolboy_config, [])
    ]

    options = [
      strategy: :one_for_one,
      name: Ipn.Supervisor
    ]

    Supervisor.start_link(children, options)
  end

  def handle(ipn) do
    delegate_ipn(ipn)
    :ok
  end

  def parallel_pool(range) do
    Enum.each(
      range,
      fn(x) -> spawn( fn() -> delegate_ipn(x) end ) end
    )
  end

  defp delegate_ipn(x) do
    :poolboy.transaction(
      pool_name(),
      fn(pid) -> :gen_server.call(pid, x) end,
      :infinity
    )
  end

end
