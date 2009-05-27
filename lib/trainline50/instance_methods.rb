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
		
		def write_sage_tag(tag, value, xml)
			if value.public_methods.include?('to_sage_xml')
				xml.tag!(tag) do
					value.to_sage_xml(xml)
				end
			elsif value.public_methods.include?('xmlschema')
				xml.tag! tag, value.xmlschema
			else
				xml.tag! tag, value
			end
		end
		
		def to_sage_xml(xml)
			self.class.sage_map.each do |sage, ar|
				write_sage_tag sage.to_s.camelize, process_sage_field(ar), xml
			end
			xml
		end
		
		def from_sage_xml
		end
		
	end

end
