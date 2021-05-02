####################################################
####################################################
##             ______                             ##
##            / ____/___  _________ ___           ##
##           / /_  / __ \/ ___/ __ `__ \          ##
##          / __/ / /_/ / /  / / / / / /          ##
##         /_/    \____/_/  /_/ /_/ /_/           ##
##                                                ##
####################################################
####################################################
## Allows us to build the form tag using Padrino Helper's "form_for" method
## because of the nature of the tag, need to ensure we can return a block
####################################################
####################################################

## Form ##
## {% form 'x' %} {% endform %} ##
class FormTag < ::Liquid::Block

  # => Init
  # => This allows us to create a form by passing the various arguments to the "form_for" method within Pardino Helpers
  def initialize(tag_name, markup, tokens)
     super
     @form = markup.to_i
  end

  def render(context)
    form_for = ::Autoload.new.helpers.form_for
    super.sub('^^^', value.to_s)  # calling `super` returns the content of the block
  end
end

####################################################
####################################################

## Liquid ##
## Register the tag ##
Liquid::Template.register_tag('form', FormTag)

####################################################
####################################################
