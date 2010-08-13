#!/usr/bin/env ruby

require 'sinatra'
require 'haml'

require 'lib/player'
Dir[File.dirname(__FILE__) + '/lib/players/*'].each { |f| require f }

configure do
  $player = MusicPlayer.launched or abort "Error: no music player launched!"
end

get '/' do
  haml :index 
end

get '/music' do
  @title = $player.current_track
  @artist = $player.current_artist
  @album = $player.current_album
  haml :music
end

post '/player' do
  params.each { |k, v| $player.send(k) if $player.respond_to?(k) }
  redirect '/'
end

