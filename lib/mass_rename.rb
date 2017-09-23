# frozen_string_literal: true

require 'optparse'

require 'mass_rename/version'

module MassRename
  # Processes the provided options from the command line.
  # Usage and effects for different options are given by running the script with the '-h' flag.
  #
  # @param args [Array] the arguments to the CLI
  # @return [Hash] the arguments as a hash
  def self.process_options(args)
    options = {}
    OptionParser.new do |parser|
      parser.banner = 'Usage: mass_rename [options]'

      parser.on('-f', '--filter PATTERN', 'Filter files using a regular expression') do |regex|
        options[:filter_regex] = Regexp.new(regex)
      end

      parser.on('-v', '--version', 'Display version') do
        puts MassRename::VERSION
      end

      parser.on('-h', '--help', 'Print this help') do
        puts parser
      end

      parser.parse!(args)
    end
    options
  end
end
