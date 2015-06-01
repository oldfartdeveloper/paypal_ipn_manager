defmodule HttpServerTest do
  use ExUnit.Case, async: false

  setup do
    # This is an integration test of the entire app. We first remove old
    # persisted data, and then start the app.
    File.rm_rf("./persist/")
    {:ok, apps} = Application.ensure_all_started(:ipn)

    HTTPoison.start

    on_exit fn ->
      # When the test is finished, we'll stop all application we started.
      Enum.each(apps, &Application.stop/1)
    end

    :ok
  end

  test "http server" do
    assert {:ok, %HTTPoison.Response{body: "", status_code: 200, body: _}} =
      HTTPoison.get("http://127.0.0.1:5454/entries?list=test&date=20131219")

    assert {:ok, %HTTPoison.Response{body: "OK", status_code: 200}} =
      HTTPoison.post("http://127.0.0.1:5454/add_entry?list=test&date=20131219&title=Dentist", "")

    assert {:ok, %HTTPoison.Response{body: "2013-12-19    Dentist", status_code: 200}} =
      HTTPoison.get("http://127.0.0.1:5454/entries?list=test&date=20131219")

    assert {:ok, %HTTPoison.Response{body: "OK", status_code: 200}} =
      HTTPoison.post("http://127.0.0.1:5454/payments/ipn?list=test&date=20131219&title=Dentist", "")
  end

end
