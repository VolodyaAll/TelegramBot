require 'open-uri'
require 'fileutils'
require 'json'
require_relative 'helpers/base'
require_relative 'helpers/location'
require_relative 'helpers/photo'
require_relative 'helpers/save'

module CheckoutCommand
  include BaseCommandsHelper
  include LocationHelper
  include PhotoHelper
  include SaveHelper

  def checkout!(*)
    return unless registered?
    return unless checkined?

    save_context :checkout_photo
    respond_with :message, text: 'Пришли мне своё фото.'
  end

  def checkout_photo(*)
    if payload['photo']
      session[:path_to_photo] = path_to_photo
      save_context :checkout_location
      respond_with :message, text: 'Красава! Теперь пришли мне свои координаты.'
    else
      save_context :checkout_photo
      respond_with :message, text: 'Ты прислал что-то не то. Попробуй ещё раз.'
    end
  end

  def checkout_location(*)
    if valid_location?
      save_data('out')
      respond_with :message, text: 'Отдохни хорошенько и приходи снова -> /checkin'
    else
      save_context :checkout_location
      respond_with :message, text: 'Подойди поближе.'
    end
  end
end
