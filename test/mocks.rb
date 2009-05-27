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
	sage_object :sage_test, [ :firstname, :surname ], {}, { :primary => :firstname }
end

class AlternativesMock < MockModel
	sage_object :sage_test, [ :firstname, [ :surname, :secondname, :lastname ] ], {}, { :primary => :firstname }
end

class UserMapMock < MockModel
	sage_object :sage_test, [ :firstname, [ :surname, :lastname ] ],
								{ :firstname => :lastname, :surname => :firstname }, { :primary => :firstname }
end

class UserMapMockWithStatics < MockModel
	sage_object :sage_test, [ :firstname, :code, :type ],	{ :code => 17, :type => 'Foo' }, { :primary => :firstname }
end

class UserMapMockWithProc < MockModel
	sage_object :sage_test, [ :firstname, :proctest ],
								{ :proctest => Proc.new { |o| "#{o.firstname} #{o.lastname}" } }, { :primary => :firstname}
end

class ParentMock < MockModel
	attr_accessor :name, :child
	sage_object :sage_test, [ :parent, :child, :grandchild ],
									{ :parent => :name, :child => :child__name, :grandchild => :child__child__name }, { :primary => :name }
	
	def initialize(*args)
		super(*args)
		self.name = 'parent'
		self.child = ChildMock.new(:name => 'child', :child => ChildMock.new(:name => 'grandchild'))
	end
end

class ChildMock < MockModel
	attr_accessor :name, :child
	sage_object :sage_test, [ :child_name ], { :child_name => :name }, { :primary => :name }
end

class ParentMock2 < MockModel
	attr_accessor :name, :child
	sage_object :sage_test, [ :name, :child ], {}, { :primary => :name }
end

class DateMock < MockModel
	attr_accessor :updated_at
	sage_object :sage_test, [ :updated_at ], {}, {}
end
