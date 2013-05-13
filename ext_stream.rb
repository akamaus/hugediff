require 'tempfile'

# Objects of that class serve as a source of sorted streams to merge using a heap.
# Semantics is somewhat unsound, stream elements are returned as strings with newline at the end.
# It's ok for current application, though.
class ExtStream
  def initialize(elements)
    @storage = Tempfile.new('piece')
    elements.each { |l| @storage.puts l }
    @storage.rewind
    @stream = @storage.lines
  end

  # Returns current element, nil if stream is depleted
  # designed to serve as a key then stream is placed into a heap
  def key()
    begin
      @stream.peek
    rescue StopIteration
      nil
    end
  end
  # Moves to next element, returns the current one
  def next()
    @stream.next
  end
end
