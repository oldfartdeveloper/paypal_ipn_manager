defmodule Ipn.FakePaypalAck do

  def response(_params) do
    "VERIFIED"
  end

end
