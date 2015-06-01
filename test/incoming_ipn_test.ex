defmodule IncomingIpnTest do
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

  @server "http://127.0.0.1:5454"
  @relative_url "/payments/ipn"
  @raw_ipn "payment_cycle=Monthly&txn_type=recurring_payment_profile_created&last_name=test&next_payment_date=03:00:00 May 23, 2015 PDT&residence_country=US&initial_payment_amount=0.00&currency_code=USD&time_created=00:38:20 May 23, 2015 PDT&verify_sign=AFcWxV21C7fd0v3bYYYRCpSSRl31AbUMjFGnbPU8eIzPzJShHI7lXkh1&period_type= Regular&payer_status=unverified&test_ipn=1&tax=0.00&payer_email=selenium-1432366799@example.com&first_name=selenium&receiver_email=resear_1362421868_biz@gmail.com&payer_id=LTF84489T2XWS&product_type=1&shipping=0.00&amount_per_cycle=29.95&profile_status=Active&charset=windows-1252&notify_version=3.8&amount=29.95&outstanding_balance=0.00&recurring_payment_id=I-YT040XS7WWGL&product_name=Morning Newsletter&ipn_track_id=b79a9f6238c8a"

  test "http server" do
    url = "#{@server}#{@relative_url}?#{@raw_ipn}"
    assert {:ok, %HTTPoison.Response{body: "OK", status_code: 200}} =
      HTTPoison.post(url, "")
  end

end
