#!/usr/bin/env ruby

require 'sinatra'
require 'haml'

require 'lib/player'
Dir[File.dirname(__FILE__) + '/lib/players/*'].each { |f| require f }

enable :inline_templates

configure do
  $player = MusicPlayer.launched or abort "Error: no music player launched!"
end

post '/player' do
  params.each { |k, v| $player.send(k) if $player.respond_to?(k) }
  redirect '/'
end

get '/' do
  @title = $player.current_track
  @artist = $player.current_artist
  @album = $player.current_album
  haml :index
end
