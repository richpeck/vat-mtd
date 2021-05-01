################################################################################
################################################################################
##    _____                       __        __       _______ ____             ##
##   / ___/____  _________  _____/ /_____  / /______/ ____(_) / /____  _____  ##
##   \__ \/ __ \/ ___/ __ \/ ___/ //_/ _ \/ __/ ___/ /_  / / / __/ _ \/ ___/  ##
##  ___/ / /_/ / /  / /_/ / /__/ ,< /  __/ /_(__  ) __/ / / / /_/  __/ /      ##
## /____/ .___/_/   \____/\___/_/|_|\___/\__/____/_/   /_/_/\__/\___/_/       ##
##     /_/                                                                    ##
################################################################################
################################################################################

# => Sprockets Filter
# => These are used to hook into the sprockets-helper gem (https://github.com/petebrowne/sprockets-helpers/blob/master/lib/sprockets/helpers.rb)
# => {{ 'app' | stylesheet_tag }}
module SprocketsFilter

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

################################################################################
################################################################################

## Liquid ##
## Register the filter ##
Liquid::Template.register_filter(SprocketsFilter)

################################################################################
################################################################################
