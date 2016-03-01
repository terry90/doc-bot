class GitDiffPlugin < DocBotPlugin
  def msg(opts)
    message = opts[:data].text

    my_turn?(message) or return nil

    `git diff HEAD~ HEAD`
  end

  def my_turn?(m)
    m == "diff of #{ENV.fetch('NAME')} pls"
  end
  
  def ready
    true
  end
end
