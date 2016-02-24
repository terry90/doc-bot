require 'uri'
require 'social_shares'

class FacebookSharePlugin < DocBotPlugin
  def get_share(url)
    SocialShares.facebook url
  end
  
  def msg(opts)
    message = opts[:data].text

    my_turn?(message) or return nil

    ret = ''

    urls = URI.extract(message)
    shares = []
    urls.each do |url|
      shares << get_share(url)
    end
    shares.join(', ')
  end

  def my_turn?(m)
    m.include?('facebook') && URI.extract(m).length != 0
  end
  
  def ready
    true
  end
end
