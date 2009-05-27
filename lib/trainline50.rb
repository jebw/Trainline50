require 'trainline50/class_methods'
require 'trainline50/instance_methods'

module Trainline50
	
	def sage_object(object_type, fields, user_map, options)
		class << self
			attr_accessor :sage_map					
			include ClassMethods
		end
		
		self.sage_map = build_sage_map(fields, user_map)
		include InstanceMethods
	end
	
end

