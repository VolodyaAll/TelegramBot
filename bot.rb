require 'telegram/bot'
require_relative 'commands/start'
require_relative 'commands/checkin'

class WebhooksController < Telegram::Bot::UpdatesController
  def initialize(*)
    super
    Telegram::Bot::UpdatesController.session_store = :redis_store, { expires_in: 2_592_000 }
  end

  include StartCommand
  include CheckinCommand
  include Telegram::Bot::UpdatesController::MessageContext
end

TOKEN = '890059889:AAESf4Gi_a8Kq7pxM7xzGbJQVnhvLwp_TZQ'
bot = Telegram::Bot::Client.new(TOKEN)

# poller-mode
require 'logger'
logger = Logger.new(STDOUT)
poller = Telegram::Bot::UpdatesPoller.new(bot, WebhooksController, logger: logger)
poller.start
