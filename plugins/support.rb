if !bd[message.from.id] && !@config["bban"].include?(message.from.id)
  if message.text.to_s.start_with?("هدية") &&
     message.text.to_s.split.length == 3 &&
     db[message.from.id] &&
     message.reply_to_message &&
     db[message.reply_to_message.from.id]

    sender = db[message.from.id]
    receiver = db[message.reply_to_message.from.id]
    _, item, amount_str = message.text.split
    amount = amount_str.to_i

    gift_map = {
      "جواهر" => {
        key: "Gems",
        emoji: "💎",
        fail: "لا يوجد لديك جواهر كافية 💎"
      },
      "موارد" => {
        key: "res",
        emoji: "🍎",
        fail: "لا يوجد لديك موارد كافية 🍎"
      },
      "دفاع" => {
        key: "Defanse",
        emoji: "🕸",
        fail: "لا يوجد لديك دفاعات كافية 🕸"
      }
    }

    if gift = gift_map[item]
      key = gift[:key]
      if sender[key] >= amount && amount > 0
        sender[key] -= amount
        receiver[key] += amount

        bot.api.send_message(
          chat_id: message.chat.id,
          text: "#{message.from.first_name} #{message.from.last_name} أهدى #{message.reply_to_message.from.first_name} #{message.reply_to_message.from.last_name} #{amount} #{gift[:emoji]}"
        )
      else
        bot.api.send_message(chat_id: message.chat.id, text: gift[:fail])
      end
    else
      bot.api.send_message(chat_id: message.chat.id, text: "❌ نوع الهدية غير صحيح (اختر: جواهر، موارد، دفاع)")
    end
  end
end
