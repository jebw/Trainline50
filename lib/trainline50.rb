module Trainline50
	
	def sage_object(object_type, fields, user_map, options)
		
		class << self
			attr_accessor :sage_map
					
			define_method "build_sage_map" do |fields, user_map|
				instance = self.new
				map = {}
				fields.each do |field, alternatives|
					map[field] = if user_map.has_key?(field)
						user_map[field]
					elsif instance.responds_to?(field)
						field
					else
						alternatives.find { |alt| instance.responds_to?(alt)}				
					end
				end
				map.delete_if {|k,v| v.nil? }
				map
			end
		
			define_method "sync_with_sage" do
			end
		end
		
		self.sage_map = build_sage_map(fields, user_map)
	
		define_method "to_sage_xml" do |xml|
			self.class.sage_map.each do |sage, ar|
				xml.tag! sage.to_s.camelize, __send__(ar)
			end
			xml
		end
		
		define_method "from_sage_xml" do
		end
		
	end
	
end

