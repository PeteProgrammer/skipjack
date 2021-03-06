# Skipjack

Rake commands for building .NET code

Read about the motivation for Skipjack in [this blog post][1]

## Why Skipjack?

Skipjack is a temporary name given so I can concentrate on the functionality
and defer finding a good name until complete.

But since Skipjack is also the name of an encryption algorithm, I would prefer
to find a different, unambiguous name.

The name was inspired by another gem, Albacore, which is an existing gem also
aiming at building .NET projects using Rake. Both Albacore and Skipjack are
names for types of tuna.

The primary difference between the two gems is that Albacore works as a wrapper
for msbuild, at least for the actual compilation tasks, where you tell it to
build msbuild projects (mostly .csproj files generated by Visual Studio).
Skipjack skips msbuild entirely and calls the compiler tools directly.

## Installation

Add this line to your application's Gemfile:

    gem 'skipjack'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install skipjack

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[1]: http://stroiman.com/software/dotnet/liberate-yourself-from-vs-project-files/
