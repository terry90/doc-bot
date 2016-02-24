class GitPlugin < DocBotPlugin
  attr_reader :msg

  include Cyclable
  
  def initialize
    set_commit
    set_branch
    @msg = ''
  end
  
  def msg_commit
    "Doc just committed some changes: #{@commit}\n"
  end

  def msg_branch
    "Doc is currently working on the #{@branch} branch\n"
  end

  def set_commit
    @commit = `git log -1 --pretty=%B`
    true
  end
  
  def set_branch
    @branch = `git rev-parse --abbrev-ref HEAD`
    true
  end
  
  def branch_changed
    @branch != `git rev-parse --abbrev-ref HEAD`
  end
  
  def ready
    if branch_changed
      set_commit
      set_branch
      @msg = msg_branch
      return true
    else
      if @commit != `git log -1 --pretty=%B`
        set_commit
        @msg = msg_commit
        return true
      end
    end
    false
  end
end
