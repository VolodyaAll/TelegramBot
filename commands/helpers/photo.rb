require 'open-uri'
require 'fileutils'
require 'json'
require 'face_detect'
require 'face_detect/adapter/google'

module PhotoHelper
  
  def face
input = File.new(open("https://api.telegram.org/file/bot#{ENV['BOT_TOKEN']}/" + JSON.parse(URI.open(
  "https://api.telegram.org/bot#{ENV['BOT_TOKEN']}/" + 'getFile?file_id=' + payload['photo'].last['file_id'])
.read, symbolize_names: true)[:result][:file_path]))
detector = FaceDetect.new(
  file: input,
  adapter: FaceDetect::Adapter::Google
)
results = detector.run

face = results.first


  # FileUtils.mkdir_p(path_for_check('in')) unless File.exist?(path_for_check('in'))

  # File.open(path_for_check('in') + 'photo.jpg', 'wb') do |file|
  #   file << open("https://api.telegram.org/file/bot#{ENV['BOT_TOKEN']}/" + JSON.parse(URI.open(
  #     "https://api.telegram.org/bot#{ENV['BOT_TOKEN']}/" + 'getFile?file_id=' + payload['photo'].last['file_id'])
  #   .read, symbolize_names: true)[:result][:file_path]).read
  # end

  return face
end
end
