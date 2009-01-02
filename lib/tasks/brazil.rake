namespace :brazil do
  desc "Reset the brazil application environment"
  task :reset => :environment do
    Rake::Task["db:migrate:reset"].invoke
    Rake::Task["spec:db:fixtures:load"].invoke
  end
end