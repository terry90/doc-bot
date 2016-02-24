#!/usr/bin/env ruby
# coding: utf-8

require 'slack-ruby-bot'
require_relative 'wording.rb'
require 'dotenv'
require_relative 'doc_bot_plugin.rb'
Dir["plugins/*.rb"].each {|file| require File.join(File.dirname(__FILE__), file) }

Dotenv.load

puts "Registered plugins: #{DocBotPlugin.each_c(&:to_s).join(', ')}"

def sa_send(opts)
  opts[:as_user] ||= true
  client = Slack::Web::Client.new
  client.auth_test
  client.chat_postMessage(opts)
end

class DocBot < SlackRubyBot::Bot
  # Examples of match BEGIN ---------- (To be converted in plugin)

  match(/^wake up idiot$/i) do |client, data, match|
    client.web_client.chat_postMessage(
      channel: data.channel,
      as_user: true,
      text: Wording::URGENT.sample,
    )
    
    exec './urgent.sh'
  end

  match(/^j'adore le foie gras et les papillons morts$/i) do |client, data, match|
    client.say(text: 'Demande a Terry ! Il est sympa :)', channel: data.channel)
  end

  match(/chat/i) do |client, data, match|
    client.say(channel: data.channel, text: "Chat ! CHAAAAT", gif: 'lolcat')
  end
  
  match(/yolo/i) do |client, data, match|
    client.say(text: 'swag', channel: data.channel)
  end

  match(/^oui$/i) do |client, data, match|
    client.say(text: ['non', 'oui?', 'ok', 'NON!', 'ಠ_ಠ'].sample, channel: data.channel)
  end
  
  match(/cool/i) do |client, data, match|
    client.say(text: Wording::COOL.sample, channel: data.channel)
  end

  # Examples of match END ------------

  # Plugins queried when someone sends a msg

  match(/.*/) do |client, data, match|
    DocBotPlugin.each_matchable do |plugin|
      sa_send(channel: data.channel, text: plugin.msg({data: data, client: client})) if plugin.ready
    end
  end
end

# To be converted in plugin --------

Thread.new do
  loop do
    stime = Random.rand(5000) + 3600
    puts "Next message in #{stime / 60} minutes"
    sleep stime
    sa_send(channel: '#random', text: Wording::OBEY.sample)
  end
end

# END ------------------------------

# Plugins queried each x seconds

Thread.new do
  loop do
    DocBotPlugin.each_cyclable do |plugin|
      sa_send(channel: '#tech', text: plugin.msg) if plugin.ready
    end
    sleep 5
  end
end

DocBot.run
