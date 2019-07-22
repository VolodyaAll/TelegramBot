require 'redis'
require 'yaml'

module StartCommand

  def start!(*)
    return if registered_?

    save_context :register
    respond_with :message, text: 'Введи свой номер по лагерю:'
  end

  def register(*answer)
    respond_with :message, text: register_with_validation(answer)
  end

  def register_with_validation(number = nil, *)
    redis = Redis.new
    number = number.first.to_i

    if redis.get(number) || session.key?(:number)
      "Номер #{number} уже зарегистрирован, попробуй ещё -> /start!"
    elsif camp_numbers.include?(number)
      session[:number] = number
      redis.set(number, payload['from']['id'])
      session[:checkin] = false
      "Спасибо, #{session[:number]}, ты зарегистрирован. Можешь принять смену -> /checkin"
    else
      "Такого номера нет в списке, попробуй ещё -> /start!"
    end
  end

  def camp_numbers
    @camp_numbers ||= YAML.load_file('./data/camp_numbers.yml')['camp_numbers']
  end

  def registered_?
    respond_with :message, text: 'Ты уже зарегистрирован. Можешь принять смену -> /checkin' if session.key?(:number)
    session.key?(:number)
  end
end