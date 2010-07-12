namespace :web_app_theme do

	namespace :dependences do
		desc "Copies the web-app-theme dependences"
		task :install do
			puts "Installing plugins..."
#      sh %{ script/plugin install git://github.com/andreferraro/jrails.git }
#      sh %{ script/plugin install git://github.com/redinger/validation_reflection.git }
#      sh %{ script/plugin install git://github.com/jtadeulopes/inputs.git }
#      sh %{ script/plugin install git://github.com/andreferraro/formtastic.git }
			puts "Copying javascripts assistants..."
			project_dir = RAILS_ROOT + '/public/javascripts/'
			scripts = Dir[File.join(File.dirname(__FILE__), '..', '/javascripts/', '*.js')]
			FileUtils.cp(scripts, project_dir)
			puts "Copying stylesheets assistants..."
			style_dir = RAILS_ROOT + '/public/stylesheets/'
			styles = Dir[File.join(File.dirname(__FILE__), '..', '/stylesheets/', '*.css')]
			FileUtils.cp(styles, style_dir)
			puts "Copying images assistants..."
      FileUtils.cp_r File.join(RAILS_ROOT, '/vendor/plugins/web-app-theme/images/arrows-ffffff.png'), File.join(RAILS_ROOT, '/public/images/')
      FileUtils.cp_r File.join(RAILS_ROOT, '/vendor/plugins/web-app-theme/images/shadow.png'), File.join(RAILS_ROOT, '/public/images/')
      FileUtils.cp_r File.join(RAILS_ROOT, '/vendor/plugins/web-app-theme/images/spinner.gif'), File.join(RAILS_ROOT, '/public/images/')
      puts "Copying help images"
			FileUtils.mkdir RAILS_ROOT + '/public/images/ajuda'
  		imgajuda_dir = RAILS_ROOT + '/public/images/ajuda/'
  		imgajuda = Dir[File.join(File.dirname(__FILE__), '..', '/images/ajuda/', '*.png')]
  		FileUtils.cp(imgajuda, imgajuda_dir)
#      sh %{ script/generate formtastic }
#      sh %{ rake jrails:js:install }
#      sh %{ rake jrails:js:scrub }
#      sh %{ rake inputs:install }
#      sh %{ rake inputs:update }
			puts "Plugins installed successfully."
		end
  end

end

