namespace :web_app_theme do

	namespace :dependences do
		desc "Copies the web-app-theme dependences"
		task :install do
			puts "Installing plugins..."
      source = File.join(RAILS_ROOT, '/vendor/plugins/web-app-theme/plugins/.')
      dest = File.join(RAILS_ROOT, '/vendor/plugins/')
      FileUtils.cp_r source, dest
      sh %{ script/generate formtastic }
      Rake::Task["jrails:js:install"].invoke
      Rake::Task["jrails:js:scrub"].invoke
      Rake::Task["inputs:update"].invoke
			puts "Plugins installed successfully."
		end
  end

end

