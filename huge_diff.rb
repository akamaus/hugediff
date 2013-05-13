load 'ext_sort.rb'

# Class which makes the actual diff, first sorts given streams and then analyzes the results comparing them element-wise
class HugeDiff
  def initialize(stream1, stream2, piece_size = 100000)
    @sorted1 = ExtSort.new(stream1, piece_size)
    @sorted2 = ExtSort.new(stream2, piece_size)
  end

  # Runs diff on input streams, signals about the differencies by calling two Procs
  def diff(on_remove, on_create)
    @sorted1.sort_pieces
    @sorted2.sort_pieces

    res = 0 # On the first iteration we should initialize both streams

    while true
      case res
      when 0
        left = @sorted1.next
        right = @sorted2.next
      when nil
        break
      when -1
        on_remove.call(left)
        left = @sorted1.next
      when 1
        on_create.call(right)
        right = @sorted2.next
      end
      res = compare(left, right)
    end
  end

  # Compares two strings, nil(flags the end of sequence) is always bigger, so that we can deplete both sequences in one loop
  def compare(x,y)
    case
    when x.nil? && y.nil?
      nil
    when x.nil?
      1
    when y.nil?
      -1
    else
      x <=> y
    end
  end

  private :compare
end
