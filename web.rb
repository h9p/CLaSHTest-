# encoding: UTF-8

# === Required Libraries ===
require 'json'
require 'rubygems'
require 'telegram/bot'
require 'yaml/store'
require 'colorize'
require 'securerandom'

# === Load Config ===
config_path = 'config.json'
@config = JSON.parse(File.read(config_path))
V = @config["Version"]

# === Game Databases ===
db = YAML::Store.new('Game.yml')
bd = YAML::Store.new('banned.yml')
cn = YAML::Store.new('clans.yml')

# === Bot Token ===
token = @config["Token"]

# === Run Bot ===
Telegram::Bot::Client.run(token) do |bot|
  puts "#{@config["BotName"]} #{V} تم تشغيل بوت اللعبة بنجاح".on_yellow

  begin
    bot.listen do |message|
      # Handle Plugins
      bd.transaction do
        db.transaction do
          cn.transaction do
            begin
              require_relative './plugins/setting'
              require_relative './plugins/levels'
              require_relative './plugins/attack'
              require_relative './plugins/store'
              require_relative './plugins/support'
            rescue LoadError => e
              puts "[PLUGIN ERROR] فشل في تحميل أحد الملفات: #{e.message}".on_red
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

# Designed by Humam Muhammed
# Usage: TELEGRAM_BOT_POOL_SIZE=16 ruby bot.rb
