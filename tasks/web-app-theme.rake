namespace :web_app_theme do

	namespace :dependences do
		desc "Copies the web-app-theme dependences"
		task :install do
			puts "Installing plugins..."
      source = File.join(RAILS_ROOT, '/vendor/plugins/web-app-theme/plugins/.')
      dest = File.join(RAILS_ROOT, '/vendor/plugins/')
      FileUtils.cp_r source, dest
      rake "jrails:js:install"
      rake "jrails:js:scrub"
			puts "Plugins installed successfully."
		end
  end

end

