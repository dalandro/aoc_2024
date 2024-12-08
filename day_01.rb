require_relative 'input_helper.rb'

class Solution
    def initialize(raw_data=nil)
        @raw_data = raw_data || InputHelper.new(__FILE__).input_data!

        @input_data = @raw_data.split("\n")
                               .reduce({a: [], b: [] }) do |acc, line|
            /(\d+)\s+(\d+)/.match(line) do |m|
                acc[:a] << m[1].to_i
                acc[:b] << m[2].to_i
            end

            acc
        end
    end
    attr_accessor :input_data

    def part_1
        input_data[:a].sort!
        input_data[:b].sort!

        input_data[:a].zip(input_data[:b]).reduce(0) do |sum, (a, b)|
            sum + [a, b].max - [a, b].min
        end 
    end

    def part_2
        input_data[:a].reduce(0) do |score, a|
            score += a * input_data[:b].filter { |b| b == a }.count
        end
    end

    TEST_DATA = """
        3   4
        4   3
        2   5
        1   3
        3   9
        3   3
    """
    def self.test_part_1
        expectation = 11
        res = self.new(TEST_DATA).part_1
        if res != expectation
            raise "expected #{expectation}, got #{res}"
        else
            puts "Part 1 Test successful"
        end
    end

    def self.test_part_2
        expectation = 31
        res = self.new(TEST_DATA).part_2
        if res != expectation
            raise "expected #{expectation}, got #{res}"
        else
            puts "Part 2 Test successful"
        end
    end
end

puts Solution.test_part_1
puts "My part 1 solution result: #{Solution.new.part_1}"

puts Solution.test_part_2
puts "My part 2 solution result: #{Solution.new.part_2}"
