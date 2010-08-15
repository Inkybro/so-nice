#!/usr/bin/env ruby

require 'sinatra'
require 'haml'

require 'lib/musicplayer'
require 'lib/videoplayer'
Dir[File.dirname(__FILE__) + '/lib/players/*'].each { |f| require f }

configure do
  $musicplayer = MusicPlayer.launched or abort "Error: no music player launched!"
  $videoplayer = VideoPlayer.launched or abort "Error: no video player launched!"
end

get '/' do
  haml :index 
end

get '/music' do
  @title = $musicplayer.current_track
  @artist = $musicplayer.current_artist
  @album = $musicplayer.current_album
  haml :music
end

get '/videos' do
  @videos = Dir.glob('*').select { |fn| File.directory?(fn) } 
  Dir.glob('*.avi').each { |file| @videos << file }
  @videos << ".."
  @videos.sort!
  haml :videos
end

post '/musicplayer' do
  params.each { |k, v| $musicplayer.send(k) if $musicplayer.respond_to?(k) }
  redirect '/music'
end

post '/videoplayer' do
  params.each do |k, v|
    if k == "play_file"
      if File.directory?(v)
        Dir.chdir(v)
        redirect '/videos'
      else
        $videoplayer.send(k, v)
      end
    else
      $videoplayer.send(k) if $videoplayer.respond_to?(k)
    end
  end
  redirect '/videos'
end

