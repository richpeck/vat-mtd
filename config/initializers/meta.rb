###########################################################
###########################################################
##                   __  ___     __                      ##
##                  /  |/  /__  / /_____ _               ##
##                 / /|_/ / _ \/ __/ __ `/               ##
##                / /  / /  __/ /_/ /_/ /                ##
##               /_/  /_/\___/\__/\__,_/                 ##
##                                                       ##
###########################################################
###########################################################
##    Create superclassed "Meta" models (Meta::Option)   ##
###########################################################
###########################################################

# => Table
# => Check if table exists & that we have "meta" variables
if ActiveRecord::Base.connection.data_source_exists?(:nodes)
  metas = Node.where(ref: "meta")
  if metas.any?
    metas.pluck(:val).each do |klass| #-> "class" is reserved
      Object.const_set klass.titleize, Class.new(Node) # => Object or some other constant
    end
  end
end

###########################################################
###########################################################
