require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Person do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Person.create!(@valid_attributes)
  end

  it 'has a username attribute' do
    lambda { Person.new(:username => 'ajsharp') }.should_not raise_error(ActiveRecord::UnknownAttributeError)
  end
end
