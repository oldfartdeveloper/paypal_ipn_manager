defmodule ReceiveIpnTest do
  use ExUnit.Case, async: false

  @host_and_stuff "http://127.0.0.1:5454/payments/ipn"
  @create_params "payment_cycle=Monthly&txn_type=recurring_payment_profile_created&last_name=bolles&next_payment_date=03%3A00%3A00+Jun+01%2C+2015+PDT&residence_country=US&initial_payment_amount=0.00¤cy_code=USD&time_created=08%3A14%3A08+Jun+01%2C+2015+PDT&verify_sign=A.AFXr4vLbVjOThr1Kdg4kfb7qLCAfqRPvuSIya57Xgy4S7qRMTdsCPU&period_type=+Regular&payer_status=unverified&tax=0.00&payer_email=cbolles%40verityinvest.com&first_name=Christopher+C.&receiver_email=merchantpayments%40hedgeye.com&payer_id=Y48HZCKRD8NRY&product_type=1&shipping=0.00&amount_per_cycle=39.95&profile_status=Active&charset=windows-1252¬ify_version=3.8&amount=39.95&outstanding_balance=0.00&recurring_payment_id=I-NSBRR01070BA&product_name=The+Macro+Show&ipn_track_id=5c90d08655312"
  @recurring_params "mc_gross=39.95&period_type=+Regular&outstanding_balance=0.00&next_payment_date=03%3A00%3A00+Jul+01%2C+2015+PDT&protection_eligibility=Ineligible&payment_cycle=Monthly&tax=0.00&payer_id=Y48HZCKRD8NRY&payment_date=11%3A43%3A12+Jun+01%2C+2015+PDT&payment_status=Completed&product_name=The+Macro+Show&charset=windows-1252&recurring_payment_id=I-NSBRR01070BA&first_name=Christopher+C.&mc_fee=1.23¬ify_version=3.8&amount_per_cycle=39.95&payer_status=unverified¤cy_code=USD&business=merchantpayments%40hedgeye.com&verify_sign=Axm97SpqDwszsMzK0mCIJtNY.bgGA7ivolBFf6uKC08nO4rzSKKZ72FY&payer_email=cbolles%40verityinvest.com&initial_payment_amount=0.00&profile_status=Active&amount=39.95&txn_id=2K9138240A736350V&payment_type=instant&last_name=bolles&receiver_email=merchantpayments%40hedgeye.com&payment_fee=1.23&receiver_id=ES8RSP6MT4F4L&txn_type=recurring_payment&mc_currency=USD&residence_country=US&receipt_id=3045-5549-8424-5370&transaction_subject=&payment_gross=39.95&shipping=0.00&product_type=1&time_created=08%3A14%3A08+Jun+01%2C+2015+PDT&ipn_track_id=8ba9f90b39b74"

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

  test "respond successfully to IPN request from PayPal" do
    assert {:ok, %HTTPoison.Response{body: "OK", status_code: 200}} =
      HTTPoison.post(full_url, "")
  end

  defp full_url do
    "#{@host_and_stuff}?#{@create_params}"
  end


  # From PayPal "IPN Message" field:
  # "mc_gross=29.95&period_type= Regular&outstanding_balance=0.00&next_payment_date=03:00:00 Jun 23, 2015 PDT&protection_eligibility=Ineligible&payment_cycle=Monthly&tax=0.00&payer_id=23DFVED2479FU&payment_date=03:22:09 May 23, 2015 PDT&payment_status=Completed&product_name=Investing Ideas&charset=windows-1252&recurring_payment_id=I-3RXGL2YU6H4T&first_name=David&mc_fee=1.17&notify_version=3.8&amount_per_cycle=29.95&payer_status=unverified&currency_code=USD&business=resear_1362421868_biz@gmail.com&verify_sign=Akb8wrAZ8Auhkn6CIXzjdSq66j5HAJ-uTMXSy4R.-1DwBliu-sMwGviK&payer_email=selenium-1429601863@example.com&initial_payment_amount=0.00&profile_status=Active&amount=29.95&txn_id=09P962210D057220P&payment_type=instant&last_name=Warner&receiver_email=resear_1362421868_biz@gmail.com&payment_fee=1.17&receiver_id=7WZ88H535BSYJ&txn_type=recurring_payment&mc_currency=USD&residence_country=US&test_ipn=1&receipt_id=3635-1131-9909-9209&transaction_subject=&payment_gross=29.95&shipping=0.00&product_type=1&time_created=07:35:13 Apr 23, 2015 PDT&ipn_track_id=639e538ef3dc9"
  # BAD FORMAT: "payment_cycle=Monthly&txn_type=recurring_payment_profile_created&last_name=test&next_payment_date=03:00:00 May 23, 2015 PDT&residence_country=US&initial_payment_amount=0.00&currency_code=USD&time_created=00:38:20 May 23, 2015 PDT&verify_sign=AFcWxV21C7fd0v3bYYYRCpSSRl31AbUMjFGnbPU8eIzPzJShHI7lXkh1&period_type= Regular&payer_status=unverified&test_ipn=1&tax=0.00&payer_email=selenium-1432366799@example.com&first_name=selenium&receiver_email=resear_1362421868_biz@gmail.com&payer_id=LTF84489T2XWS&product_type=1&shipping=0.00&amount_per_cycle=29.95&profile_status=Active&charset=windows-1252&notify_version=3.8&amount=29.95&outstanding_balance=0.00&recurring_payment_id=I-YT040XS7WWGL&product_name=Morning Newsletter&ipn_track_id=b79a9f6238c8a"
  # "payment_cycle=Monthly&txn_type=recurring_payment_profile_cancel&last_name=Zezoff&next_payment_date=N/A&residence_country=US&initial_payment_amount=0.00&currency_code=USD&time_created=16%3A40%3A32+Apr+15%2C+2015+PDT&verify_sign=A0Eb8n0jOFQOYgjCpTf.GxozgHKmA0QZ0YggWetZsUaEkIWBxNzRCldB&period_type=+Regular&payer_status=unverified&tax=0.00&payer_email=zezoff%40me.com&first_name=Robert&receiver_email=merchantpayments%40hedgeye.com&payer_id=PN8KPJTC5XQYA&product_type=1&shipping=0.00&amount_per_cycle=29.95&profile_status=Cancelled&charset=windows-1252&notify_version=3.8&amount=29.95&outstanding_balance=0.00&recurring_payment_id=I-FJBKGK134RD4&product_name=Morning+Newsletter&ipn_track_id=3cf95bcb2dac8"
  # "payment_cycle=Monthly&txn_type=recurring_payment_profile_created&last_name=test&residence_country=US&initial_payment_amount=0.00&currency_code=USD&verify_sign=AFcWxV21C7fd0v3bYYYRCpSSRl31AbUMjFGnbPU8eIzPzJShHI7lXkh1&payer_status=unverified&test_ipn=1&tax=0.00&payer_email=selenium-1432366799@example.com&first_name=selenium&receiver_email=resear_1362421868_biz@gmail.com&payer_id=LTF84489T2XWS&product_type=1&shipping=0.00&amount_per_cycle=29.95&profile_status=Active&charset=windows-1252&notify_version=3.8&amount=29.95&outstanding_balance=0.00&recurring_payment_id=I-YT040XS7WWGL&product_name=Morning Newsletter&ipn_track_id=b79a9f6238c8a"

end
