# encoding: utf-8

$customerio = Customerio::Client.new("d98bb6ac9f4e37c473b7", "9aa1813a41e948025b76")

Customerio::Client.id do |customer|
  "#{Rails.env}_#{customer.id}"
end