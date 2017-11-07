module Lita
  module Handlers
    # DirectMessage Notification
    class DmNotifier < Handler
      feature :async_dispatch
      # insert handler code here
      http.post '/dm/notify', :send_notification

      # FORMAT:
      # {
      #   "user": "required username (mention) to send the message to",
      #   "author_name": "Optional author name"
      #   "author_link": "Optional link for the author"
      #   "author_icon": "Optional image for the author"
      #   "title": "Required title for the attachment",
      #   "title_link": "The link for the title on this attachment",
      #   "image_url": "Optional image to include",
      #   "thumb_url": "Optional Thumbnail to include",
      #   "footer_icon": "Optional icon to include in the footer",
      #   "footer": "Optional text for the footer",
      #   "pretext": "Optional text above the attachment",
      #   "text": "The message to send within the attachment, also fallback if not provided"
      #   "fallback": "Optional fallback text if client doesn't support the attachment"
      #   "fields": Array of json objects defining fields for slack
      # }
      def send_notification(request, _response)
        data = MultiJson.load(request.body, symbolize_keys: true)
        type = data.delete(:type)
        text = data.delete(:text)
        data[:fields] += [{ title: 'Type', value: type, short: true }]
        data.merge(color: get_color(type))
        log.debug("Received alert request for #{data[:user]}\n")
        payload = Lita::Adapters::Slack::Attachment.new(text, data)
        user = User.find_by_mention_name(data[:user])
        robot.chat_service.send_attachment(user, payload)
      end

      private

      def get_color(type)
        custom_types = { info: '#439FE0' }
        if %w(good warning danger).include?(type)
          type
        elsif custom_types.key?(type)
          custom_types[type]
        else
          '#000000'
        end
      end

      Lita.register_handler(self)
    end
  end
end
