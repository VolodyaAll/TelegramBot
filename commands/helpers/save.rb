require 'open-uri'
require 'fileutils'
require 'json'
require_relative 'base'

module SaveHelper
  include BaseCommandsHelper

  BOT_PATH_FOR_DOWNLOAD = "https://api.telegram.org/file/bot#{ENV['BOT_TOKEN']}/".freeze

  def save_data(str)
    make_dir(str)
    save_photo(str)
    save_location(str)
    session[:checkin] = !session[:checkin]
  end

  private

  def make_dir(str)
    session[:timestamp] = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
    FileUtils.mkdir_p(path_for_check(str))
  end

  def save_photo(str)
    File.open(path_for_check(str) + 'photo.jpg', 'wb') do |file|
      file << photo_for_download.read
    end
  end

  def save_location(str)
    File.open(path_for_check(str) + 'location.txt', 'wb') do |file|
      file << payload['location']
    end
  end

  def photo_for_download
    URI.open(BOT_PATH_FOR_DOWNLOAD + session[:path_to_photo])
  end
end
