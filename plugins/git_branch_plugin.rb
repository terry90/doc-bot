class GitBranchPlugin < DocBotPlugin
  def initialize
    @branch = ''
  end
  
  def msg
    "Doc is currently working on the #{@branch} branch"
  end
  
  def ready
    if @branch != `git rev-parse --abbrev-ref HEAD`
      @branch = `git rev-parse --abbrev-ref HEAD`
      return true
    end
    false
  end
end
