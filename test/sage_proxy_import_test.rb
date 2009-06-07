require 'test_helper'
require File.join(File.dirname(__FILE__), 'mocks.rb')

class SageProxyImportTest < ActiveSupport::TestCase

	test "SimpleMocks SageProxy class has a from_xml method" do
  	assert SimpleMock.sage.public_methods.include?('from_xml')
  end

	test "SimpleMock creates a sage import map" do
  	assert_nothing_raised do
  		SimpleMock.sage.import_map
  	end
  end
  
  test "building import map uses methods with setters" do
  	assert_equal ({ :name => :name }), ImportMock.sage.export_map
  	assert_equal ({ :name => :name= }), ImportMock.sage.import_map
  end
  
  test "building import map excludes methods without setters" do
  	assert_equal ({ :name => :name }), ImportMockWithoutSetter.sage.export_map
  	assert_equal ({ }), ImportMockWithoutSetter.sage.import_map
  end
  
  test "building import map excludes Proc objects" do
  	assert_equal [ :name, :alt_name ], ImportMockWithProc.sage.export_map.keys
  	assert_equal ({ :name => :name= }), ImportMockWithProc.sage.import_map
  end
  
  test "building import map excludes static values" do
  	assert_equal ({ :name => :name, :alt_name => 'foobar' }), ImportMockWithStatic.sage.export_map
  	assert_equal ({ :name => :name= }), ImportMockWithStatic.sage.import_map
  end
  
  test "importing from xml" do
  	m = ImportMock.new
  	rexml = REXML::Document.new("<SageTest><Name>import</Name></SageTest>")
  	m.from_sage_xml(rexml.elements['SageTest'])
  	assert_equal 'import', m.name
  end
  
  test "importing from xml only imports values in map" do
  	m = ImportMockExcludingAttrs.new
  	rexml = REXML::Document.new("<SageTest><Firstname>foo</Firstname><Lastname>bar</Lastname></SageTest>")
  	m.from_sage_xml(rexml.elements['SageTest'])
  	assert_equal 'foo', m.firstname
  	assert_nil m.lastname
  end
  
  protected
  
  	def get_builder
  		@builder ||= Builder::XmlMarkup.new(:indent => 2)
  	end  

end 