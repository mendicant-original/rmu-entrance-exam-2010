module TextEditor
  class Document
    def initialize
      @contents = ''
      @op_stack = []
      @undo_stack = []
    end
    
    attr_reader :contents

    def add_text(text, position=-1)
      first = (position == -1 ? @contents.length : position)
      
      @op_stack.push [ [:insert, position, text], [:slice!, first, first+text.length] ]
      @undo_stack = []
      
      @contents.insert(position, text)
    end

    def remove_text(first=0, last=@contents.length)
      text = @contents.slice!(first...last)
      
      @op_stack.push [ [:slice!, first, last-1], [:insert, first, text] ]
      @undo_stack = []
    end

    def undo
      return if @op_stack.empty?
      
      @undo_stack << @op_stack.pop
      content
    end

    def redo
      return if @undo_stack.empty?
      
      @op_stack << @undo_stack.pop
      content
    end
    
    def content
      @contents = ''
      @op_stack.each do |op|
        @contents.send( op[0][0], op[0][1], op[0][2] )
      end
      
      @contents
    end
  end
end
