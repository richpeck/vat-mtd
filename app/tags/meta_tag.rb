####################################################
####################################################
##               __  ___     __                   ##
##              /  |/  /__  / /_____ _            ##
##             / /|_/ / _ \/ __/ __ `/            ##
##            / /  / /  __/ /_/ /_/ /             ##
##           /_/  /_/\___/\__/\__,_/              ##
##                                                ##
####################################################
####################################################
## The meta tag designed to provide users with a way to include meta objects in the view
## To use, call {% meta %} in the viewport and it will show
####################################################
####################################################

#require 'action_view/helpers'

## Meta ##
## {% meta %} ##
class MetaTag < Liquid::Tag

  #include ::ActionView::Helpers::AssetTagHelper

  # => Initialize
  # => Allows us to define the various variables for use in the class
  def initialize(tag_name, params, tokens)
     super
     @a      = ::Autoload.new.helpers # => https://stackoverflow.com/a/18965066/1143732
     @tag_name = tag_name
     @params   = params.split(":").map(&:strip)
  end

  # => Render
  # => This renders the outputted code to the viewport
  def render(context)
    ::Autoload.new.helpers.send(@params.first.to_s, @params.last.to_s)
  end

  private

  # => Title
  # => HTML <title> tag used in HTML page markup
  def title(context)
    "<title>{{ #{@params.last} }}</title>"
  end

  # => Description
  # => Provides us with the ability to create a meta "description" tag
  def description(context)

  end

  # => Javascript
  #def javascript(context)
  #  stylesheet_link_tag @params.last
  #  #::Autoload.new.helpers.javascript_tag @params.last
  #end

  # => Stylesheet
  #def stylesheet(context)
  #  ::Autoload.new.helpers.stylesheet_tag @params.last
  #end

end


#case @params.first.to_sym
#when :js, :javascript, :javascripts, :script, :scripts, :javascript_tag
#    javascript_include_tag	@params.last.split(",").compact #-> splat operator http://stackoverflow.com/questions/13795627/ruby-send-method-passing-multiple-parameters
#  when :css, :stylesheet, :stylesheet, :stylesheet_tag
#    stylesheet_link_tag	@params.last.split(",").compact #-> splat operator http://stackoverflow.com/questions/13795627/ruby-send-method-passing-multiple-parameters
#  when :favicon
#    favicon_link_tag "favicon.ico"
#  when :csrf
#    csrf_meta_tags
#  else
#    Haml::Engine.new("%meta{ name: \"#{type}\", content: \"#{args.join(', ')}\" }").render #-> http://stackoverflow.com/questions/9143761/meta-descritpion-in-haml-with-outside-variable
#end

####################################################
####################################################

## Liquid ##
## Register the tag ##
Liquid::Template.register_tag('meta', MetaTag)

####################################################
####################################################
