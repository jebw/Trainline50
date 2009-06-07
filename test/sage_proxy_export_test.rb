require 'test_helper'
require File.join(File.dirname(__FILE__), 'mocks.rb')

class SageProxyExportTest < ActiveSupport::TestCase

	test "SimpleMocks SageProxy class has a to_xml method" do
  	assert SimpleMock.sage.public_methods.include?('to_xml')
  end
  
  test "SimpleMock creates sage export map" do
  	assert_nothing_raised do
  		SimpleMock.sage.export_map
  	end
  end
  
  test "building sage_map with no user supplied map" do
  	assert_equal ({ :firstname => :firstname }), SimpleMock.sage.export_map
  end
  
  test "building sage_map using supplied alternatives" do
  	assert_equal ({ :firstname => :firstname, :surname => :lastname }), AlternativesMock.sage.export_map
  end
  
  test "building sage_map using user supplied map" do
  	assert_equal ({ :firstname => :lastname, :surname => :firstname }), UserMapMock.sage.export_map
  end
  
  test "AlternativesMock generates xml" do
  	m = AlternativesMock.new(:firstname => 'Joe', :lastname => 'Bloggs', :age => 30)
  	assert_equal "<Firstname>Joe</Firstname>\n<Surname>Bloggs</Surname>\n", m.to_sage_xml(get_builder).target!
  end
  
  test "static values in user supplied map" do
  	m = UserMapMockWithStatics.new(:firstname => 'Joe', :lastname => 'Bloggs')
  	assert_equal "<Firstname>Joe</Firstname>\n<Code>17</Code>\n<Type>Foo</Type>\n", m.to_sage_xml(get_builder).target!
  end
  
  test "proc objects in user supplied map" do
  	m = UserMapMockWithProc.new(:firstname => 'Joe', :lastname => 'Bloggs')
  	assert_equal "<Firstname>Joe</Firstname>\n<Proctest>Joe Bloggs</Proctest>\n", m.to_sage_xml(get_builder).target!
  end
  
  test "calling methods on child from user supplied map" do
  	expected_xml = "<Parent>parent</Parent>\n<Child>child</Child>\n<Grandchild>grandchild</Grandchild>\n"
  	assert_equal expected_xml, ParentMock.new.to_sage_xml(get_builder).target!
  end
  
  test "nesting of output xml" do
  	m = ParentMock2.new(:name => 'parent', :child => ChildMock.new(:name => 'child'))
  	expected_xml = "<Name>parent</Name>\n<Child>\n  <ChildName>child</ChildName>\n</Child>\n"
  	assert_equal expected_xml, m.to_sage_xml(get_builder).target!
  end
  
  test "xmlschema is called when generating xml" do
  	m = DateMock.new(:updated_at => Time.now)
  	assert_equal "<UpdatedAt>#{m.updated_at.xmlschema}</UpdatedAt>\n", m.to_sage_xml(get_builder).target! 
  end
  
  test "Nesting multiple child models" do
  	m = ParentMock3.new(:name => 'parent', :children => [ ChildMock.new(:name => 'child1'), ChildMock.new(:name => 'child2') ])
  	expected_xml = "<Name>parent</Name>\n<Children>\n  <Child>\n    <ChildName>child1</ChildName>\n  </Child>\n  <Child>\n    <ChildName>child2</ChildName>\n  </Child>\n</Children>\n"
		assert_equal expected_xml, m.to_sage_xml(get_builder).target!
  end
  
  protected
  
  	def get_builder
  		@builder ||= Builder::XmlMarkup.new(:indent => 2)
  	end

end