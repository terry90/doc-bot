class GitCommitPlugin < DocBotPlugin
  def initialize
    @commit = ''
  end
  
  def msg
    "Doc just committed some changes: #{@commit}"
  end
  
  def ready
    if @commit != `git log -1 --pretty=%B`
      @commit = `git log -1 --pretty=%B`
      return true
    end
    false
  end
end
