# coding: utf-8
class CoveragePlugin < DocBotPlugin
  include Cyclable

  def initialize
    Dir.chdir ENV.fetch('APP_PATH') do
      set_coverage
      @last_coverage = @coverage
    end
  end

  def set_coverage
    @coverage = `cat coverage/raw_coverage`
    @last_coverage = @coverage if @last_coverage.to_f == 0
  end
  
  def msg(opts = {})
    set_coverage
    if @last_coverage.to_f > @coverage.to_f
      msg = "Nouveau coverage: #{@coverage.to_f.round(2)}%. A baissé de #{(@last_coverage.to_f - @coverage.to_f).round(2)}%... Shame on you"
    else
      msg = "Nouveau coverage: #{@coverage.to_f.round(2)}%. A augmenté de #{(@coverage.to_f - @last_coverage.to_f).round(2)}% ! Bien joué ;)"  
    end
    @last_coverage = @coverage
    "#{msg} (#{ENV.fetch('NAME')})"
  end
  
  def ready
    set_coverage
    @coverage != @last_coverage
  end
end
