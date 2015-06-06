defmodule DelegatorTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, pid} = Ipn.Delegator.start(nil, nil)
    {:ok, [pid: pid]}
  end

#  test "assert delegator receives payload" do
#    Ipn.Delegator.handle("abcde")
#    # Ipn.Delegator, {:handle, "abcde"}
#    assert_received(Ipn.Delegator, {:delegate_ipn, "abcde"})
#    # Ipn.Delegator.assert_receive(:handle, "abcde")
#  end

end
