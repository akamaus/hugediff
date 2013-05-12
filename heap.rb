# -*- coding: utf-8 -*-

class Heap
  def initialize()
    @contents = []
  end

  # вставка элемента
  def insert(elt)
    unless elt.key.nil?
      @contents << elt
      bubble_up(@contents.size - 1)
    end
  end

  # извлечение элемента с минимальным ключом
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
  # количество элементов в куче
  def size()
    @contents.size
  end

  ## служебные методы

  # вытаскиваем элемент из глубины до полагающегося места
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
  # топим элемент, пока не выполнится свойство кучи
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
end
