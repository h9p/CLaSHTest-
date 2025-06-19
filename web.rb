# web.rb

require_relative './plugins'
require 'telegram/bot'
require 'json'
require 'yaml/store'
require 'colorize'

Telegram::Bot::Client.run(token) do |bot|
  puts "#{@config["BotName"]} #{V} تم تشغيل بوت اللعبة بنجاح".on_yellow

  begin
    bot.listen do |message|
      bd.transaction do
        db.transaction do
          cn.transaction do
            begin
              # استدعاء الدوال من plugins.rb لكل رسالة
              Plugins.setting(bot, message, db, bd, cn, @config, V)
              Plugins.levels(bot, message, db)
              Plugins.attack(bot, message, db, bd, cn, @config)
              Plugins.store(bot, message, db, bd, @config)
              Plugins.support(bot, message, db, bd, @config)
              Plugins.clans(bot, message, db, bd, cn, @config)
            rescue => e
              puts "[PLUGIN ERROR] #{e.message}".on_red
            end
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
