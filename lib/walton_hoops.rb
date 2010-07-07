# Written by Walton Hoops
# This is my own original work, only the Ruby standard library documentation
# was consulted.
# For observations and further explanation see notes file
module TextEditor
  class Document
    def initialize
      @contents = ""
      #contains arrays of length 2
      #arr[0] is a symbol indicating the function to call
      #arr[1] is the arguments to the function
      @revisions = []
      @version=0
    end

    attr_reader :contents

    # Add text
    # If head is omitted or true redos are not possible after calling this
    # function
    def add_text(text, position=-1, head=true)
      position=position < 0? positive_index(position)+1: position
      @revisions[@version]=[:remove_text,[position,position+text.length,false]]
      make_head if head;
      contents.insert(position, text)
    end

    # Remove text
    # If head is omitted or true redos are not possible after calling this
    # function
    def remove_text(first=0, last=@contents.length, head=true)
      start=positive_index(first)
      str=contents.slice!(first...last)
      @revisions[@version]=[:add_text, [str, start, false]]
      make_head if head
      str
    end

    # Move back one revision
    def undo
      return if @version==0
      @version-=1
      apply_revision
    end

    # Move forward a revision
    def redo
      return if @version==@revisions.length
      apply_revision
      @version+=1
    end

    private
    # Adjust a negative index to the equivalent positive index
    # Used because managing equivalent negative indexes for
    # String#insert vs String#splice is a pain
    def positive_index(index)
      index >= 0 ? index : contents.length+index
    end
    
    # Apply the current revision to the document
    def apply_revision
      revision=@revisions[@version]
      send revision[0], *revision[1]
    end

    # Make the current vision the head of the revision list preventing redos
    def make_head
      @version+=1
      @revisions.slice!(@version...@revisions.length)
    end
  end
end
