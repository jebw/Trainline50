module Trainline50
	
	module InstanceMethods
	
		def process_sage_field(value)
			if value.is_a?(Symbol)
				obj = self
				value.to_s.split('__').each do |method| 
					obj = obj.__send__(method)
				end
				obj
			elsif value.is_a?(Proc)
				value.call(self)
			else
				value
			end
		end
		
		def to_sage_xml(xml)
			self.class.sage_map.each do |sage, ar|
				xml.tag! sage.to_s.camelize, process_sage_field(ar)
			end
			xml
		end
		
		def from_sage_xml
		end
		
	end

end
