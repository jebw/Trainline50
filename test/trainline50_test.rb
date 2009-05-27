require 'test_helper'

class MockModel
	attr_accessor :firstname, :lastname, :age, :dob
	extend Trainline50
	
	def initialize(values = {})
		values.each do |key, value|
			__send__("#{key.to_s}=", value)
		end
	end
	
	def responds_to?(method)
		public_methods.include?(method.to_s)
	end
end

class SimpleMock < MockModel
	sage_object :sage_test, { :firstname => [], :surname => [] }, {}, { :primary => :firstname }
end

class AlternativesMock < MockModel
	sage_object :sage_test, { :firstname => [], :surname => [ :secondname, :lastname ] }, {}, { :primary => :firstname }
end

class UserMapMock < MockModel
	sage_object :sage_test, { :firstname => [], :surname => [ :lastname ] }, 
								{ :firstname => :lastname, :surname => :firstname }, { :primary => :firstname }
end

class UserMapMockWithStatics < MockModel
	sage_object :sage_test, { :firstname => [], :code => [], :type => [] }, 
								{ :code => 17, :type => 'Foo' }, { :primary => :firstname }
end

class UserMapMockWithProc < MockModel
	sage_object :sage_test, { :firstname => [], :proctest => []}, 
								{ :proctest => Proc.new { |o| "#{o.firstname} #{o.lastname}" } }, { :primary => :firstname}
end

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
  
  protected
  
  	def get_builder
  		@builder ||= Builder::XmlMarkup.new(:indent => 2)
  	end
end
