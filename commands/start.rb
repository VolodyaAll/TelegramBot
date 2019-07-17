require 'telegram/bot'

module StartCommand

  def self.extended(base)
    base.class_eval do
      def start!
        respond_with :message, text: 'Hello!'
      end
    end
  end

end