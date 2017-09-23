# mass_rename
[![Build Status](https://travis-ci.org/lucis-fluxum/mass_rename.svg?branch=master)](https://travis-ci.org/lucis-fluxum/mass_rename) [![codecov](https://codecov.io/gh/lucis-fluxum/mass_rename/branch/master/graph/badge.svg)](https://codecov.io/gh/lucis-fluxum/mass_rename)

Filter and mass rename files in a directory or subdirectories with regular expressions.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mass_rename', git: 'https://github.com/lucis-fluxum/mass_rename.git'
```

And then execute:

    $ bundle

## Usage

    Usage: mass_rename [options]
        -d, --dir NAME                   Select a different working directory
        -f, --filter PATTERN             Filter files using a regular expression
        -r, --replace PATTERN            Replace matched file names with a replacement string
            --recursive                  Select files in the target directory and all its subdirectories
        -v, --version                    Display version
        -h, --help                       Print this help

The following example will recursively rename files matching the pattern "some_file_pattern_(\d)", capture the digit character,
and rename all matching files with the replacement "\1_new_name", substituting the captured digit for "\1".
```
mass_rename --recursive -d target_dir -f "some_file_pattern_(\d)" -r "\1_new_name"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lucis-fluxum/mass_rename.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
