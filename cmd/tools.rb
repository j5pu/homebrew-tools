# frozen_string_literal: true

module Homebrew
  module_function

  def tools_args
    Homebrew::CLI::Parser.new do
      description <<~EOS
        Tap j5pu/tools commands.
      EOS
      switch "-l", "--list",
             description: "list formulas in tap."
      switch "-b", "--bin",
             description: "list files installed in bin."
      flag   "--file=",
             description: "Specify a file to do something with in the command."
      comma_array "--names",
                  description: "Add a list of names to the command."

      named_args [:formula, :cask], min: 1
    end
  end

  def tools
    args = tools_args.parse

    system 'ls /usr/local/Homebrew/Library/Taps/j5pu/homebrew-tools/Formula/ | sed "s/.rb//g"' if args.list?
    system 'ls /usr/local/bin' if args.bin?
    system 'echo file' if args.file == "file.txt"
  end
end
