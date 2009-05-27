module Trainline50
	
	module ClassMethods
		
		def build_sage_map(fields, user_map)
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
	
		def sync_with_sage
		end
		
	end

end