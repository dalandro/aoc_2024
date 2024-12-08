require_relative 'input_helper.rb'

class Solution
    def initialize(raw_data=nil)
        @raw_data = raw_data || InputHelper.new(__FILE__).input_data!

        @input_data = @raw_data.split("\n")
                               .filter { |line| /\d+/.match?(line) }
                               .map { |line| line.strip.split(/\s+/).map(&:to_i) }
    end
    attr_accessor :input_data

    def part_1
        input_data.map do |values|
            res = true

            prev = values[0]
            increasing = nil
            values[1..].each do |curr|
                if increasing.nil?
                    increasing = curr > prev
                end
              
                if increasing
                    unless curr > prev && [1, 2, 3].include?(curr - prev)
                        res = false
                        break
                    end
                else
                    unless curr < prev && [1, 2, 3].include?(prev - curr)
                        res = false
                        break
                    end
                end

                prev = curr
            end
            
            res
        end.count(true)
    end

    def part_2
        input_data.map do |values|
            res = true

            i = 1
            prev = values[0]
            increasing = nil
            ignored_i = nil

            while i < values.length
                if ignored_i == i
                    i += 1
                    next
                end
                curr = values[i]

                increasing = curr > prev if increasing.nil?
              
                if ((increasing && curr > prev) || (!increasing && curr < prev)) && safe_jump?(curr, prev)
                    prev = curr
                    i += 1
                else
                    if !ignored_i
                        ignored_i = 0
                        increasing = nil
                        i = 2
                        prev = values[1]
                    elsif ignored_i < values.length
                        ignored_i += 1
                        increasing = nil
                        i = 1
                        prev = values[0]
                    else
                        res = false
                        break   
                    end
                end
            end
            
            res
        end.count(true)
    end

    private def safe_jump?(a, b)
      diff = [a, b].max - [a, b].min
      [1, 2, 3].include?(diff) 
    end

    TEST_DATA = """
        7 6 4 2 1
        1 2 7 8 9
        9 7 6 2 1
        1 3 2 4 5
        8 6 4 4 1
        1 3 6 7 9
    """
    def self.test_part_1
        expectation = 2
        res = self.new(TEST_DATA).part_1
        if res != expectation
            raise "expected #{expectation}, got #{res}"
        else
            "Part 1 Test successful"
        end
    end

    def self.test_part_2
        expectation = 4
        res = self.new(TEST_DATA).part_2
        if res != expectation
            raise "expected #{expectation}, got #{res}"
        else
            "Part 2 Test successful"
        end
    end
end

puts Solution.test_part_1
puts "My part 1 solution result: #{Solution.new.part_1}"
puts ""
puts Solution.test_part_2
puts "My part 2 solution result: #{Solution.new.part_2}"
