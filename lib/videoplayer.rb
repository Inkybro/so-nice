class VideoPlayer
  VIDEO_PLAYERS = []

  def launched?
    false
  end

  def name
    self.class.to_s.gsub(/Player/, '')
  end

  def host
    %x(hostname).strip
  end

  def self.inherited(k)
    VIDEO_PLAYERS << k.new
  end

  def self.launched
    VIDEO_PLAYERS.find { |player| player.launched? }
  end
end
