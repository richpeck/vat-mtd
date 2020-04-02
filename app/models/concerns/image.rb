##########################################################
##########################################################
##           _____                                      ##
##          |_   _|                                     ##
##            | | _ __ ___   __ _  __ _  ___            ##
##            | || '_ ` _ \ / _` |/ _` |/ _ \           ##
##           _| || | | | | | (_| | (_| |  __/           ##
##           \___/_| |_| |_|\__,_|\__, |\___|           ##
##                                 __/ |                ##
##                                |___/                 ##
##########################################################
##########################################################

# => ImageMagick
# => Put here to clean up code
class Image

  ############################
  ############################

  # => Keys
  # => Used as reference here and for app.rb reference
  # => Image.keys
  def self.keys
    %i(Color Dark Dark? Name Initials Memory Date HeartColor BirdsColor InitialsColor)
  end

  ############################
  ############################

  # => Initialize
  # => Creates the various images etc
  def initialize filename, color:"#3498DB", dark:"no", name:nil, initials:nil, memory:nil, date:nil, heartcolor:"#FFBFBF", birdscolor:"#ac8cc9", initialscolor:"#17022F"

    # => Vars
    # => Set to provide modular functionality
    # => This used to be Tempfile, but that kept adding weird stuff into the filename
    # => I later realized that this was due to the temporal nature of the file, and I needed to create a permanent file - I'd have to do it myself
    # => All files will be stored in the /tmp folder (we can use mkdir_p)
    @dir  = FileUtils.mkdir_p "tmp"
    FileUtils.touch "tmp/#{filename}.png"   # => required to ensure a file exists (if it exists, it will just be touched)
    @file = File.open "tmp/#{filename}.png" # => removes postfix on filename https://mensfeld.pl/2013/04/ruby-tempfile-extension-without-random-postfix/

    # => Properties
    # => These are defaults we can merge with the actual propreties
    @properties = {}
    Image.keys.each do |key|
      key = :Dark if key == :Dark?
      @properties[key] = eval(key.downcase.to_s)
    end

    # => Fix Colours
    # => Allows us to fix all the colours the system has
    %i(Color HeartColor BirdsColor InitialsColor).each { |i| @properties[i] = @properties[i].insert(0, "#") if @properties.has_key?(i) && @properties[i][0] != "#" }

    # => Formatting
    # => Any formatting which needs to be done can be done here
    if @properties[:Date].present?
      date = Date.strptime(@properties[:Date].to_s, '%Y-%m-%d') # => need to split this to store value in local var
      @properties[:Date] = date.strftime("#{date.day.ordinalize} %B %Y")
    end

  end

  #####################################
  #####################################

  # => Return path of temp file
  # => This allows us to show exactly what
  def path
    @file.path
  end

  #####################################
  #####################################

  # => Load
  # => Main method to build the image
  def load

    ###############################
    ###############################

    # => MiniMagick
    # => This allows us to "copy" the existing image into a new composit
    # => The new composit can be saved using Tempfile, so that we can either leave or delete it as required
    # => https://github.com/minimagick/minimagick#usage
    @mask  = MiniMagick::Image.open "lib/tree.png"  # => opens master file (tree.png)
    @trunk = MiniMagick::Image.open "lib/trunk.png" # => opens trunk file (trunk.png)

    ###############################
    ###############################

    # => Dimensions
    # => Because we need padding at the bottom
    @mask.dimensions.map!.with_index{ |e,i| i == 1 ? e += 425 : e }

    # => Initial
    # => This creates the base image and allows us to crop it with alpha channel
    MiniMagick::Tool::Convert.new do |i| # => https://github.com/minimagick/minimagick/issues/179#issuecomment-548819524
      i.size @mask.dimensions.join("x")
      i << "xc:#{@properties[:Color]}" # => "creating a rounded image" (https://www.rubyguides.com/2018/12/minimagick-gem/)
      i << @file.path
    end

    # => Save
    # => Saving the base colour allows us to mask it with an overlay
    MiniMagick::Image.new(@file.path, @file)

    ###############################
    ###############################

    # => Mask (leaves etc)
    # => https://github.com/sharshenov/minimagick-clip/blob/master/lib/mini_magick_clip.rb
    img :composite, new: @mask do |c|
      c.alpha "set"
      c.compose 'DstIn'
    end

    ###############################
    ###############################

    # => Trunk
    # => Adds trunk onto first image
    # => https://www.rubydoc.info/github/minimagick/minimagick/MiniMagick%2FImage:composite
    img :composite, new: @trunk do |c|
      c.compose "Over" # OverCompositeOp
      c.gravity "NorthWest"
      c.geometry "+0+0"
    end

    ###############################
    ###############################

    # => Dark
    # => Only trigger if "dark" is yes
    if @properties[:Dark] == "yes" || @properties[:Dark?] == "yes"

      # => Compose
      # => Allows us to blend images together (uses luminize to create effect -- )
      img :composite, new: MiniMagick::Image.open("lib/dark.png") do |c|
        c.compose "Over" # OverCompositeOp
        c.gravity "NorthWest"
        c.geometry "+0+0"
        c.compose "Luminize"
      end #compose

    end #dark

    ###############################
    ###############################

    # => Birds
    # => Shows birds on the image (present all the time)
    x = convert("lib/birds.png", @properties[:BirdsColor]) # => should delete automatically

    # => Compose
    # => Stacks layers
    img :composite, new: MiniMagick::Image.open(x.path) do |c|
      c.compose "Over" # OverCompositeOp
      c.gravity "NorthWest"
      c.geometry "+0+0"
    end #compose

    ###############################
    ###############################

    # => Initials
    # => Used to show the initials (heart) on the tree
    if @properties[:Initials]

      # => Initials
      # => Colour the initials block
      x = convert("lib/initials.png", @properties[:HeartColor])

      # => Compose
      # => Allows us to blend images together (uses luminize to create effect -- )
      img :composite, new: MiniMagick::Image.open(x.path) do |c|
        c.compose "Over" # OverCompositeOp
        c.gravity "NorthWest"
        c.geometry "+0+0"
      end #compose

      # => Text
      # => Allows us to blend images together (uses luminize to create effect -- )
      img :combine_options do |c|
        c.gravity 'North'
        c.pointsize 80
        c.font "lib/fonts/AgencyFB-Bold.ttf"
        c.draw "text 2,1485 '#{@properties[:Initials]}'"
        c.weight "800"
        c.fill(@properties[:InitialsColor])
      end

    end #initials

    ###############################
    ###############################

    # => Box
    # => If Name/Memory/Date present, show a black box with rounded corners
    if @properties[:Name].present? || @properties[:Memory].present? || @properties[:Date].present?

      # => Width
      # => Required to get the text done properly
      width = 1150
      x1 = (@mask.dimensions.first - width) / 2 # => (2363 - 550) / 2 => 1813/2 => 906.5 (margin on each side)
      x2 = @mask.dimensions.first - x1

      # => Height
      # => Allows us to determine the height of the box
      height = 100
      height += 100 if @properties[:Name].present?
      height += 100 if @properties[:Memory].present?
      height += 100 if @properties[:Date].present?

      # => Add height depending on dividers
      # => This works by taking the number of properties present and deducting 1 (3 items=2, 2 items=1, 1 item=0)
      options = @properties.slice(:Date, :Memory, :Name).compact
      height += (50 * options.count)

      # => Values
      # => Allows us to create the box with the text in mind
      y1 = @mask.dimensions.last - height # => (2622 - 550) => 2272 (first y)
      y2 = @mask.dimensions.last - 50 # => (height from bottom)

      # => Box
      # => Create bounding box and add it to the image
      img :combine_options do |c|
        c.fill("#000000")
        c.stroke("#deb71f")
        c.strokewidth("5")
        c.gravity "South"
        c.draw "roundrectangle #{x1},#{y1} #{x2},#{y2} 55,55"
      end

      # => Loop
      # => Loops through items and calculates heights based on number of items present
      items = {
        Name:   { height: 0,   pointsize: 65,  color: '#ffffff', font: "lib/fonts/BASKVILL.ttf"},
        Memory: { height: 135, pointsize: 105, color: '#deb71f', font: "lib/fonts/Charlotte.otf"},
        Date:   { height: 90,  pointsize: 65,  color: '#ffffff', font: "lib/fonts/BASKVILL.ttf"}
      }

      # => Only valid
      # => If they have nil contents, skip
      latest_height = 100 # used to capture last height (for divider)
      options.each_with_index do |(key,item), index|
        if (options.size - index) < options.size # 2,3
          img :composite, new: MiniMagick::Image.open("lib/divider.png") do |c|
            c.compose "Over" # OverCompositeOp
            c.gravity "South"
            c.geometry "#{width/2.2}x55 +0+#{latest_height}"
          end
          latest_height += 75 ## needed for divider
        end

        ## needed to determine height gap
        case key
          when :Memory
            temp_height = latest_height - 50
          when :Name
            temp_height = latest_height - 5
            temp_height -= 15 if options.has_key?(:Memory)
          else
            temp_height = latest_height
        end

        img :combine_options do |c|
          c.gravity   'South'
          c.pointsize items[key][:pointsize]
          c.font      items[key][:font]
          c.draw      "text 0,#{temp_height} '#{item}'"
          c.weight    "800"
          c.fill      items[key][:color]
        end
        latest_height += items[key][:height] # => used to give us the ability to match the height to the system
      end

    end

    ###############################
    ###############################

    # => Return
    # => Required to allow us to perform methods on this
    path

    ###############################
    ###############################

  end

  #####################################
  #####################################

  private

  # => Convert
  # => Used to colour various images
  def convert img, color

    # => Create Tempfile
    file = Tempfile.new img.split("/").last

    # => Convert passed image
    # => http://www.imagemagick.org/discourse-server/viewtopic.php?t=32081
    MiniMagick::Tool::Convert.new do |c|
      c << img
      c << '-fill' << color
      c << '+opaque' << 'none'
      c << file.path
    end

    # => Return
    return file

  end

  # => Composite
  # => This is reused over and over, so made sense to put it into a method
  def img action, new: nil, &block

    # => Vars
    original = MiniMagick::Image.open @file.path
    result   = action == :combine_options ? original.combine_options(&block) : original.send(action, new, &block)

    # => Write file
    # => Allows us to keep updating the original image
    result.write @file.path

  end

  #####################################
  #####################################

end
