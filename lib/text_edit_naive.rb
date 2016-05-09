module TextEditor
  class Document
    def initialize
      @contents = ""
      @actions = []
      @reverted  = []
      @index = 0
    end
    
    attr_reader :contents

    def add_text(text, position=-1)
      actions << [:add,text,position]
      index += 1
      contents.insert(position, text)
    end

    def remove_text(first=0, last=contents.length)
      text = contents.slice(first...last)
      actions << [:remove,first,text]
      index += 1
      contents.slice!(first...last)
    end

    def snapshot(tainted=false)
      @reverted = [] if tainted
      @snapshots << @contents.dup
    end

    def undo
      return if @snapshots.empty?

      @reverted << @contents
      @contents = @snapshots.pop
    end

    def redo
      return if @reverted.empty?

      snapshot
      @contents = @reverted.pop
    end

  end
end
