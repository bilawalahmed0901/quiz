# frozen_string_literal: true

require 'csv'
require 'timeout'

# Class for keeping track for points
class Point
  def initialize
    @value = 0
  end

  def increment
    @value += 1
  end

  def get
    @value
  end
end

def ask_question_check_answer(question, answer, point)
  print question.concat '? '
  answer_from_user = $stdin.gets.strip

  point.increment if answer_from_user.eql? answer
end

def main(file_name, secs, randomize)
  point = Point.new
  questions = CSV.read file_name
  questions.shuffle! if randomize.eql? true

  print "You will have maximum of #{secs} seconds to answer all questions\n"
  print 'Press enter to start...'
  _ = $stdin.gets

  begin
    Timeout.timeout(secs) do
      questions.each do |question|
        next if question.length != 2

        statement = question[0].strip
        answer = question[1].strip

        ask_question_check_answer statement, answer, point
      end
    end
  rescue Timeout::Error
    print "\nYou have run out of time"
  ensure
    print "\n"
    print 'Your score: ', point.get, '/', questions.length, "\n"
  end
end

file_name = 'problems.csv'
file_name = ARGV[0] if ARGV.length >= 1

timer = 30
begin
  timer = Integer(ARGV[1]) if ARGV.length >= 2
rescue TypeError
  timer = 30
end

randomize = false
randomize = true if ARGV.length >= 3 && ARGV[2] == '-r'

main file_name, timer, randomize
