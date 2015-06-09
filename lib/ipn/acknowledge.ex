defmodule Ipn.Acknowledge do
  @moduledoc """
  Handle verifying that an IPN has come from PayPal by reflecting it back to PayPal
  which will respond whether it was the source of the IPN or not.
  """
  use HTTPoison.Base

  # Define the PayPal acknowledge endpoint:
  @paypal_service_url "xxx"

  # Define a test URL until we actually develop a facility to manage the PayPal callback URLs:
  @local_server "http://127.0.0.1:5454"
  @endpoint "#{@local_server}/paypal_ack"

  @doc ~S"""
  Return the logical PayPal acknowledgement response as an Elixir return code

  ## Examples

      iex> Ipn.Acknowledge.interpret("VERIFIED")
      :ok
      iex> Ipn.Acknowledge.interpret("INVALID")
      {:error, :invalid}
      iex> Ipn.Acknowledge.interpret("UNKNOWN")
      {:error, {:unknown, "UNKNOWN"}}
  """
  def interpret(pay_pal_answer) do
    case pay_pal_answer do
      "VERIFIED" -> :ok
      "INVALID" -> {:error, :invalid}
      _other -> {:error, {:unknown, _other}}
    end
  end

  @doc ~S"""
  Formats the acknowledge request to send back to PayPal

  ## Examples

      iex> Ipn.Acknowledge.format("paypal_service_url", "&params_key=params_value\n")
      {:ok, "paypal_service_url?cmd=_notify-validate&params_key=params_value\n"}
  """
  def format(paypal_service_url, params_string) do
    {:ok, "#{paypal_service_url}?cmd=_notify-validate#{params_string}"}
  end

end

#            response = ssl_post(Paypal.service_url + '?cmd=_notify-validate', payload,
#              'Content-Length' => "#{payload.size}",
#              'User-Agent'     => "Active Merchant -- http://activemerchant.org"
#            )
