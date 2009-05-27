require 'test_helper'
require File.join(File.dirname(__FILE__), 'mocks.rb')

class Trainline50Test < ActiveSupport::TestCase
  test "sage_object method exists" do
    assert SimpleMock.public_methods.include?('sage_object')
  end
  
  test "SimpleMock instance has to_sage_xml method" do
  	assert SimpleMock.new.responds_to?(:to_sage_xml)
  end
  
  test "SimpleMock instance has from_sage_xml method" do
  	assert SimpleMock.new.responds_to?(:from_sage_xml)
  end
  
  test "SimpleMock class has a sync_with_sage method" do
  	assert SimpleMock.public_methods.include?('sync_with_sage')
  end
  
  test "SimpleMock creates sage_map" do
  	assert_nothing_raised do
  		SimpleMock.sage_map
  	end
  end
  
  test "building sage_map with no user supplied map" do
  	assert_equal ({ :firstname => :firstname }), SimpleMock.sage_map
  end
  
  test "building sage_map using supplied alternatives" do
  	assert_equal ({ :firstname => :firstname, :surname => :lastname }), AlternativesMock.sage_map
  end
  
  test "building sage_map using user supplied map" do
  	assert_equal ({ :firstname => :lastname, :surname => :firstname }), UserMapMock.sage_map
  end
  
  test "AlternativesMock generates xml" do
  	m = AlternativesMock.new(:firstname => 'Joe', :lastname => 'Bloggs', :age => 30)
  	assert_equal "<Firstname>Joe</Firstname>\n<Surname>Bloggs</Surname>\n", m.to_sage_xml(get_builder)
  end
  
  test "static values in user supplied map" do
  	m = UserMapMockWithStatics.new(:firstname => 'Joe', :lastname => 'Bloggs')
  	assert_equal "<Firstname>Joe</Firstname>\n<Code>17</Code>\n<Type>Foo</Type>\n", m.to_sage_xml(get_builder)
  end
  
  test "proc objects in user supplied map" do
  	m = UserMapMockWithProc.new(:firstname => 'Joe', :lastname => 'Bloggs')
  	assert_equal "<Firstname>Joe</Firstname>\n<Proctest>Joe Bloggs</Proctest>\n", m.to_sage_xml(get_builder)
  end
  
  test "calling methods on child from user supplied map" do
  	expected_xml = "<Parent>parent</Parent>\n<Child>child</Child>\n<Grandchild>grandchild</Grandchild>\n"
  	assert_equal expected_xml, ParentMock.new.to_sage_xml(get_builder)
  end
  
  protected
  
  	def get_builder
  		@builder ||= Builder::XmlMarkup.new(:indent => 2)
  	end
end
