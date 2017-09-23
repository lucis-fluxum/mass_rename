# frozen_string_literal: true

require 'optparse'
require 'fileutils'

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

      parser.on('-d', '--dir NAME', 'Select a different working directory') do |dir_name|
        options[:directory] = dir_name
      end

      parser.on('-f', '--filter PATTERN', 'Filter files using a regular expression') do |regex|
        options[:filter] = Regexp.new(regex)
      end

      parser.on('-r', '--replace PATTERN', 'Replace matched file names with a replacement string') do |replacement|
        options[:replacement] = replacement
      end

      parser.on('--recursive', 'Select files in the target directory and all its subdirectories') do |recursive|
        options[:recursive] = recursive
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

  # Returns a list of file names matching a pattern, optionally recursive.
  #
  # @param options [Hash] the options returned by {MassRename#process_options}
  # @return [Array<String>] the files matching the filter
  def self.file_list(options)
    Dir.glob(options[:recursive] ? '**/*' : '*').select do |path|
      path =~ options[:filter]
    end
  end

  # Renames a file according to a pattern. The format of the replacement pattern is what you'd
  # pass to +String#gsub+.
  #
  # @param path [String] the path of the file to rename
  # @param options [Hash] the options returned by {MassRename#process_options}
  def self.rename(path, options)
    new_path = path.gsub(options[:filter], options[:replacement])
    FileUtils.mv(path, new_path)
  end

  # Main entry point for this library. Processes the given options and then renames files
  # matching the filter according to the given replacement string.
  #
  # @param args [Array<String>] arguments to parse. Equal to ARGV if you're not doing anything fancy.
  def self.run(args)
    options = MassRename.process_options(args)
    Dir.chdir(options[:directory]) if options[:directory]
    MassRename.file_list(options).each do |path|
      MassRename.rename(path, options)
    end
  end
end
