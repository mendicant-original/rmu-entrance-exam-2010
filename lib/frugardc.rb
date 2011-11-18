module TextEditor
  class Document
    def initialize
      @contents = ""
      @actions = []
      @index = 0
      @redoable = false
    end
    
    attr_reader :contents

    def add_text(text, position=-1)
      if position == -1
        position = @contents.size
      else
        position = [position,@contents.size].min
      end
      @index += 1
      @actions[@index] = [:add,position,text]
      @contents.insert(position, text)
      @redoable = false
    end

    def remove_text(first=0, last=contents.length)
      text = @contents.slice!(first...last)
      @index += 1
      @actions[@index] = [:remove,first,text]
      @redoable = false      
    end

    def undo
      return if @index == 0
      todo = @actions[@index]
      if todo[0] == :remove
        @contents.insert(todo[1],todo[2])
      else # Must == :add
        @contents.slice!(todo[1],todo[2].length)
      end
      @index -= 1
      @redoable = true      
    end

    def redo
      return if not @actions[@index + 1] && @redoable
      todo = @actions[@index + 1]
      if todo[0] == :remove
        @contents.slice!(todo[1],todo[2].length)       
      else # Must == :add
        @contents.insert(todo[1],todo[2])
      end
      @index += 1
    end
  end
end
