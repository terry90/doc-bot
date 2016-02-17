# coding: utf-8

class DocBotPlugin
  class << self
    def inherited(base)
      registry << base.new
    end

    def registry
      @registry ||= []
    end

    def each(&block)
      registry.each do |member|
        block.call(member)
      end
    end

    def each_c(&block)
      registry.map(&:class).each do |member|
        block.call(member)
      end
    end
    
    def ready
      false
    end
  end
end
