require 'test_helper'
require File.join(File.dirname(__FILE__), 'mocks.rb')

class Trainline50Test < ActiveSupport::TestCase
  test "sage_object method exists" do
    assert SimpleMock.responds_to?(:sage_object)
  end
  
  test "SimpleMock class has a sage attribute accessor" do
  	assert SimpleMock.responds_to?(:sage)
  end
    
  test "SimpleMock instance has to_sage_xml method" do
  	assert SimpleMock.new.responds_to?(:to_sage_xml)
  end
  
  test "SimpleMock instance has from_sage_xml method" do
  	assert SimpleMock.new.responds_to?(:from_sage_xml)
  end
end
