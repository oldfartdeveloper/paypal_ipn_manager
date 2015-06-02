# This represents a worker in a pool of workers that take each IPN sent to us by PayPal and:
#
# 1.  Make sure that PayPal acknowledges that it sent the IPN to us and not some imposter
# 2.  Write it to the Hedgeye background daemon
defmodule Ipn.Worker do

end
