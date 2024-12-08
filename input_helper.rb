require 'net/http'

class InputHelper 
    INPUT_DIRECTORY = 'tmp/inputs/'

    def initialize(solution_file)
        @solution_file = solution_file
        @input_file = INPUT_DIRECTORY + "#{@solution_file.gsub(/\..*/, '')}.txt"
        @day_number = /[1-9]+[0-9]*/.match(@solution_file)[0]
    end

    def input_data!
        unless File.exist?(@input_file)
            data = download_input_data
            save_input_data!(data)
        end        

        File.open(@input_file) { |f| f.read }
    end

    private def download_input_data
        puts "Downloading input data from AoC server..."    

        headers = { 'Cookie' => "session=#{advent_of_code_session_id}" }
        res = Net::HTTP.get_response(URI("https://adventofcode.com/2024/day/#{@day_number}/input"), headers)
        raise "  Error: Response from server: #{res.code}, #{res.message}, #{res.body}" if res.code != "200"

        res.read_body
    end

    private def save_input_data!(data)
        puts "Saving input data downloaded from server..."
        `mkdir -p #{INPUT_DIRECTORY}` unless File.directory?(INPUT_DIRECTORY)
        File.open(@input_file, 'w') do |file|
            file.write(data)
        end
    end

    private def advent_of_code_session_id
        if ENV['SESSION_ID'].nil? || ENV['SESSION_ID'].empty?
            raise "  Error: Must provide environment variable SESSION_ID - this value can be obtained from the AoC website, when logged in, from the browser tools | Application | Cookies | session"
        end

        ENV['SESSION_ID']
    end
end