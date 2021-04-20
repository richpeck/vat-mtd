############################################################
############################################################
##     ___                   __  _______ ____             ##
##    /   |  _____________  / /_/ ____(_) / /____  _____  ##
##   / /| | / ___/ ___/ _ \/ __/ /_  / / / __/ _ \/ ___/  ##
##  / ___ |(__  |__  )  __/ /_/ __/ / / / /_/  __/ /      ##
## /_/  |_/____/____/\___/\__/_/   /_/_/\__/\___/_/       ##
##                                                        ##
############################################################
############################################################

# => Asset Filter
# => These are used to hook into the sprockets-helper gem (https://github.com/petebrowne/sprockets-helpers/blob/master/lib/sprockets/helpers.rb)
# => {{ 'app' | stylesheet_tag }}
module AssetFilter

  # => Methods
  # => Delegate as much as possible
  # => https://github.com/chamnap/liquid-rails/blob/master/lib/liquid-rails/filters/asset_tag_filter.rb
  delegate :stylesheet_tag, :javascript_tag, :audio_path, :font_path, :image_path, :javascript_path, :stylesheet_path, :video_path, to: :__h__

  private

  # => Private
  # => Allows us to call the functionality without exposing the method publicly
  def __h__
    ::Autoload.new.helpers
  end

end

############################################################
############################################################

## Liquid ##
## Register the filter ##
Liquid::Template.register_filter(AssetFilter)

############################################################
############################################################
