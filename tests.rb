require 'test/unit'
require 'stringio'

load 'heap.rb'
load 'ext_sort.rb'
load 'huge_diff.rb'

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
    n = N.new(42)
    assert_equal(nil,h.extract)
    h.insert(n)
    assert_equal(n,h.extract)
    assert_equal(nil,h.extract)
  end

  def test_heap_property
    rnd = Random.new(1)
    10.times { heap_test(rnd) }
  end

  def heap_test(rnd)
    h = Heap.new
    size = rnd.rand(10000)
    vec = Array.new(size)
    vec.map! {|x| N.new rnd.rand 10000}
    sorted = vec.sort {|x,y| x.key <=> y.key}

    vec.each {|n| h.insert n}
    vec2 = []
    vec.size.times { vec2 << h.extract }
    assert(vec2.map {|v| v.key } == sorted.map {|v| v.key }, "failed on #{vec},\n returned #{vec2}")
  end
end

class ExtSortTests < Test::Unit::TestCase
  def test_ext_sort_empty
    arr = []
    sort_test(arr, 10)
  end

  def test_smaller_than_piece
    arr = %w(second first third)
    sort_test(arr, 10)
  end

  def test_equal_to_piece
    arr = %w(second first third)
    sort_test(arr, 3)
  end

  def test_repeats
    arr = %w(second first third second first)
    sort_test(arr, 1)
  end

  def test_randomized
    rnd = Random.new(1)
    100.times { random_test(rnd) }
  end

  def random_test(rnd)
    piece_size = 1 + rnd.rand(10)
    size = rnd.rand(100)

    arr = []
    size.times { arr << rnd.rand(10**50).to_s }

    sort_test(arr, piece_size)
  end

  def sort_test(data, piece_size)
    out = StringIO.new
    sorter = ExtSort.new(data.each,piece_size)
    sorter.sort_to(out)
    out.rewind
    res = out.readlines
    assert(data.sort == res.map {|s| s.strip}, "failed with piece_size #{piece_size} applied to array of size #{data.length}\ndata:\n#{data.join "\n"} \nresult:\n#{res}")
  end
end

class HugeDiffTests < Test::Unit::TestCase
  def test_all_empty
    run_test([],[])
  end
  def test_left_empty
    run_test([], %w(first third second forth fifth))
  end
  def test_right_empty
    run_test(%w(first third second forth fifth), [])
  end
  def test_regular
    run_test(%w(first third fifth), %w(second forth))
  end

  def run_test(arr1,arr2)
    left_diffs = []
    right_diffs = []
    hd = HugeDiff.new(arr1.each, arr2.each, 3)
    hd.diff(Proc.new {|x| left_diffs << x}, Proc.new {|x| right_diffs << x})
    assert_equal(left_diffs.map{|x| x.strip}.sort, (arr1 - arr2).sort)
    assert_equal(right_diffs.map{|x| x.strip}.sort, (arr2 - arr1).sort)
  end
end

