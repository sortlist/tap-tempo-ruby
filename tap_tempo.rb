#!/usr/bin/ruby -w
require 'io/console'

class TapTempo
  attr_accessor :precision, :reset_time, :sample, :close_char

  def initialize(precision: 1, reset_time: 5, sample: 5, close_char: 'q')
    self.close_char = close_char
    self.precision = precision
    self.reset_time = reset_time
    self.sample = sample
    self.tempo = Tempo.new
  end

  def play
    rules
    loop do
      char = IO.console.raw(&:getc)
      break if char == close_char

      tap
      display_bpm
    end
    bye
  end

  private

  def tap
    self.tempo = Tempo.new if tempo.any? && (Time.now - tempo.max) > reset_time
    self.tempo = tempo.sub_tempo(1..) if tempo.count >= sample

    tempo.tap
  end

  def rules
    puts <<~HELP
      Tap any key in rhythm to find the tempo.
      
      - use the key '#{close_char}' to end the program
      - wait #{reset_time} seconds to reset the tempo
      - only last #{sample} taps are use to compute the beats per minute(bpm)
      - bpm are truncated to use #{precision} decimal digit
    HELP
  end

  def display_bpm
    if tempo.bpm?
      puts "Tempo: #{tempo.bpm.truncate(precision)} bpm"
    else
      puts '[Hit a key one more time to start bpm computation...]'
    end
  end

  def bye
    puts 'Bye Bye!'
  end

  attr_accessor :tempo
end

class Tempo
  include Enumerable

  def initialize(beats = [])
    self.beats = beats
  end

  def bpm
    return unless bpm?

    (60 * (beats.size - 1)) / (beats.last - beats.first).to_f
  end

  def bpm?
    beats.size >= 2
  end

  def tap
    beats << Time.now
  end

  def each(...)
    beats.each(...)
  end

  def sub_tempo(range)
    self.class.new(beats[range])
  end

  private

  attr_accessor :beats
end

TapTempo.new.play
