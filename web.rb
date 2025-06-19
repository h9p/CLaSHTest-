# encoding: UTF-8

require 'json'
require 'telegram/bot'
require 'yaml/store'
require 'colorize'
require 'securerandom'

# Load config
config_path = 'config.json'
@config = JSON.parse(File.read(config_path))
V = @config["Version"]

# Databases
db = YAML::Store.new('Game.yml')
bd = YAML::Store.new('banned.yml')
cn = YAML::Store.new('clans.yml')

# Token
token = @config["Token"]

Telegram::Bot::Client.run(token) do |bot|
  puts "#{@config["BotName"]} #{V} تم تشغيل بوت اللعبة بنجاح".on_yellow

  begin
    bot.listen do |message|
      bd.transaction do
        db.transaction do
          cn.transaction do
            # ===== هنا تضيف كود معالجة الرسائل مباشرة =====

            # مثال بسيط: أمر تسجيل
            if !bd[message.from.id] && !@config["bban"].include?(message.from.id)
              case message.text
              when "#تسجيل"
                unless db[message.from.id]
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
                else
                  bot.api.send_message(chat_id: message.chat.id, text: "لقد قمت بالتسجيل مسبقاً ⚔")
                end
              end
            end

            # ===== يمكنك هنا إضافة المزيد من أوامر اللعبة بنفس النمط =====

          end
        end
      end
    end
  rescue Telegram::Bot::Exceptions::ResponseError => e
    puts "[Telegram Error] #{e.message}".on_red
    retry
  rescue => e
    puts "[General Error] #{e.message}".on_red
    sleep 5
    retry
  end
end

# Designed by Humam Muhammed
# Usage: TELEGRAM_BOT_POOL_SIZE=16 ruby bot.rb
