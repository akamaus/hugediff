load 'ext_sort.rb'

class HugeDiff
  def initialize(stream1, stream2, piece_size = 100000)
    @sorted1 = ExtSort.new(stream1, piece_size)
    @sorted2 = ExtSort.new(stream2, piece_size)
  end

  # Runs diff on input streams, signals about the differencies by calling two Procs
  def diff(on_remove, on_create)
    @sorted1.sort_pieces
    @sorted2.sort_pieces

    left = @sorted1.next
    right = @sorted2.next

    while true
      res = compare(left, right)
      case res
      when nil
        break
      when -1
        on_remove.call(left)
        left = @sorted1.next
      when 1
        on_create.call(right)
        right = @sorted2.next
      when 0
        left = @sorted1.next
        right = @sorted2.next
      end
    end
  end

  # Compares two strings, nil is always bigger, so that we can deplete both sequences in one loop
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
end
