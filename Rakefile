begin
  require 'jeweler'

  name = 'rails_seeder'
  summary = 'Rake helper to generate models for testing rails app'
  Jeweler::Tasks.new do |j|
    j.name = name
    j.summary = summary
    j.homepage = "http://github.com/toy/#{name}"
    j.authors = ['Ivan Kuchin']
    j.add_dependency 'rake'
    j.add_dependency 'rails'
    j.add_dependency 'random_text'
    j.add_dependency 'progress'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
