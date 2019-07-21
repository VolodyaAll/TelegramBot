require 'open-uri'
require 'fileutils'
require 'json'

module CheckinCommand
  def checkin!(*)
    return if registered?

    save_context :checkin_photo
    respond_with :message, text: 'Пришли мне своё фото.'
  end

  def checkin_photo(*)
    session[:timestamp] = Time.now.strftime("%Y-%m-%d_%H-%M-%S")

    FileUtils.mkdir_p(path_for_check) unless File.exist?(path_for_check)

    File.open(path_for_check + 'photo.jpg', 'wb') do |file|
      file << open("https://api.telegram.org/file/bot#{ENV['BOT_TOKEN']}/" + JSON.parse(URI.open(
        "https://api.telegram.org/bot#{ENV['BOT_TOKEN']}/" + 'getFile?file_id=' + payload['photo'].last['file_id'])
      .read, symbolize_names: true)[:result][:file_path]).read
    end

    save_context :checkin_geolocate
    respond_with :message, text: "Красава! Теперь пришли мне свои координаты."
  end

  def checkin_geolocate(*)
    File.open(path_for_check + 'location.txt', 'wb') do |file|
      file << payload['location']
    end
    respond_with :message, text: "Молодца! Удачной работы!"
  end

  def registered?
    respond_with :message, text: 'Сначала ты должен зарегистрироваться -> /start!' unless session.key?(:number)
    !session.key?(:number)
  end

  def path_for_check
    "./public/#{session[:number]}/checkins/#{session[:timestamp]}/"
  end
end