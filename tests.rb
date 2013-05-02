load 'heap.rb'
require 'test/unit'

class N
  def initialize(k)
    @v = k
  end
  def key
    @v
  end
end

class HeapTests < Test::Unit::TestCase
  def test_empty_extract
    h = Heap.new
    n = N.new 42
    assert_equal(nil,h.extract)
    h.insert n
    assert_equal(n,h.extract)
    assert_equal(nil,h.extract)
  end

  def test_heap_property
    rnd = Random.new
    10.times { heap_test(rnd) }
  end

  def heap_test(rnd)
    h = Heap.new
    size = rnd.rand 10000
    vec = Array.new size
    vec.map! {|x| N.new rnd.rand 10000}
    sorted = vec.sort {|x,y| x.key <=> y.key}

    vec.each {|n| h.insert n}
    vec2 = []
    vec.size.times { vec2 << h.extract }
    assert(vec2.map {|v| v.key } == sorted.map {|v| v.key }, "failed on #{vec},\n returned #{vec2}")
  end
end
