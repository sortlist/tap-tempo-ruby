#!/usr/bin/ruby -w
require 'io/console'

tempo = []
bpm = ->(tempo) { (60 * (tempo.size - 1)) / (tempo.last - tempo.first).to_f }

puts "Tap any key in rhythm to find the tempo."
loop do
  char = IO.console.raw(&:getc)
  break if char == 'q'

  tempo = [] if tempo.any? && (Time.now - tempo.last) > 5
  tempo = [2..] if tempo.size >= 5

  tempo << Time.now
  if tempo.size > 1
    puts "Tempo: #{bpm.call(tempo).truncate(1)} bpm"
  else
    puts '[Hit a key one more time to start bpm computation...]'
  end
end
puts 'Bye Bye!'

