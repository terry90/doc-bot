# coding: utf-8

class DocBotPlugin
  attr_reader :channel

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

    def each_cyclable(&block)
      registry.select { |plugin| plugin.cyclable? }.each do |member|
        block.call(member)
      end
    end

    def each_matchable(&block)
      registry.select { |plugin| plugin.matchable? }.each do |member|
        block.call(member)
      end
    end
  end

  def initialize
    @channel = '#tech'
  end

  def ready # To be overriden in plugins
    false
  end

  def msg(opts = {}) # To be overriden in plugins
    nil
  end

  def cyclable?
    false
  end

  def matchable?
    true
  end
end

module Cyclable # To be included in cyclable plugins (plugins needing to be runned each x seconds)
  def cyclable?
    true
  end

  def matchable?
    false
  end
end
