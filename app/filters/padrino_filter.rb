######################################################################
######################################################################
##     ____            __     _             _______ ____            ##
##    / __ \____ _____/ /____(_)___  ____  / ____(_) / /____  _____ ##
##   / /_/ / __ `/ __  / ___/ / __ \/ __ \/ /_  / / / __/ _ \/ ___/ ##
##  / ____/ /_/ / /_/ / /  / / / / / /_/ / __/ / / / /_/  __/ /     ##
## /_/    \__,_/\__,_/_/  /_/_/ /_/\____/_/   /_/_/\__/\___/_/      ##
##                                                                  ##
######################################################################
######################################################################

# => Padrino Filter
# => Delegate the padrino helpers to the application helpers
# => {{ 'app' | link_to ... }}
module PadrinoFilter

  # => Methods
  # => Delegate as much as possible
  # => https://github.com/chamnap/liquid-rails/blob/master/lib/liquid-rails/filters/asset_tag_filter.rb
  delegate :link_to, :flash_tag, to: :__h__

  private

  # => Private
  # => Allows us to call the functionality without exposing the method publicly
  def __h__
    ::Autoload.new.helpers
  end

end

######################################################################
######################################################################

## Liquid ##
## Register the filter ##
Liquid::Template.register_filter(PadrinoFilter)

######################################################################
######################################################################
