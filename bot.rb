require 'telegram/bot'
require_relative 'commands/start'
require_relative 'commands/checkin'
require_relative 'commands/checkout'
require_relative 'commands/logout'

class WebhooksController < Telegram::Bot::UpdatesController
  include StartCommand
  include CheckinCommand
  include CheckoutCommand
  include LogoutCommand
  include Telegram::Bot::UpdatesController::MessageContext

  ONE_MONTH = 2_592_000

  def initialize(*)
    super
    Telegram::Bot::UpdatesController.session_store = :redis_store, { expires_in: 1.5 * ONE_MONTH }
  end
end

bot = Telegram::Bot::Client.new(ENV['BOT_TOKEN'])

# poller-mode
require 'logger'
logger = Logger.new(STDOUT)
poller = Telegram::Bot::UpdatesPoller.new(bot, WebhooksController, logger: logger)
poller.start
