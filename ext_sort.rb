load 'ext_stream.rb'
load 'heap.rb'

class ExtSort
  def initialize(source,piece_size)
    @source = source
    @piece_size = piece_size
  end

  # Splits the source into several pieces, sorts them separately and stores to disk
  def sort_pieces
    @streams = []

    cont = true
    while cont do
      piece = []
      begin
        @piece_size.times { piece << @source.next }
      rescue StopIteration
        cont = false
      end
      piece.sort!
      @streams << ExtStream.new(piece)
      end
  end

  # Merges several sorted pieces of input stream into one
  def merge_pieces(dest)
    headings = Heap.new
    @streams.each { |s| headings.insert s }

    while headings.size > 0 do
      stream = headings.extract
      dest.puts stream.next
      headings.insert stream
    end
  end

  # Sorts contents of the given source (supplied when was constucted) into the given destination
  def sort_to(dest)
    sort_pieces
    merge_pieces dest
  end
end
