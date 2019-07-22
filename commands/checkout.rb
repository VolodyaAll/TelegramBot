require 'open-uri'
require 'fileutils'
require 'json'
require_relative 'helpers/base'

module CheckoutCommand
  include BaseCommandsHelper

  def checkout!(*)
    return unless registered?
    return unless checkined?

    save_context :checkout_photo
    respond_with :message, text: 'Пришли мне своё фото.'
  end

  def checkout_photo(*)
    session[:timestamp] = Time.now.strftime("%Y-%m-%d_%H-%M-%S")

    FileUtils.mkdir_p(path_for_check('out')) unless File.exist?(path_for_check('out'))

    File.open(path_for_check('out') + 'photo.jpg', 'wb') do |file|
      file << open("https://api.telegram.org/file/bot#{ENV['BOT_TOKEN']}/" + JSON.parse(URI.open(
        "https://api.telegram.org/bot#{ENV['BOT_TOKEN']}/" + 'getFile?file_id=' + payload['photo'].last['file_id'])
      .read, symbolize_names: true)[:result][:file_path]).read
    end

    save_context :checkout_geolocate
    respond_with :message, text: "Красава! Теперь пришли мне свои координаты."
  end

  def checkout_geolocate(*)
    File.open(path_for_check('out') + 'location.txt', 'wb') do |file|
      file << payload['location']
    end
    session[:checkin] = false
    respond_with :message, text: 'Отдохни хорошенько и приходи снова -> /checkin'
  end

  def checkined?
    respond_with :message, text: 'Сначала ты должен принять смену -> /checkin' unless session[:checkin]
    session[:checkin]
  end
end