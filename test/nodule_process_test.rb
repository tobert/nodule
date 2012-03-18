#!/usr/bin/env ruby
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'
require 'minitest/autorun'
require 'nodule/process'

class NoduleProcessTest < MiniTest::Unit::TestCase
  def test_process
    true_bin = File.exist?("/bin/true") ? "/bin/true" : "/usr/bin/true"
    p = Nodule::Process.new true_bin
    p.run
    p.wait 2
    assert p.done?, "true exits immediately, done? should be true"
  end
end
