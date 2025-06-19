return if bd[message.from.id] || @config["bban"].include?(message.from.id)

text = message.text.to_s
args = text.split

# تحقق من أن المستخدم موجود في قاعدة البيانات
return unless db[message.from.id]

# أوامر الكلان
if text.start_with?("#clan") && args.length >= 2
  command = args[1]
  param = args[2]

  case command
  when "create"
    if args.length == 3 && db[message.from.id]["res"] >= 150
      rid = rand(1..9_999_999)
      clan_name = param

      cn[rid] = {
        "id" => rid,
        "name" => clan_name,
        "level" => 1,
        "members" => {
          message.from.id => "#{message.from.first_name} #{message.from.last_name}"
        }
      }

      db[message.from.id]["clan"] = rid
      db[message.from.id]["res"] -= 150

      bot.api.send_message(chat_id: message.chat.id, text: "✅ Clan '#{clan_name}' was created with ID #{rid}!")
    else
      bot.api.send_message(chat_id: message.chat.id, text: "❌ You need at least 150🍎 resources to create a clan.")
    end

  when "join"
    clan_id = param.to_i
    clan = cn[clan_id]

    if clan
      clan["members"][message.from.id] = "#{message.from.first_name} #{message.from.last_name}"
      db[message.from.id]["clan"] = clan_id
      bot.api.send_message(chat_id: message.chat.id, text: "✅ You joined the clan '#{clan["name"]}'!")
    else
      bot.api.send_message(chat_id: message.chat.id, text: "❌ Clan ID #{clan_id} not found.")
    end

  when "info"
    clan_key = param.to_i.to_s == param ? param.to_i : param
    clan = cn[clan_key]

    if clan
      member_count = clan["members"].size
      bot.api.send_message(chat_id: message.chat.id, text: 
        "🏰 Clan Info:\n" \
        "Name: #{clan["name"]}\n" \
        "ID: #{clan["id"]}\n" \
        "Level: #{clan["level"]}\n" \
        "Members: #{member_count}"
      )
    else
      bot.api.send_message(chat_id: message.chat.id, text: "❌ Clan not found.")
    end

  when "out"
    clan_id = db[message.from.id]["clan"]
    clan = cn[clan_id]

    if clan && clan["members"].key?(message.from.id)
      clan["members"].delete(message.from.id)
      db[message.from.id]["clan"] = "none"
      bot.api.send_message(chat_id: message.chat.id, text: "🚪 You left the clan.")
    else
      bot.api.send_message(chat_id: message.chat.id, text: "❌ You are not in a clan.")
    end
  else
    bot.api.send_message(chat_id: message.chat.id, text: "❓ Unknown clan command.")
  end
end
