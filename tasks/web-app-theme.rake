namespace :web_app_theme do

	namespace :dependences do
		desc "Copies the web-app-theme dependences"
		task :install do
			puts "Installing plugins..."
			project_dir = RAILS_ROOT + '/public/javascripts/'
      plugin "jrails", :git => "git://github.com/aaronchi/jrails.git"
      rake "jrails:js:install"
			puts "Plugins installed successfully."
		end
  end

end

