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
            -f, --filter PATTERN             Filter files using a regular expression
            -v, --version                    Display version
            -h, --help                       Print this help
      USAGE
    end

    it 'parses -h, --help' do
      %w[-h --help].each do |arg|
        expect { MassRename.process_options([arg]) }.to output(usage).to_stdout
      end
    end

    it 'parses -v, --version' do
      %w[-v --version].each do |arg|
        expect { MassRename.process_options([arg]) }.to output("#{MassRename::VERSION}\n").to_stdout
      end
    end

    describe 'parses -f, --filter' do
      %w[-f --filter].each do |arg|
        context "#{arg} with value" do
          subject { MassRename.process_options([arg, '\w+[0-9]+']) }
          it('returns options hash with filter') { is_expected.to eq(filter_regex: /\w+[0-9]+/) }
        end

        context "#{arg} without value" do
          subject { -> { MassRename.process_options([arg]) } }
          it('raises an error') { is_expected.to raise_error(OptionParser::MissingArgument) }
        end
      end
    end
  end
end
