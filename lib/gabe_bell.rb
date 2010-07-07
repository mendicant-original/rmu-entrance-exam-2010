class String
  def diff(str_b)
    str_a_arr = self.chars.to_a
    str_b_arr = str_b.chars.to_a
    diffs = {}
    str_array_to_use = str_b_arr.size > str_a_arr.size ? str_b_arr : str_a_arr
    str_array_to_use.each_index do |index|
        diffs[index] = str_a_arr[index] if not str_a_arr[index] == str_b_arr[index]
    end
    diffs
  end
end

module TextEditor
  class Document
    def initialize
      @contents = ""
      @undo_history = []
      @redo_history = []
    end
    
    attr_reader :contents

    def add_text(text, position=-1)
      snapshot :command => :insert, :args => [position, text]
    end
    
    def remove_text(first=0, last=contents.length)
      snapshot :command => :slice!, :args => [first, last]
    end
    
    def undo
      return if @undo_history.empty?
      current_undo = @undo_history.pop
      snapshot :type => :redo, :command => :replay, :args => [current_undo]
    end
    
    def redo
      return if @redo_history.empty?
      current_redo = @redo_history.pop
      snapshot :type => :undo, :command => :replay, :args => [current_redo]
    end
    
    def to_s
      @contents
    end
    
    def inspect
      @contents
    end
    
    private
    
    def snapshot(*args)
      old_contents = String.new(@contents)
      args = args[0]
      args[:args] ||= []
      self.__send__ args[:command], *args[:args] if args[:command]
      history = args[:type] == :redo ? @redo_history : @undo_history
      history << old_contents.diff(@contents)
    end
    
    def replay(step, reverse=false)
      content_array = @contents.chars.to_a
      step.each_key do |key|
        content_array[key] = step[key]
      end
      @contents = content_array.join
    end

    def snapshot_for_undo(old_contents)
      @undo_history << old_contents.diff(@contents)
    end
    
    def snapshot_for_redo(old_contents)
      @redo_history << old_contents.diff(@contents)
    end
    
    def insert(*args)
      @contents.insert(*args)
    end
    
    def slice!(*args)
      @contents.slice!(*args)
    end
  end
end
