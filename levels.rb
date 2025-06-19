return unless message && db[message.from.id]

user = db[message.from.id]
power = user["Power"]
previous_level = user["level"]

new_level =
  case power
  when 0...400 then 1
  when 400...600 then 2
  when 600...800 then 3
  when 800...1000 then 4
  else
    5
  end

# فقط إذا تغير المستوى
if new_level != previous_level
  user["level"] = new_level

  bot.api.send_message(
    chat_id: message.chat.id,
    text: "🎉 تهانينا #{message.from.first_name}!\nلقد وصلت إلى المستوى #{new_level} 🏆"
  )
end
