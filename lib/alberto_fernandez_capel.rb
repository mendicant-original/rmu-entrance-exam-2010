class AddTextCommand
  def initialize(text, position)
    @text = text
    @position = position
  end

  def execute(contents)
    contents.insert(@position, @text)
  end

  def undo(contents)
    if @position < 0
      first = contents.length - @text.length
    else
      first = @position
    end

    last = first + @text.length
    contents.slice!(first...last)
  end
end

class RemoveTextCommand
  def initialize(first, last)
    @first = first
    @last = last
  end

  def execute(contents)
    @text = contents.slice!(@first...@last)
  end

  def undo(contents)
    contents.insert(@first, @text)
  end
end

module TextEditor
  class Document
    def initialize
      @contents = ""
      @commands = []
      @reverted = []
    end
    
    attr_reader :contents

    def add_text(text, position=-1)
      execute AddTextCommand.new(text, position)
    end

    def remove_text(first=0, last=contents.length)
      execute RemoveTextCommand.new(first, last)
    end

    def execute(command)
      return if command.nil?

      command.execute(contents)
      @commands << command
      @reverted = []
    end

    def undo
      return if @commands.empty?

      command = @commands.pop
      command.undo(contents)
      @reverted << command
    end

    def redo
      return if @reverted.empty?

      command = @reverted.pop
      command.execute(contents)
      @commands << command
    end

  end
end 
