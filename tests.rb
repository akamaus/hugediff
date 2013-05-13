require 'test/unit'
require 'stringio'

load 'heap.rb'
load 'ext_sort.rb'
load 'huge_diff.rb'

# A helper wrapper for testing heap
class N
  def initialize(k)
    @v = k
  end
  def key
    @v
  end
end

# Generates a random array with given properties, transforms it's elements using block passed
def random_sequence(rnd, max_len, max_elem)
  size = rnd.rand(max_len)
  vec = Array.new(size)
  vec.map! { yield(rnd.rand(max_elem)) }
  vec
end

# Splits an array into two pieces at random
def random_split(rnd, seq)
  p = rnd.rand(seq.length)
  return seq[0...p],seq[p..-1]
end

# Tests for heap
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

    vec = random_sequence(rnd, 10000, 10000) { |x| N.new(x) }
    sorted = vec.sort {|x,y| x.key <=> y.key}

    vec.each {|n| h.insert n}
    vec2 = []
    vec.size.times { vec2 << h.extract }
    assert(vec2.map {|v| v.key } == sorted.map {|v| v.key }, "failed on #{vec},\n returned #{vec2}")
  end
end

# Tests for external sort
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
    arr = random_sequence(rnd, 1000, 10**50) { |x| x.to_s }
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

# Tests for diff algo
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
  def test_randomized
    rnd = Random.new(1)
    100.times { random_test(rnd) }
  end

  def random_test(rnd)
    seq = random_sequence(rnd, 10000, 10**50) {|x| x.to_s}
    seq1,seq_rest = random_split(rnd, seq)
    seq2,seq3 = random_split(rnd, seq_rest)

    seq_left = seq1 + seq2
    seq_right = seq1 + seq3

    run_test(seq_left.shuffle, seq_right.shuffle, 1000)
  end

  def run_test(arr1,arr2, piece_size = 3)
    left_diffs = []
    right_diffs = []
    hd = HugeDiff.new(arr1.each, arr2.each, piece_size)
    hd.diff(Proc.new {|x| left_diffs << x}, Proc.new {|x| right_diffs << x})
    assert_equal(left_diffs.map{|x| x.strip}.sort, (arr1 - arr2).sort)
    assert_equal(right_diffs.map{|x| x.strip}.sort, (arr2 - arr1).sort)
  end
end

