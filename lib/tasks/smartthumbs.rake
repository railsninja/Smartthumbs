namespace :smartthumbs do
  
  desc "Delte all created thumbs"
  task :delete_all do
    `rm -rf #{Rails.root}/public/th`
  end
  
  desc "delete all thumbs that are older than 1 day"
  task :delete_old do
    Dir["#{Rails.root}/public/th/**/**/*.jpg"].each do |f|
      File.delete(f) if File.mtime(f) < 1.day.ago
    end
  end  
  
end