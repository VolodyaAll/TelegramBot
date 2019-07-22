module BaseCommandsHelper
  def registered?
      respond_with :message, text: 'Сначала ты должен зарегистрироваться -> /start' unless session.key?(:number)
      session.key?(:number)
  end

  def path_for_check(str)
    "./public/#{session[:number]}/check#{str}s/#{session[:timestamp]}/"
  end
end