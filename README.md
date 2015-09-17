                      __
     _ __  _ __ ___  / _|_ __ ___   ___ _ __ ___
    | '_ \| '__/ _ \| |_| '_ ` _ \ / _ \ '_ ` _ \
    | |_) | | | (_) |  _| | | | | |  __/ | | | | |
    | .__/|_|  \___/|_| |_| |_| |_|\___|_| |_| |_|
    |_|

# Welcome to profmem

A simple tool to profile memory, built to identify memory leaks.

## Usage

Let's say you want to profile the memory consumption of your Rspec
suite...

First in your Gemfile's test group add profmem

    group :test do
      gem 'profmem', require: false
      ...

Secondly in your `spec_helper` file require profmem and start it right
at the top. (It is safe to do this unconditionally as it will only
trigger if the env var PROFMEM is set.)

    require 'profmem'
    Profmem.start

In an after-suite-callback of Rspec tell memprof to summarize it's
findings

    config.after(:suite) do
      Profmem.summarize
    end

Run you Rspec suite with env var PROFMEM set to the destination of the
profiling data

    $ PROFMEM=pm.dump rspec

Finally run profmem to do the number crunching (this might take a
while) and study the results

    $ profmem pm.dump pm.txt
    $ less pm.txt

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
