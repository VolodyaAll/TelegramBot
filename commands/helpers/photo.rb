require 'open-uri'
require 'fileutils'
require 'json'
require_relative 'base'

module PhotoHelper
  include BaseCommandsHelper

  BOT_PATH = "https://api.telegram.org/bot#{ENV['BOT_TOKEN']}/".freeze

  def path_to_photo
    JSON.parse(URI.open(BOT_PATH + 'getFile?file_id=' + payload['photo'].last['file_id'])
                        .read, symbolize_names: true)[:result][:file_path]
  end
end
