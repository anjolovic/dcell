# The DCell specs start a completely separate Ruby VM running this code
# for complete integration testing using 0MQ over TCP

require 'rubygems'
require 'bundler'
Bundler.setup

require 'dcell'
DCell.setup :id => 'test_node', :addr => 'tcp://127.0.0.1:21264'

class TestActor
  include Celluloid
  attr_reader :value

  def initialize
    @value = 42
  end

  def the_answer
    DCell::Global[:the_answer]
  end

  def crash
    raise "the spec purposely crashed me :("
  end
end

class TestGroup < Celluloid::Group
  supervise DCell::Group
  supervise TestActor, :as => :test_actor
end

TestGroup.run
