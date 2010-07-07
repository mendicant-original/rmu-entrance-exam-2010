module TextEditor
  class Document
    def initialize
      @contents = ""
      @commands = []
      @reverted = []
    end
    
    def contents
      @contents = ""
      @commands.each {|command| command.call}
      @contents
    end

    def add_text(text, position=-1)
      execute { @contents.insert(position, text) }
    end

    def remove_text(first=0, last=contents.length)
      execute { @contents.slice!(first...last) }
    end

    def execute(&block)
      @commands << block
      @reverted = []
    end

    def undo
      return if @commands.empty?
      @reverted << @commands.pop
    end

    def redo
      return if @reverted.empty?

      @commands << @reverted.pop
    end

  end
end
