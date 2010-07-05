class ThemedGenerator < Rails::Generator::NamedBase

  default_options :app_name => 'Web App',
                  :themed_type => :crud,
                  :layout => false,
                  :will_paginate => true,
                  :engine => :erb,
                  :ajaxpage => false,
                  :declarative_auth => false,
                  :tinymce => false,
                  :removeall => false,
                  :flexselect => false,
                  :datepicker => false,
                  :searchlogic => false

  attr_reader :controller_routing_path,
              :singular_controller_routing_path,
              :columns,
              :model_name,
              :plural_model_name,
              :resource_name,
              :plural_resource_name,
              :engine,
              :ajaxpage,
              :declarative_auth,
              :tinymce,
              :removeall,
              :flexselect,
              :datepicker,
              :searchlogic,
              :listfields,
              :fieldlist

  def initialize(runtime_args, runtime_options = {})
    super
    @controller_path  = runtime_args.shift
    @model_name       = runtime_args.shift
    @engine           = options[:engine]
  end

  def manifest
    @controller_routing_path          = @table_name
    @singular_controller_routing_path = @table_name.singularize
    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_path)
    @model_name = base_name.singularize unless @model_name

    # Post
    @model_name           = @model_name.camelize
    # Posts
    @plural_model_name    = @model_name.pluralize
    # post
    @resource_name        = @model_name.underscore
    # posts
    @plural_resource_name = @resource_name.pluralize

    manifest_method = "manifest_for_#{options[:themed_type]}"
    record do |m|
      send(manifest_method, m) if respond_to?(manifest_method)
    end
  end

protected

  def manifest_for_crud(m)
    @columns = get_columns
    m.directory(File.join('app/views', @controller_file_path))
    if options[:ajaxpage]
      m.template("view_tables_ajax.html.#{@engine}",  File.join("app/views", @controller_file_path, "index.html.#{@engine}"))
      m.template("view_tables_listagem.html.#{@engine}",  File.join("app/views", @controller_file_path, "_listagem.html.#{@engine}"))
      FileUtils.copy('vendor/plugins/web-app-theme/rails_generators/themed/templates/index.js.erb', 'app/views/' + @controller_file_path.to_s + '/index.js.erb')
    else
      m.template("view_tables.html.#{@engine}",  File.join("app/views", @controller_file_path, "index.html.#{@engine}"))
    end
    m.template("view_new.html.#{@engine}",     File.join("app/views", @controller_file_path, "new.html.#{@engine}"))
    m.template("view_edit.html.#{@engine}",    File.join("app/views", @controller_file_path, "edit.html.#{@engine}"))
    m.template("view_form.html.#{@engine}",    File.join("app/views", @controller_file_path, "_form.html.#{@engine}"))
    m.template("view_show.html.#{@engine}",    File.join("app/views", @controller_file_path, "show.html.#{@engine}"))
    m.template("view_sidebar.html.#{@engine}", File.join("app/views", @controller_file_path, "_sidebar.html.#{@engine}"))

    if options[:layout]
      #TODO fix this for haml
      m.gsub_file(File.join("app/views/layouts", "#{options[:layout]}.html.#{@engine}"), /\<div\s+id=\"main-navigation\">.*\<\/ul\>/mi) do |match|
        if !match.index(controller_routing_path)
          match.gsub!(/\<\/ul class\=\"sf\-menu\"\>/, "")
          match=match.gsub("</ul>","")
          if @engine.to_s =~ /haml/
            %|#{match}
          %li{:class => controller.controller_path == '#{@controller_file_path}' ? 'active' : '' }
            %a{:href => #{controller_routing_path}_path} #{plural_model_name}
          </ul>|
          else
            %|#{match} <li class="<%= controller.controller_path == '#{@controller_file_path}' ? 'active' : '' %>"><a href="<%= #{controller_routing_path}_path %>">#{plural_model_name}</a></li></ul>|
          end
        else
          %|#{match}|
        end
      end
    end
  end

  def manifest_for_restful_authentication(m)
    signup_controller_path  = @controller_file_path
    signin_controller_path  = @model_name.downcase # just here I use the second argument as a controller path
    @resource_name          = @controller_path.singularize
    m.template("view_signup.html.#{@engine}",  File.join("app/views", signup_controller_path, "new.html.#{@engine}"))
    m.template("view_signin.html.#{@engine}",  File.join("app/views", signin_controller_path, "login.html.#{@engine}"))
  end

  def manifest_for_text(m)
    m.directory(File.join('app/views', @controller_file_path))
    m.template("view_text.html.#{@engine}", File.join("app/views", @controller_file_path, "show.html.#{@engine}"))
    m.template("view_sidebar.html.#{@engine}", File.join("app/views", @controller_file_path, "_sidebar.html.#{@engine}"))
  end

  def get_columns
    excluded_column_names = %w[id created_at updated_at]
    Kernel.const_get(@model_name).columns.reject{|c| excluded_column_names.include?(c.name) }.collect{|c| Rails::Generator::GeneratedAttribute.new(c.name, c.type)}
  end

  def banner
    "Usage: #{$0} themed ControllerPath [ModelName] [options]"
  end

  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--app_name=app_name", String, "") { |v| options[:app_name] = v }
    opt.on("--type=themed_type", String, "") { |v| options[:themed_type] = v }
    opt.on("--layout=layout", String, "Add menu link") { |v| options[:layout] = v }
    opt.on("--with_will_paginate", "Add pagination using will_paginate") { |v| options[:will_paginate] = true }
    opt.on("--engine=haml", "Use HAML instead of ERB template engine") { |v| options[:engine] = v }
    opt.on("--ajaxpage", "Add pagination using will_paginate with Ajax") { |v| options[:ajaxpage] = v }
    opt.on("--declarative_auth", "Add support to Declarative Authorization") { |v| options[:declarative_auth] = true }
    opt.on("--tinymce", "Add support to TinyMCE") { |v| options[:tinymce] = true }
    opt.on("--removeall", "Add remove all form") { |v| options[:removeall] = true }
    opt.on("--flexselect", "Define the class flexselect to dropdown fields") { |v| options[:flexselect] = true }
    opt.on("--datepicker", "Define DatePicker to Date fields") { |v| options[:datepicker] = true }
    opt.on("--searchlogic", "Add support to Searchlogic order records on index page") { |v| options[:searchlogic] = true }
    opt.on("--listfields=campo1:titulo1;campo2:titulo2", "Field list of index page") { |v| options[:listfields] = v }
    opt.on("--fieldlist=file", "Path of field list definitions on format: field,label,hint,mask. One per line.") { |v| options[:fieldlist] = v }
  end

end

