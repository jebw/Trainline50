module Trainline50
	
	class SageProxy
		attr_reader :parent, :object_type, :export_map, :import_map, :proxy_options
		
		def initialize(proxy_for, object_type, fields, user_map, options = {})
			@parent = proxy_for
			@object_type = object_type
			@export_map = build_export_map(fields, user_map)
			@import_map = build_import_map(self.export_map)
			@proxy_options = options
		end
		
		def build_export_map(fields, user_map)
			instance = self.parent.new
			map = ActiveSupport::OrderedHash.new
			fields.each do |alternatives|
				alternatives = [ alternatives ] unless alternatives.kind_of?(Array)
				field = alternatives.shift
				
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
		
		def build_import_map(emap)
			instance = self.parent.new
			map = ActiveSupport::OrderedHash.new
			emap.each do |key, value|
				if value.is_a?(Symbol)
					value = "#{value.to_s}=".to_sym
					map[key] = value 	if instance.responds_to?(value)
				end
			end
			map
		end
		
		def to_xml(xml, instance)
			self.export_map.each do |sage, ar|
				write_sage_tag sage.to_s.camelize, process_sage_field(instance, ar), xml
			end
			xml
		end
		
		def from_xml
		
		end
		
		def sync
		
		end
		
		private
			
			def process_sage_field(instance, value)
				if value.is_a?(Symbol)
					obj = instance
					value.to_s.split('__').each do |method| 
						obj = obj.__send__(method)
					end
					obj
				elsif value.is_a?(Proc)
					value.call(instance)
				else
					value
				end
			end
			
			def write_sage_tag(tag, value, xml)
				if value.public_methods.include?('to_sage_xml')
					xml.tag!(tag) do
						value.to_sage_xml(xml)
					end
				elsif value.is_a?(Array)
					xml.tag!(tag) do
						value.each do |v|
							xml.tag!(tag.singularize) do
								v.to_sage_xml(xml)
							end
						end
					end
				elsif value.public_methods.include?('xmlschema')
					xml.tag! tag, value.xmlschema
				else
					xml.tag! tag, value
				end
			end
		
	end
	
end