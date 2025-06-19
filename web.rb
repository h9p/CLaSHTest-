
#Encoding: UTF-8


#require libs
require 'json'
require 'rubygems'
require 'telegram/bot'
require 'yaml/store'
require "colorize"
require 'securerandom'



#Config file
@ConfigFile = File.read('config.json')
@config = JSON.parse(@ConfigFile)

#Game database
db = YAML::Store.new('Game.yml')
bd = YAML::Store.new('banned.yml')
cn = YAML::Store.new('clans.yml')

#bot token
token = @config["Token"]

V = @config["Version"]

#game start
Telegram::Bot::Client.run(token) do |bot|
	puts "#{@config["BotName"]} #{V} تم تشغيل بوت اللعبة بنجاح".on_yellow
	begin
		bot.listen do |message|
			#require bot files
			bd.transaction do
				db.transaction do
					cn.transaction do
						eval(File.read("./plugins/setting.rb"))
						eval(File.read("./plugins/levels.rb"))
						eval(File.read("./plugins/attack.rb"))
						eval(File.read("./plugins/store.rb"))
						eval(File.read("./plugins/support.rb"))
					end
				end
			end
		end
	rescue Telegram::Bot::Exceptions::ResponseError => e
    	retry
	end
end


#designed by Humam Muhammed
#TELEGRAM_BOT_POOL_SIZE=16 ruby bot.rb
