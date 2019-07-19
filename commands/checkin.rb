module CheckinCommand
  def checkin!(*)
    return if registered?

    save_context :photo_for_checkin
    respond_with :message, text: 'Пришли мне своё фото.'
  end

  def photo_for_checkin(_context = nil, *)
    session[:timestamp] = Time.now.getutc
    path_for_checkins = "./public/#{session[:number]}/checkins/#{session[:timestamp]}/"
    FileUtils.mkdir_p(path_for_checkins) unless File.exist?(path_for_checkins)
    respond_with :message, text: 'Теперь пришли мне свои координаты'
  end

  def registered?
    respond_with :message, text: 'Сначала ты должен зарегистрироваться.' unless session.key?(:number)
    !session.key?(:number)
  end
end