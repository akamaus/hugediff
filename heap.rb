# -*- coding: utf-8 -*-

# Minimum-heap data structure.
# Implemented as described at https://class.coursera.org/algo-2012-002/lecture/63
class Heap
  def initialize()
    @contents = []
  end

  # Inserts the element, zero keys are silently ignored
  def insert(elt)
    unless elt.key.nil?
      @contents << elt
      bubble_up(@contents.size - 1)
    end
  end

  # Extracts root of the heap, it's the element with the minimal key
  # returns nil if heap is empty
  def extract()
    if size == 0 then nil
    else
      root = @contents[0]
      @contents[0] = @contents[-1]
      @contents.delete_at(-1)
      bubble_down(0)
      root
    end
  end

  # Number of elements in a heap
  def size()
    @contents.size
  end

  ## Service methods
  # Promotes the element at the given index up until it fits it's place(immediate parent has a smaller key)
  def bubble_up(i)
    while i > 0
      parent = (i+1) / 2 - 1
      if @contents[parent].key >= @contents[i].key then
        @contents[parent],@contents[i] = @contents[i],@contents[parent]
        i = parent
      else return
      end
    end
  end
  # Sinks the element until there are no childs with lesser keys
  def bubble_down(i)
    while true
      child1 = (i+1) * 2 - 1
      child2 = (i+1) * 2
      if child1 >= size then return
      elsif child2 >= size then
        if @contents[i].key >= @contents[child1].key then
          @contents[i],@contents[child1] = @contents[child1],@contents[i]
          return
        else return
        end
      else min = if @contents[child1].key <= @contents[child2].key
                 then child1 else child2
                 end
        if @contents[i].key > @contents[min].key
          @contents[i],@contents[min] = @contents[min],@contents[i]
          i = min
        else return
        end
      end
    end
  end

  private :bubble_up, :bubble_down
end
