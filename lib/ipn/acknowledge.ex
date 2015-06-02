defmodule Ipn.Acknowledge do
  @moduledoc """
  Handle verifying that an IPN has come from PayPal by reflecting it back to PayPal
  which will respond whether it was the source of the IPN or not.
  """
  use HTTPoison.Base

  # Define a test URL until we actually develop a facility to manage the PayPal callback URLs:
  @local_server "http://127.0.0.1:5454"
  @endpoint "#{@local_server}/paypal_ack"

  def interpret(pay_pal_answer) do
    case pay_pal_answer do
      "VERIFIED" -> true
      "INVALID" -> false
      "_" -> raise "Unknown PayPal acknowledgement response: '#{pay_pal_answer}'"
    end
  end

end
