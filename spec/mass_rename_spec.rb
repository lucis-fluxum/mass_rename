# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MassRename do
  it 'has a version number' do
    expect(MassRename::VERSION).not_to be nil
  end

  describe '.process_options' do
    let(:usage) do
      <<~USAGE
        Usage: mass_rename [options]
            -d, --dir NAME                   Select a different working directory
            -f, --filter PATTERN             Filter files using a regular expression
            -r, --replace PATTERN            Replace matched file names with a replacement string
                --recursive                  Select files in the target directory and all its subdirectories
            -v, --version                    Display version
            -h, --help                       Print this help
      USAGE
    end

    describe 'parses -d, --dir' do
      %w[-d --dir].each do |arg|
        context "#{arg} with value" do
          subject { MassRename.process_options([arg, 'some_dir']) }
          it('returns options hash with directory') { is_expected.to eq(directory: 'some_dir') }
        end

        context "#{arg} without value" do
          subject { -> { MassRename.process_options([arg]) } }
          it('raises an error') { is_expected.to raise_error(OptionParser::MissingArgument) }
        end
      end
    end

    describe 'parses -f, --filter' do
      %w[-f --filter].each do |arg|
        context "#{arg} with value" do
          subject { MassRename.process_options([arg, '\w+[0-9]+']) }
          it('returns options hash with filter') { is_expected.to eq(filter: /\w+[0-9]+/) }
        end

        context "#{arg} without value" do
          subject { -> { MassRename.process_options([arg]) } }
          it('raises an error') { is_expected.to raise_error(OptionParser::MissingArgument) }
        end
      end
    end

    describe 'parses -r, --replace' do
      %w[-r --replace].each do |arg|
        context "#{arg} with value" do
          subject { MassRename.process_options([arg, 'something \1 \2']) }
          it('returns options hash with filter') { is_expected.to eq(replacement: 'something \1 \2') }
        end

        context "#{arg} without value" do
          subject { -> { MassRename.process_options([arg]) } }
          it('raises an error') { is_expected.to raise_error(OptionParser::MissingArgument) }
        end
      end
    end

    it 'parses -v, --version' do
      %w[-v --version].each do |arg|
        expect { MassRename.process_options([arg]) }.to output("#{MassRename::VERSION}\n").to_stdout
      end
    end

    it 'parses -h, --help' do
      %w[-h --help].each do |arg|
        expect { MassRename.process_options([arg]) }.to output(usage).to_stdout
      end
    end
  end

  describe '.file_list' do
    before(:all) do
      Dir.chdir('spec/fixtures')
    end

    [true, false].product([/example file \d\.txt/, nil]).each do |recursive, filter|
      context "recursive: #{recursive}, filter: #{filter.inspect}" do
        subject { MassRename.file_list(recursive: recursive, filter: filter) }
        let(:files) { Array.new(10) { |n| "example file #{n}.txt" } }
        let(:nested_files) { Array.new(5) { |n| "some_dir/example file #{n}.txt" } }

        if !filter.nil? && recursive
          it('returns a list of filenames (recursive)') { is_expected.to match_array(nested_files + files) }
        elsif !filter.nil? && !recursive
          it('returns a list of filenames (non-recursive)') { is_expected.to match_array(files) }
        else
          it('returns empty array') { is_expected.to be_empty }
        end
      end
    end

    after(:all) do
      Dir.chdir('../../')
    end
  end

  describe '.rename' do
    let(:options) { { filter: /example (.*) (\d)/, replacement: 'renamed \1 #00\2' } }

    it 'renames a file with replacement string' do
      10.times do |n|
        MassRename.rename("spec/fixtures/example file #{n}.txt", options)
        expect(File).to exist("spec/fixtures/renamed file #00#{n}.txt")
      end
    end

    after(:each) do
      reset_fixtures
    end
  end

  describe '.run' do
    let(:files) { Array.new(10) { |n| "file ##{n} renamed.txt" } }
    let(:nested_files) { Array.new(5) { |n| "some_dir/file ##{n} renamed.txt" } }

    subject { MassRename.file_list(recursive: false, filter: /file #\d renamed\.txt/) }
    let(:options) { ['-d', 'spec/fixtures', '-f', 'example (.*) (\d)', '-r', '\1 #\2 renamed'] }
    it 'renames multiple files (non-recursive)' do
      MassRename.run(options)
      is_expected.to match_array(files)
    end

    subject { MassRename.file_list(recursive: true, filter: /file #\d renamed\.txt/) }
    let(:options_recursive) { ['-d', 'spec/fixtures', '-f', 'example (.*) (\d)', '-r', '\1 #\2 renamed', '--recursive'] }
    it 'renames multiple files (recursive)' do
      MassRename.run(options_recursive)
      is_expected.to match_array(nested_files + files)
    end

    after(:each) do
      Dir.chdir('../../')
      reset_fixtures
    end
  end
end
