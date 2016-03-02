class GitPlugin < DocBotPlugin
  attr_reader :msg

  include Cyclable
  
  def initialize
    set_commit
    set_branch
    @msg = ''
  end
  
  def msg_commit
    "#{ENV.fetch('NAME')} just committed some changes: #{@commit}\n"
  end

  def msg_branch
    "#{ENV.fetch('NAME')} is currently working on the #{@branch} branch\n"
  end

  def set_commit
    tmp_commit = `git log -1 --pretty=%B`
    @commit = tmp_commit and return true unless /^Merge branch/ === tmp_commit || Time.now.to_i - `git log -1 --pretty=%at`.to_i >= 10
    false
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
      if set_commit
        @msg = msg_commit
        return true
      end
    end
    false
  end
end
