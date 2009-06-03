require 'trainline50/sage_proxy'

module Trainline50
	
	def sage_object(object_type, fields, user_map, options)
		mattr_accessor :sage
		self.sage = Trainline50::SageProxy.new(self, object_type, fields, user_map, options)
		
		define_method "to_sage_xml" do |xml|
			self.class.sage.to_xml(xml, self)
		end
		
		define_method "from_sage_xml" do
		end
	end
	
end

