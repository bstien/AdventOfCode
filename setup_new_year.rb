require 'fileutils'

ADVENT_DIRECTORY = "AdventOfCode"

def code_for_day(day, year)
  <<~SWIFT
  import Foundation

  extension Year#{year}.Day#{day}: Runnable {
      func run(input: String) {
          let lines = splitInput(input)
          part1(lines: lines)
          part2(lines: lines)
      }

      private func part1(lines: [String]) {
      }

      private func part2(lines: [String]) {
      }
  }
  SWIFT
end

def code_for_year(year)
  day_list = (1..24).map do |day|
    "        #{"// " unless day == 1}Day#{day}.self,"
  end
  day_declarations = (1..24).map do |day|
    "    class Day#{day}: Day {}"
  end

  <<~SWIFT
  import Foundation

  enum Year#{year}: Year {
      static var year = #{year}
      static var days: [Day.Type] = [
  #{day_list.join("\n")}
      ]
  }

  extension Year#{year} {
  #{day_declarations.join("\n")}
  }
  SWIFT
end

def write_contents(file_path, contents)
  if File.exist?(file_path)
    puts "File already exists: #{file_path}"
  else
    File.write(file_path, contents)
    puts "Created file: #{file_path}"
  end
end

# Create a new file for each day
def create_files_for_year(year)
  base_dir = "#{ADVENT_DIRECTORY}/Years/#{year}"

  # Ensure the base directory exists
  FileUtils.mkdir_p(base_dir) unless Dir.exist?(base_dir)

  # Write file for the year.
  write_contents("#{base_dir}/Year#{year}.swift", code_for_year(year))

  # Write each day.
  (1..24).each do |day|
    file_name = "Day#{day}.#{year}.swift"
    file_path = "#{base_dir}/#{file_name}"
    write_contents(file_path, code_for_day(day, year))
  end
end

def create_input_files(year)
  base_dir = "#{ADVENT_DIRECTORY}/Inputs/#{year}"

  # Ensure the base directory exists
  FileUtils.mkdir_p(base_dir) unless Dir.exist?(base_dir)

  # Write input files.
  (1..24).each do |day|
    write_contents("#{base_dir}/#{day}.txt", "")
    write_contents("#{base_dir}/#{day}.test.txt", "")
  end
end

# Main execution
if ARGV.empty?
  puts "Usage: ruby setup_new_year.rb <YEAR>"
  exit 1
end

year = ARGV[0]
puts "Setting up Advent of Code files for #{year}..."
create_files_for_year(year)
create_input_files(year)
puts "Setup complete!"