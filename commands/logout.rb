require 'redis'
require_relative 'helpers/base'

module LogoutCommand
  include BaseCommandsHelper

  def logout!(*)
    return unless registered?
    return unless checkouted?

    good_bye
  end

  private

  def good_bye
    redis = Redis.new
    redis.del(session[:number])
    session.delete(:number)
    respond_with :message, text: 'Счастливо! Можешь зарегистрироваться снова -> /start'
  end
end
