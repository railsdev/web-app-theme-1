namespace :web_app_theme do

	namespace :dependences do
		desc "Copies the web-app-theme dependences"
		task :install do
			puts "Installing plugins..."
      source = File.join(RAILS_ROOT, '/vendor/plugins/web-app-theme/plugins/.')
      dest = File.join(RAILS_ROOT, '/vendor/plugins/')
      FileUtils.cp_r source, dest
			puts "Copying javascripts assistants..."
      source = File.join(RAILS_ROOT, '/vendor/plugins/web-app-theme/javascripts/.')
      dest = File.join(RAILS_ROOT, '/public/javascripts/')
      FileUtils.cp_r source, dest
			puts "Copying stylesheets assistants..."
			superfish_src = File.join(RAILS_ROOT, '/vendor/plugins/web-app-theme/stylesheets/superfish.css')
			superfish_dest = File.join(RAILS_ROOT, '/public/stylesheets/')
      FileUtils.cp_r superfish_src, superfish_dest
      FileUtils.cp_r File.join(RAILS_ROOT, '/vendor/plugins/web-app-theme/stylesheets/flexselect.css'), File.join(RAILS_ROOT, '/public/stylesheets/')
      flexselect.css
			puts "Copying images assistants..."
      FileUtils.cp_r File.join(RAILS_ROOT, '/vendor/plugins/web-app-theme/images/arrows-ffffff.png'), File.join(RAILS_ROOT, '/public/images/')
      FileUtils.cp_r File.join(RAILS_ROOT, '/vendor/plugins/web-app-theme/images/shadow.png'), File.join(RAILS_ROOT, '/public/images/')
      FileUtils.cp_r File.join(RAILS_ROOT, '/vendor/plugins/web-app-theme/images/spinner.gif'), File.join(RAILS_ROOT, '/public/images/')
      sh %{ script/generate formtastic }
      Rake::Task["jrails:js:install"].invoke
      Rake::Task["jrails:js:scrub"].invoke
      Rake::Task["inputs:install"].invoke
      Rake::Task["inputs:update"].invoke
			puts "Plugins installed successfully."
		end
  end

end

