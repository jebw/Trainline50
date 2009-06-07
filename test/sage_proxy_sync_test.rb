require 'test_helper'
require File.join(File.dirname(__FILE__), 'mocks.rb')

class SageProxySyncTest < ActiveSupport::TestCase

	test "SimpleMocks SageProxy class has a sync method" do
  	assert SimpleMock.sage.public_methods.include?('sync')
  end  

end 