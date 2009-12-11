namespace :will_filter do
  desc "Sync extra files from blogify plugin."
  task :sync do
    system "rsync -ruv vendor/plugins/will_filter/db/migrate db"
    system "rsync -ruv vendor/plugins/will_filter/public ."
  end
end