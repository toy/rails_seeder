module RailsSeeder
  module Helpers
    require 'random_text'
    require 'progress'

    include RandomText

    srand 1

    Range.class_eval do
      def rand
        first + Kernel.rand(last - first + (exclude_end? ? 0 : 1))
      end
    end

    Integer.class_eval do
      def rand
        Kernel.rand(self)
      end

      ROMAN_SYMBOLS = {1=>'I', 5=>'V', 10=>'X', 50=>'L', 100=>'C', 500=>'D', 1000=>'M'}
      ROMAN_SUBTRACTORS = [[1000, 100], [500, 100], [100, 10], [50, 10], [10, 1], [5, 1], [1, 0]]
      def roman
        return ROMAN_SYMBOLS[self] if ROMAN_SYMBOLS.has_key?(self)
        ROMAN_SUBTRACTORS.each do |cutPoint, subtractor|
          return cutPoint.roman + (self - cutPoint).roman      if self >  cutPoint
          return subtractor.roman + (self + subtractor).roman  if self >= cutPoint - subtractor && self < cutPoint
        end
      end
    end

    Float.class_eval do
      def rand
        Kernel.rand * self
      end
    end

    NilClass.class_eval do
      def rand
        Kernel.rand
      end
    end

    def random_days_ago(max_days)
      rand(max_days - 1).days.ago - rand(23).hours - rand(59).minutes - rand(60).seconds
    end

    Array.class_eval do
      def shuffled_part(max = nil)
        max ||= length
        sort_by{ Kernel.rand }.slice(0, max.rand)
      end
    end
  end

  def self.new(name, &block)
    task :generate => "generate:#{name}"

    unless defined? @@regenerate_defined
      task :regenerate => 'db:migrate:reset'
      if Rake::Task.task_defined?('assets:delete')
        task :regenerate => 'assets:delete'
      end
      task :regenerate => :generate

      @@regenerate_defined = true
    end

    namespace :generate do
      desc "generate #{name}"
      task name => :environment do
        block.binding.eval("include #{self.name}::Helpers", __FILE__, __LINE__)
        block.call
      end
    end
  end
end
