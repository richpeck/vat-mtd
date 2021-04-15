##########################################################################################
##########################################################################################
##                             __  __            __                                     ##
##                            / / / /___  ____  / /_______                              ##
##                           / /_/ / __ \/ __ \/ //_/ ___/                              ##
##                          / __  / /_/ / /_/ / ,< (__  )                               ##
##                         /_/ /_/\____/\____/_/|_/____/                                ##
##                                                                                      ##
##########################################################################################
##########################################################################################
## This is designed to provide "Hook" methods for the various controller actions
## "hook" methods are meant to provide us with a core structure through which we can integrate different functionality
##########################################################################################
##########################################################################################

## Sinatra ##
## Required to run our system ##
module Sinatra

  # => Hooks
  # => Used to provide hooking functionality for the system (IE use in the front and backend)
  module Hooks

    #########################
    #########################

      # => Register
      # => Allows us to perform app-level funtcionality
      def self.registered(app)

        # => Helpers
        # => Allow us to call the various helper methods inside the app
        # => http://sinatrarb.com/extensions.html#setting-options-and-other-extension-setup
        app.helpers Hooks::Helpers

        # => Vars
        # => Required by the helper methods
        app.set :hooks, {}

      end

    #########################
    #########################

    # => Helpers
    # => Required because the "set" method was only feasible in the register block
    module Helpers

      ########################
      ########################

        # => Register Hook
        # => Registers a new hook element, allowing us to add different functions to the global $hooks var
        def register_hook action, name, method, priority

          # => Var
          # => Takes the $hooks global var and populates it with the passed function
          settings.hooks[action.to_s] ||= []
          settings.hooks[action.to_s] << Sinatra::Hooks::Hook.new(action, name, method, priority)

        end #register_hook

      ########################
      ########################

        # => Perform Hook
        # => This fires an action (and subsequent hooks) present in our code
        def perform_hook action, html

          # => Vars
          # => Loads the various vars required to make it work
          @liquid = { 'app' => AppDrop.new }

          # => Actions
          # => These fire for whichever the user has defined
          case action.to_sym
          when :pre_render
            output = Liquid::Template.parse(html).render(@liquid)
          end

          # => Fire other hooks
          # => This allows us to iterate over the various hooks that exist
          settings.hooks[action.to_s].each { |hook| output = hook.function.call(output) } if settings.hooks[action.to_s]

          # => Return
          # => This returns outputted data to the main script
          return output

        end #perform_hook

      ########################
      ########################

    end #helpers
  end #hooks

  # => Register
  # => Allows us to integrate into the Sinatra app
  register Hooks

end #sinatra

##########################################################################################
##########################################################################################
