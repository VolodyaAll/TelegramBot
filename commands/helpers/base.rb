module BaseCommandsHelper
  def start_registered?
    respond_with :message, text: registred_not_checkined if session.key?(:number) && checkouted?
    session.key?(:number)
  end

  def registered?
    respond_with :message, text: 'Надо зарегистрироваться -> /start' unless session.key?(:number)
    session.key?(:number)
  end

  def checkined?
    respond_with :message, text: 'Сначала прими смену -> /checkin' unless session[:checkin]
    session[:checkin]
  end

  def checkouted?
    respond_with :message, text: 'Ты принял смену.Можешь её сдать -> /checkout' if session[:checkin]
    !session[:checkin]
  end

  def path_for_check(str)
    "./public/#{session[:number]}/check#{str}s/#{session[:timestamp]}/"
  end

  private

  def registred_not_checkined
    "#{session[:number]}, ты уже зарегистрирован. Можешь принять смену -> /checkin"
  end
end
