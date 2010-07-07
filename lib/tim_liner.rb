module TextEditor
  class Document
    def initialize
      @contents = ""
      @snapshots = []
      @reverted = []
    end
    
    attr_reader :contents

    def add_text(text, position=-1)
      snapshot(["add", text.length, position], true)
      contents.insert(position, text)
    end

    def remove_text(first=0, last=contents.length)
      text = contents.slice!(first...last)
      snapshot(["remove", text, first], true)
      contents
    end

    def snapshot(change=[], tainted=false)
      @reverted = [] if tainted
      @snapshots << change
    end

    def undo
      return if @snapshots.empty?
      change = @snapshots.pop
      make_change(change, @reverted)
    end

    def redo
      return if @reverted.empty?
      change = @reverted.pop
      make_change(change, @snapshots)
    end
    
    def make_change(change, array)
      if change[0] == "add"
        length = change[1]
        position = change[2]
        unless position < 0
          first = position
          last = position + length
        else
          last = contents.length + position + 1
          first = last - length
        end
        text = contents.slice!(first...last)
        array << ["remove", text, first]
        contents
      else
        text = change[1]
        pos = change[2]
        array << ["add", text.length, pos]
        contents.insert(pos, text)
      end
    end

  end
end
