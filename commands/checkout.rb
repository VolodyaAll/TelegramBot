require 'open-uri'
require 'fileutils'
require 'json'

module CheckoutCommand 
  def checkout!(*)
    return unless registered?
    return unless checkined?

    save_context :checkout_photo
    respond_with :message, text: 'Пришли мне своё фото.'
  end

  def checkout_photo(*)
    session[:timestamp] = Time.now.strftime("%Y-%m-%d_%H-%M-%S")

    FileUtils.mkdir_p(path_for_check) unless File.exist?(path_for_check)

    File.open(path_for_check + 'photo.jpg', 'wb') do |file|
      file << open("https://api.telegram.org/file/bot#{ENV['BOT_TOKEN']}/" + JSON.parse(URI.open(
        "https://api.telegram.org/bot#{ENV['BOT_TOKEN']}/" + 'getFile?file_id=' + payload['photo'].last['file_id'])
      .read, symbolize_names: true)[:result][:file_path]).read
    end

    save_context :checkout_geolocate
    respond_with :message, text: "Красава! Теперь пришли мне свои координаты."
  end

  def checkout_geolocate(*)
    File.open(path_for_check + 'location.txt', 'wb') do |file|
      file << payload['location']
    end
    session[:checkin] = false
    respond_with :message, text: 'Отдохни хорошенько и приходи снова -> /checkin'
  end

  def registered?
    respond_with :message, text: 'Сначала ты должен зарегистрироваться -> /start' unless session.key?(:number)
    session.key?(:number)
  end

  def checkined?
    respond_with :message, text: 'Сначала ты должен принять смену -> /checkin' unless session[:checkin]
    session[:checkin]
  end

  def path_for_check
    "./public/#{session[:number]}/checkouts/#{session[:timestamp]}/"
  end
end