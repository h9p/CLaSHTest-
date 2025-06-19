# encoding: UTF-8

if @config["Devlopers"].include?(message.from.id)
  case message.text
  when "#تفعيل"
    unless @config["Groups"].include?(message.chat.id)
      @config["Groups"].unshift(message.chat.id)
    end
    bot.api.send_message(chat_id: message.chat.id, text: "⚔ تم تفعيل البوت في المجموعة بنجاح ⚔")

  when "#تعطيل"
    @config["Groups"].delete(message.chat.id)
    bot.api.send_message(chat_id: message.chat.id, text: "⚔ تم تعطيل البوت في المجموعة بنجاح ⚔")

  when "#prom"
    if message.reply_to_message
      user_id = message.reply_to_message.from.id
      unless @config["Admins"].include?(user_id)
        @config["Admins"].unshift(user_id)
      end
      bot.api.send_message(chat_id: message.chat.id, text: "#{message.reply_to_message.from.first_name} #{message.reply_to_message.from.last_name} has been promoted")
    end

  when "#dem"
    if message.reply_to_message
      @config["Admins"].delete(message.reply_to_message.from.id)
      bot.api.send_message(chat_id: message.chat.id, text: "#{message.reply_to_message.from.first_name} #{message.reply_to_message.from.last_name} has been disqualified")
    end
  end
end

if @config["Admins"].include?(message.from.id)
  case message.text
  when "#المطور"
    bot.api.send_message(chat_id: message.chat.id, text: "⚔Clash Of Fire #{V}⚔\nBy @ihumam1")
  when "شنو هاي اللعبة"
    bot.api.send_message(chat_id: message.chat.id, text: "⚔Clash Of Fire #{V}⚔\n ⚔ لعبة حربية رائعة على التلغرام ⚔")
  end

  case message.text
  when "#id"
    bot.api.send_message(chat_id: message.chat.id, text: message.chat.id.to_s, reply_to_message_id: message.message_id)

  when "#ids"
    if message.reply_to_message
      bot.api.send_message(chat_id: message.chat.id, text: message.reply_to_message.from.id.to_s)
    end

  when "#bban"
    if message.reply_to_message && !@config["Devlopers"].include?(message.reply_to_message.from.id)
      bd[message.reply_to_message.from.id] = true
      bot.api.send_message(chat_id: message.chat.id, text: "#{message.reply_to_message.from.username} has been permanently blocked from the game")
    end

  when "#ban"
    if message.reply_to_message && !@config["Devlopers"].include?(message.reply_to_message.from.id)
      @config["bban"] << message.reply_to_message.from.id unless @config["bban"].include?(message.reply_to_message.from.id)
      bot.api.send_message(chat_id: message.chat.id, text: "#{message.reply_to_message.from.username} has been blocked from the game")
    end

  when "#unban"
    if message.reply_to_message && !@config["Devlopers"].include?(message.reply_to_message.from.id)
      @config["bban"].delete(message.reply_to_message.from.id)
      bot.api.send_message(chat_id: message.chat.id, text: "#{message.reply_to_message.from.username} has been unblocked")
    end
  end
end

if !bd[message.from.id] && !@config["bban"].include?(message.from.id)
  case message.text
  when "#تسجيل"
    if db[message.from.id]
      bot.api.send_message(chat_id: message.chat.id, text: "لقد قمت بالتسجيل مسبقاً ⚔")
    else
      db[message.from.id] = {
        "Power" => 150,
        "Defanse" => 100,
        "res" => 600,
        "Gems" => 60,
        "Attacks" => 0,
        "Wins" => 0,
        "Loses" => 0,
        "Defanse_a" => 0,
        "dd_win" => 0,
        "dd_loses" => 0,
        "level" => 1,
        "Shield" => true,
        "clan" => "none"
      }
      bot.api.send_message(chat_id: message.chat.id, text: "تم تسجيلك بنجاح ⚔")
      puts "#{message.from.username} HAS BEEN SIGNED UP".on_green
    end

  when "#الحالة"
    player = db[message.from.id]
    if player
      bot.api.send_message(
        chat_id: message.chat.id,
        text: <<~STATUS
          👾 اللاعب: #{message.from.first_name} #{message.from.last_name}
          🏅 المستوى: #{player["level"]}
          💪 القوة: #{player["Power"]}
          🕸 الدفاع: #{player["Defanse"]}
          🍎 الموارد: #{player["res"]}
          💎 الجواهر: #{player["Gems"]}
          🔰 الدرع: #{player["Shield"]}
          ⚔ عدد الهجمات: #{player["Attacks"]}
          👍--الانتصار: #{player["Wins"]}
          👎--الهزيمة: #{player["Loses"]}
          🎯 لدفاعات: #{player["Defanse_a"]}
          👍--الانتصار: #{player["dd_win"]}
          👎--الهزيمة: #{player["dd_loses"]}
        STATUS
      )
    else
      bot.api.send_message(chat_id: message.chat.id, text: "لم تسجل في اللعبة الى الان للتسجيل في اللعبة قم بكتابة #تسجيل")
    end

  when "#المتجر"
    bot.api.send_message(
      chat_id: message.chat.id,
      text: <<~STORE
        💲💲💲المتجر💲💲💲
        للشراء ارسل :
        شراء [قوة,دفاع,موارد] [1,2,3]

        》💪 Power Points
        1 -   50💪 for 10💎
        2 - 100💪 for 15💎
        3 - 250💪 for 30💎

        》🕸 Defense Points
        1 -  50🕸 for 10💎
        2 - 100🕸 for 15💎
        3 - 250🕸 for 30💎

        》🍎 Resources
        1 -  300🍎 for 15💎
        2 -  600🍎 for 25💎
        3 - 1400🍎 for 35💎
      STORE
    )
  end

  if message.text == "#دخول" && db[message.from.id]
    db[message.from.id]["Shield"] = false
    bot.api.send_message(chat_id: message.chat.id, text: "تم تعطيل الدرع بنجاح 🔰")

  elsif message.text == "#خروج" && db[message.from.id]
    db[message.from.id]["Shield"] = true
    bot.api.send_message(chat_id: message.chat.id, text: "تم تفعيل الدرع بنجاح 🔰")
  end

  if message.text == "info" && message.reply_to_message
    target_id = message.reply_to_message.from.id
    if db[target_id]
      target = db[target_id]
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "👾 Player: #{message.reply_to_message.from.first_name} #{message.reply_to_message.from.last_name}\n" \
              "🏅 Level: #{target["level"]}\n💪 Power: #{target["Power"]}\n🕸 Defense: #{target["Defanse"]}\n🍎 Resources: #{target["res"]}"
      )
    end
  elsif message.text == "حذف الحساب" && db[message.from.id]
    db.delete(message.from.id)
    bot.api.send_message(chat_id: message.chat.id, text: "⚔ تمت اعادة ضبط حسابك من جديد ⚔")
  end
end
