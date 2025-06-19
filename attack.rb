return if bd[message.from.id] || @config["bban"].include?(message.from.id)
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
  text: "⚔بدأت الحرب بين⚔\n#{attacker.first_name} #{attacker.last_name}\nVS\n#{defender.first_name} #{defender.last_name}\n"
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
