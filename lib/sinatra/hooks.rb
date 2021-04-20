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

          # => Info
          # => Register Hook allows us to define which funtions should fire for a specific hook
          # => For example, if you want to manage the "pre_render" action --> you would use register_hook :pre_render ...
          # => -
          # => There are two types of hook - action + filter
          # => These work together to provide us with the ability to output the correct code to the frontend

          # => Var
          # => Takes the $hooks global var and populates it with the passed function
          settings.hooks[action.to_s] ||= []
          settings.hooks[action.to_s] << Sinatra::Hooks::Hook.new(action, name, method, priority)

          # => These populate the "hooks" global Sinatra setting
          # => By providing a list of instantiated hooks, it allows us to call these at an appropriate time, giving rise to the way in which the hooks work

        end #register_hook
        alias :register_action :register_hook
        alias :register_filter :register_hook

      ########################
      ########################

        # => Perform Hook
        # => This fires an action (and subsequent hooks) present in our code
        def perform_hook action, html

          # => Filter/Action
          # => This is designed to figure out whether it's a filter or action being declared
          method_name = __callee__

          # => Fire Hook
          # => These fire for whichever the user has defined
          case action.to_sym
            when :pre_render
              output = liquid html, layout: :application, locals: { app: AppDrop.new, user: (UserDrop.new(current_user) if current_user), flash: (FlashDrop.new(flash) if flash.keys.any?) }
          end

          # => Fire other hooks
          # => This allows us to iterate over the various hooks that exist
          if settings.hooks[action.to_s]
            settings.hooks[action.to_s].sort_by(&:priority).each do |hook|
              (method_name.to_s.include?('filter')) ? output = hook.function.call(output) : hook.function.call(output)
            end
          end

          # => Return
          # => This returns outputted data to the main script
          return output

        end #perform_hook
        alias :perform_action :perform_hook
        alias :perform_filter :perform_hook

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
