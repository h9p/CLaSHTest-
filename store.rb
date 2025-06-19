if !bd[message.from.id] && !@config["bban"].include?(message.from.id)
  if message.text.to_s.start_with?("شراء") && message.text.to_s.split.length == 3 && db[message.from.id]
    user = db[message.from.id]
    _, item, level_str = message.text.split
    level = level_str.to_i

    store_items = {
      "قوة" => [
        { power: 50, gems: 10 },
        { power: 100, gems: 20 },
        { power: 250, gems: 30 }
      ],
      "💪" => :same_as_قوة,
      "دفاع" => [
        { def: 50, gems: 10 },
        { def: 100, gems: 20 },
        { def: 250, gems: 30 }
      ],
      "🕸" => :same_as_دفاع,
      "موارد" => [
        { res: 300, gems: 15 },
        { res: 600, gems: 25 },
        { res: 1200, gems: 35 }
      ],
      "🍎" => :same_as_موارد
    }

    # دعم الرموز باستخدام alias
    item_key = store_items[item]
    item_key = store_items[item_key.to_s.gsub("same_as_", "")] if item_key == :same_as_قوة || item_key == :same_as_دفاع || item_key == :same_as_موارد

    if item_key && level.between?(1, 3)
      offer = item_key[level - 1]
      cost = offer[:gems]

      if user["Gems"] >= cost
        if offer[:power]
          user["Power"] += offer[:power]
          desc = "#{offer[:power]} من القوة 💪"
        elsif offer[:def]
          user["Defanse"] += offer[:def]
          desc = "#{offer[:def]} من الدفاع 🕸"
        elsif offer[:res]
          user["res"] += offer[:res]
          desc = "#{offer[:res]} من الموارد 🍎"
        end

        user["Gems"] -= cost
        bot.api.send_message(chat_id: message.chat.id, text: "✅ تم شراء ( #{desc} ) بـ#{cost} جوهرة 💎")
      else
        bot.api.send_message(chat_id: message.chat.id, text: "❌ عذراً، لا تمتلك عدد كافٍ من الجواهر 💎")
      end
    else
      bot.api.send_message(chat_id: message.chat.id, text: "❌ الخيار غير صحيح. اختر بين [1,2,3] للشراء.")
    end
  end
end
