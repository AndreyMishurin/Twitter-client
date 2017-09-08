require 'twitter'
require 'optparse'

option = {}

OptionParser.new do |opt|
  opt.banner = 'Usage: twitter.rb [option]'

  opt.on('-h', 'Help') do
    puts opt
    exit
  end

  opt.on('--twit "Twit"', 'Затвитить "твит"') { |o| option[:twit] = o }
  opt.on('--timeline USER_NAME', 'Показать последние твиты') { |o| option[:timeline] = o }
end.parse!

client = Twitter::REST::Client.new do |config|
  config.consumer_key = ''
  config.consumer_secret = ''
  config.access_token = ''
  config.access_token_secret = ''
end

if option.key?(:twit)
  puts "Постим твит: #{option[:twit].encode("UTF-8")}"
  client.update(option[:twit])
  puts "Затвитили"
end

if option.key?(:timeline)
  puts "Лента юзера: #{option[:timeline]}"
  opts = {count: 10, include_rts: true}
  twits = client.user_timeline(option[:timeline], opts)
  twits.each do |twit|
    puts twit.text
    puts "by @#{twit.user.screen_name}, #{twit.created_at}"
    puts "-"*40
  end

else
  puts "Моя лента:"
  twits = client.home_timeline({count: 5})
  twits.each do |twit|
    puts twit.text
    puts "by @#{twit.user.screen_name}, #{twit.created_at}"
    puts "-"*40
  end
end
