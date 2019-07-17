require 'telegram/bot'
require_relative 'commands/start'

class WebhooksController < Telegram::Bot::UpdatesController
  extend StartCommand

end



TOKEN = '890059889:AAESf4Gi_a8Kq7pxM7xzGbJQVnhvLwp_TZQ'
bot = Telegram::Bot::Client.new(TOKEN)
bot.start!
# poller-mode
require 'logger'
logger = Logger.new(STDOUT)
poller = Telegram::Bot::UpdatesPoller.new(bot, WebhooksController, logger: logger)
poller.start
