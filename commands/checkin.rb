require 'open-uri'
require 'fileutils'
require 'json'
require_relative 'helpers/base'
require_relative 'helpers/location'
require_relative 'helpers/photo'

module CheckinCommand
  include BaseCommandsHelper
  include LocationHelper
  include PhotoHelper

  def checkin!(*)
    return unless registered?
    return unless checkouted?

    save_context :checkin_photo
    respond_with :message, text: 'Пришли мне своё фото.'
  end

  def checkin_photo(*)
    session[:timestamp] = Time.now.strftime("%Y-%m-%d_%H-%M-%S")

    FileUtils.mkdir_p(path_for_check('in')) unless File.exist?(path_for_check('in'))

    File.open(path_for_check('in') + 'photo.jpg', 'wb') do |file|
      file << open("https://api.telegram.org/file/bot#{ENV['BOT_TOKEN']}/" + JSON.parse(URI.open(
        "https://api.telegram.org/bot#{ENV['BOT_TOKEN']}/" + 'getFile?file_id=' + payload['photo'].last['file_id'])
      .read, symbolize_names: true)[:result][:file_path]).read
    end

    save_context :checkin_location
    respond_with :message, text: "Красава! Теперь пришли мне свои координаты. #{face}"
  end

  def checkin_location(*)    
    if save_valid_location?('in')
      session[:checkin] = true
      respond_with :message, text: 'Молодца! Удачной работы! Сдать смену можешь так -> /checkout'
    else
      save_context :checkin_location
      respond_with :message, text: 'Подойди поближе.'
    end
  end

  def checkouted?
    respond_with :message, text: 'Ты уже принял смену. Можешь её сдать -> /checkout' if session[:checkin]
    !session[:checkin]
  end
end