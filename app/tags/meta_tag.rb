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

## Meta ##
## {% meta %} ##
class MetaTag < Liquid::Tag

  def initialize(tag_name, params, tokens)
     super
     @tag_name = tag_name
     @params   = params
  end

  def render(context)
    case @params
      when :js, :javascript, :javascripts, :script, :scripts
        javascript_pack_tag	*args.compact #-> splat operator http://stackoverflow.com/questions/13795627/ruby-send-method-passing-multiple-parameters
      when :css, :stylesheet, :stylesheets
        stylesheet_pack_tag	*args.compact #-> splat operator http://stackoverflow.com/questions/13795627/ruby-send-method-passing-multiple-parameters
      when :title
        Haml::Engine.new("%title #{args.join(' ')}").render
      when :favicon
        favicon_link_tag "favicon.ico"
      when :csrf
        csrf_meta_tags
      else
        Haml::Engine.new("%meta{ name: \"#{type}\", content: \"#{args.join(', ')}\" }").render #-> http://stackoverflow.com/questions/9143761/meta-descritpion-in-haml-with-outside-variable
    end
    return @tag_name
  end

  private

  def description

  end

end

####################################################
####################################################

## Liquid ##
## Register the tag ##
Liquid::Template.register_tag('meta', MetaTag)

####################################################
####################################################
