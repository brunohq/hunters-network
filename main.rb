#!/usr/bin/ruby
require 'csv'
require 'twitter'
require 'hunting_season'
require 'optparse'

# default options
SLICE_SIZE = 100
verbose = false
username = ''

ARGV.options do |opts|
  opts.on('-v', '--verbose') { verbose = true }
  opts.on('-u', '--user=val', String) { |val| username = val }
  opts.parse!
end

def twitter_client(configs)
  Twitter::REST::Client.new do |config|
    config.consumer_key        = configs['twitter']['consumer_key']
    config.consumer_secret     = configs['twitter']['consumer_secret']
    config.access_token        = configs['twitter']['access_token']
    config.access_token_secret = configs['twitter']['access_token_secret']
  end
end

def producthunt_client(configs)
  ProductHunt::Client.new(configs['producthunt']['key'])
end

def fetch_friends_hunters(username, options)
  client_tw = twitter_client(options[:configs])
  client_ph = producthunt_client(options[:configs])
  hunters = []

  client_tw.friend_ids(username).each_slice(SLICE_SIZE).with_index do |slice, i|
    client_tw.users(slice).each_with_index do |f, j|
      begin
        user = client_ph.user(f.screen_name)

        hunter = {
          username: f.screen_name,
          name: "#{user['name']}" ,
          votes: user['votes_count'],
          posts_count: user['posts_count'],
          maker_of_count: user['maker_of_count'],
          followers_count: user['followers_count'],
          followings_count: user['followings_count']
        }
        hunters.push(hunter)
        puts "#{i * SLICE_SIZE + j + 1}: #{f.screen_name} is a HUNTER" if options[:verbose]
      rescue RuntimeError
        puts "#{i * SLICE_SIZE + j + 1}: #{f.screen_name} is not" if options[:verbose]
      end
    end
  end

  return hunters
end

def save_results(username, hunters)
  CSV.open("#{username}_top_frindes_hunters.csv", 'wb') do |csv|
    # csv << hunters.first.keys # adds the attributes name on the first line
    hunters.each do |hash|
      csv << hash.values
    end
  end
end

configs = YAML.load_file('config.yml')
if username == ''
  client_tw = twitter_client(configs)
  username = client_tw.current_user.screen_name
end
hunters = fetch_friends_hunters(username, { configs: configs, verbose: verbose })
hunters.sort! { |x, y| y[:followers_count] <=> x[:followers_count] }
save_results(username, hunters)
