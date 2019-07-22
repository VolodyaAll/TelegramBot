require 'redis'

module LogoutCommand

  def logout!(*)
    return unless registered?

    redis = Redis.new
    redis.del(session[:number])
    session.delete(:number)
    respond_with :message, text: 'Счастливо! Можешь зарегистрироваться снова -> /start'
  end

  def registered?
    respond_with :message, text: 'Сначала ты должен зарегистрироваться -> /start' unless session.key?(:number)
    session.key?(:number)
  end
end