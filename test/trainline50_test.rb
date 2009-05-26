require 'test_helper'

class MockModel
	attr_accessor :firstname, :lastname, :age, :dob
	extend Trainline50
	sage_object :sage_test, { :firstname => [], :surname => [ :lastname ] }, {}, {}
	
	def responds_to?(method)
		public_methods.include?(method.to_s)
	end
end

class Trainline50Test < ActiveSupport::TestCase
  test "sage_object method exists" do
    assert MockModel.public_methods.include?('sage_object')
  end
  
  test "MockModel instance has to_sage_xml method" do
  	assert MockModel.new.responds_to?(:to_sage_xml)
  end
  
  test "MockModel instance has from_sage_xml method" do
  	assert MockModel.new.responds_to?(:from_sage_xml)
  end
  
  test "MockModel class has a sync_with_sage method" do
  	assert MockModel.public_methods.include?('sync_with_sage')
  end
end
