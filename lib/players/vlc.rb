class Vlc < VideoPlayer
  def play_file(file)
    vlc ('open "' + file + '"')
  end

  def playpause
    vlc 'play'
  end

  def stop
    vlc 'stop'
  end

  def fullscreen
    vlc 'fullscreen'
  end

  def launched?
    %x(osascript -e 'tell app "System Events" to count (every process whose name is "vlc")' 2>/dev/null).rstrip
  end

  private
  def vlc(command)
    %x(osascript -e 'tell app "vlc" to #{command}').rstrip
    %x(osascript -e 'tell app "vlc" to activate')
  end
end
