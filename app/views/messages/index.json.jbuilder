json.messages @messages do |json, message|
  json.id message.id
  json.body message.body
end
