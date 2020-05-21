# frozen_string_literal: true

require 'bundler/setup'
require 'mass_rename'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def reset_fixtures
  FileUtils.rm_r(Dir.glob('spec/fixtures/*'))
  10.times { |n| FileUtils.touch "spec/fixtures/example file #{n}.txt" }
  Dir.mkdir('spec/fixtures/some_dir')
  5.times { |n| FileUtils.touch "spec/fixtures/some_dir/example file #{n}.txt" }
end
