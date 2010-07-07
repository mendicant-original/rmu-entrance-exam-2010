require "lib/ali_rizvi_fixed"

start_time = Time.now

puts "Starting Memory:"
puts `ps -o rss= -p #{$$}`.to_i

doc  = TextEditor::Document.new
msg = "X"

[100, 1_000, 10_000, 100_000].each do |x|
  puts "Adding #{x} characters, 1 at a time"

  x.times do
    doc.add_text(msg)
  end

  puts "Current memory footprint:"
  puts `ps -o rss= -p #{$$}`.to_i
end


puts "Took #{Time.now - start_time}s to run"
