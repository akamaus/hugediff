require 'tempfile'

# Objects of that class serve as a source of sorted streams to merge using a heap
class ExtStream
  def initialize(elements)
    storage = Tempfile.new('piece')
    elements.each { |l| storage.puts l }
    storage.rewind
    @stream = storage.lines
  end

  def key()
    begin
      @stream.peek
    rescue StopIteration
      nil
    end
  end

  def next()
    @stream.next
  end
end
