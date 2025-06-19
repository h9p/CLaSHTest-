# plugins.rb

module Plugins
  def self.setting(bot, message, db, bd, cn, config, v)
    return if bd[message.from.id] || config["bban"].include?(message.from.id)

    if config["Devlopers"].include?(message.from.id)
      case message.text
      when "#تفعيل"
        unless config["Groups"].include?(message.chat.id)
          config["Groups"].unshift(message.chat.id)
        end
        bot.api.send_message(chat_id: message.chat.id, text: "⚔ تم تفعيل البوت في المجموعة بنجاح ⚔")

      when "#تعطيل"
        config["Groups"].delete(message.chat.id)
        bot.api.send_message(chat_id: message.chat.id, text: "⚔ تم تعطيل البوت في المجموعة بنجاح ⚔")

      when "#prom"
        if message.reply_to_message
          user_id = message.reply_to_message.from.id
          unless config["Admins"].include?(user_id)
            config["Admins"].unshift(user_id)
          end
          bot.api.send_message(chat_id: message.chat.id, text: "#{message.reply_to_message.from.first_name} #{message.reply_to_message.from.last_name} has been promoted")
        end

      when "#dem"
        if message.reply_to_message
          config["Admins"].delete(message.reply_to_message.from.id)
          bot.api.send_message(chat_id: message.chat.id, text: "#{message.reply_to_message.from.first_name} #{message.reply_to_message.from.last_name} has been disqualified")
        end
      end
    end

    if config["Admins"].include?(message.from.id)
      case message.text
      when "#المطور"
        bot.api.send_message(chat_id: message.chat.id, text: "⚔Clash Of Fire #{v}⚔\nBy @ihumam1")
      when "شنو هاي اللعبة"
        bot.api.send_message(chat_id: message.chat.id, text: "⚔Clash Of Fire #{v}⚔\n ⚔ لعبة حربية رائعة على التلغرام ⚔")
      end

      case message.text
      when "#id"
        bot.api.send_message(chat_id: message.chat.id, text: message.chat.id.to_s, reply_to_message_id: message.message_id)
      when "#ids"
        if message.reply_to_message
          bot.api.send_message(chat_id: message.chat.id, text: message.reply_to_message.from.id.to_s)
        end
      when "#bban"
        if message.reply_to_message && !config["Devlopers"].include?(message.reply_to_message.from.id)
          bd[message.reply_to_message.from.id] = true
          bot.api.send_message(chat_id: message.chat.id, text: "#{message.reply_to_message.from.username} has been permanently blocked from the game")
        end
      when "#ban"
        if message.reply_to_message && !config["Devlopers"].include?(message.reply_to_message.from.id)
          config["bban"] << message.reply_to_message.from.id unless config["bban"].include?(message.reply_to_message.from.id)
          bot.api.send_message(chat_id: message.chat.id, text: "#{message.reply_to_message.from.username} has been blocked from the game")
        end
      when "#unban"
        if message.reply_to_message && !config["Devlopers"].include?(message.reply_to_message.from.id)
          config["bban"].delete(message.reply_to_message.from.id)
          bot.api.send_message(chat_id: message.chat.id, text: "#{message.reply_to_message.from.username} has been unblocked")
        end
      end
    end

    unless bd[message.from.id] || config["bban"].include?(message.from.id)
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
  end

  def self.attack(bot, message, db, bd, cn, config)
    return if bd[message.from.id] || config["bban"].include?(message.from.id)
    return unless %w[هجوم ⚔].include?(message.text)

    attacker = message.from
    defender_msg = message.reply_to_message
    return unless defender_msg

    defender = defender_msg.from

    attacker_data = db[attacker.id]
    defender_data = db[defender.id]

    return unless attacker_data && defender_data
    return if attacker.id == defender.id
    return if attacker_data["Shield"] || defender_data["Shield"]
    return if attacker_data["level"] > defender_data["level"]

    bot.api.send_message(
      chat_id: message.chat.id,
      text: "⚔بدأت الحرب بين⚔\n#{attacker.first_name} #{attacker.last_name}\nvS\n#{defender.first_name} #{defender.last_name}\n"
    )
    puts "#{attacker.username} Attacks on #{defender.username}".on_red

    if attacker_data["Power"] >= defender_data["Defanse"]
      if attacker_data["res"] >= 50
        d = [6,5,5,4,4,4,3,3,3,3,2,2,2,2,2,1,1,1,1,1,1].sample
        rss = rand(35) + defender_data["res"] / 5

        bot.api.send_message(
          chat_id: message.chat.id,
          text: "📯The War was Finished📯\nThe Winner is\n👾 #{attacker.first_name} #{attacker.last_name}\n" \
                "Rewards:\nResources +#{rss}🍎\nPower +25💪\nGems +#{d}💎\nOpponents Loses:\nDefense -10🕸"
        )
        puts "#{attacker.username} is the winner!!".on_yellow

        attacker_data["Gems"] += d
        attacker_data["Power"] += 25
        attacker_data["Attacks"] += 1
        attacker_data["Wins"] += 1
        attacker_data["res"] -= 50
        attacker_data["res"] += rss

        defender_data["Defanse"] -= 10 if defender_data["Defanse"] >= 10
        defender_data["res"] -= defender_data["res"] / 5
        defender_data["Defanse_a"] += 1
        defender_data["dd_loses"] += 1
      else
        bot.api.send_message(chat_id: message.chat.id, text: "هجوم غير صحيح ❌")
      end
    elsif attacker_data["Power"] >= 10 && attacker_data["res"] >= 50
      rss2 = rand(25)

      bot.api.send_message(
        chat_id: message.chat.id,
        text: "📯The War was Finished📯\nThe Winner is\n👾 #{defender.first_name} #{defender.last_name}\n" \
              "Total Results:\nResources +#{rss2}🍎\nPower -10💪\nOpponents Defense +25"
      )
      puts "#{defender.username} is the winner!!".on_green

      attacker_data["Power"] -= 10
      attacker_data["Attacks"] += 1
      attacker_data["Loses"] += 1
      attacker_data["res"] -= 35
      attacker_data["res"] += rss2

      defender_data["Defanse"] += 25
      defender_data["Defanse_a"] += 1
      defender_data["dd_win"] += 1
    else
      bot.api.send_message(chat_id: message.chat.id, text: "هجوم غير صحيح ❌")
    end
  end

  def self.clans(bot, message, db, bd, cn, config)
    return unless message && db[message.from.id]

    text = message.text.to_s
    args = text.split

    # Clan commands
    if text.start_with?("#clan") && args.length >= 2
      command = args[1]
      param = args[2]

      case command
      when "create"
        if args.length == 3 && db[message.from.id]["res"] >= 150
          rid = rand(1..9_999_999)
          clan_name = param

          cn.transaction do
            cn[rid] = {
              "id" => rid,
              "name" => clan_name,
              "level" => 1,
              "members" => {
                message.from.id => "#{message.from.first_name} #{message.from.last_name}"
              }
            }
          end

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
  end

  def self.levels(bot, message, db)
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

    if new_level != previous_level
      user["level"] = new_level
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "🎉 تهانينا #{message.from.first_name}!\nلقد وصلت إلى المستوى #{new_level} 🏆"
      )
    end
  end

  def self.store(bot, message, db, bd, config)
    return if bd[message.from.id] || config["bban"].include?(message.from.id)
    text = message.text.to_s

    if text.start_with?("شراء") && text.split.length == 3 && db[message.from.id]
      user = db[message.from.id]
      _, item, level_str = text.split
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

      item_key = store_items[item]
      if [:same_as_قوة, :same_as_دفاع, :same_as_موارد].include?(item_key)
        item_key = store_items[item_key.to_s.gsub("same_as_", "")]
      end

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

  def self.support(bot, message, db, bd, config)
    return if bd[message.from.id] || config["bban"].include?(message.from.id)

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
end
