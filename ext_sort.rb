load 'ext_stream.rb'
load 'heap.rb'

class ExtSort
  def initialize(source,piece_size)
    @source = source
    @piece_size = piece_size
  end

  # Splits the source into several pieces, sorts them separately and stores to disk
  def sort_pieces
    @headings = Heap.new
    cont = true
    while cont do
      piece = []
      begin
        @piece_size.times { piece << @source.next }
      rescue StopIteration
        cont = false
      end
      piece.sort!
      @headings.insert(ExtStream.new(piece))
      end
  end

  # Merges several sorted pieces of input stream into one returning next element of it
  def next
    stream = @headings.extract
    if stream
      res = stream.next
      @headings.insert stream
      res
    else
      nil
    end
  end

  # Sorts contents of the given source (supplied when was constucted) putting it into the given destination stream
  def sort_to(dest)
    sort_pieces
    cont = true
    while cont
      elt = self.next
      if elt
        dest.puts elt
      else
        cont = false
      end
    end
  end
end
