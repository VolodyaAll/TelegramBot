require 'telegram/bot'
require_relative 'commands/start'
require_relative 'commands/checkin'
require_relative 'commands/checkout'

class WebhooksController < Telegram::Bot::UpdatesController
  include StartCommand
  include CheckinCommand
  include CheckoutCommand
  include Telegram::Bot::UpdatesController::MessageContext

  def initialize(*)
    super
    Telegram::Bot::UpdatesController.session_store = :redis_store, { expires_in: 3_888_000 }
  end
end

bot = Telegram::Bot::Client.new(ENV['BOT_TOKEN'])

# poller-mode
require 'logger'
logger = Logger.new(STDOUT)
poller = Telegram::Bot::UpdatesPoller.new(bot, WebhooksController, logger: logger)
poller.start
