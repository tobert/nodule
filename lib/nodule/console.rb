require 'nodule/base'

module Nodule
  #
  # a simple colored output resource
  #
  # e.g. Nodule::Console.new(:fg => :green)
  # Nodule::Console.new(:fg => :green, :bg => :white)
  #
  class Console < Base
    COLORS = {
      :black   => "\x1b[30m",
      :red     => "\x1b[31m",
      :green   => "\x1b[32m",
      :yellow  => "\x1b[33m",
      :blue    => "\x1b[34m",
      :magenta => "\x1b[35m",
      :cyan    => "\x1b[36m",
      :white   => "\x1b[37m",
      :dkgray  => "\x1b[1;30m",
      :dkred   => "\x1b[1;31m",
      :reset   => "\x1b[0m",
    }.freeze

    #
    # Create a new console handler. Defaults to printing to STDERR without color.
    # Color output is automatically disabled on non-tty devices. It can be
    # force-enabled with the CLICOLOR_FORCE environment variable.
    # The list of valid colors is in Nodule::Console::COLORS.
    #
    # @param [Hash] opts
    # @option [Symbol] opts :fg the foreground color symbol
    # @option [Symbol] opts :bg the background color symbol
    # @option [IO] opts :io default STDERR an IO object to display on, STDOUT/files should work fine
    #
    def initialize(opts={})
      super(opts)
      @fg = opts[:fg]
      @bg = opts[:bg]

      if @fg and not COLORS.has_key?(@fg)
        raise ArgumentError.new "fg :#{@fg} is not a valid color"
      end

      if @bg and not COLORS.has_key?(@bg)
        raise ArgumentError.new "bg :#{@bg} is not a valid color"
      end

      # IO handle to use as the console
      @io = opts[:io] || STDERR

      # from https://github.com/sickill/rainbow/blob/master/lib/rainbow.rb
      @enabled = @io.tty? && ENV['TERM'] != 'dumb' || ENV['CLICOLOR_FORCE'] == '1'

      add_reader { |line,src| display(src, line) }
    end

    def fg(str)
      return str unless @enabled
      "#{COLORS[@fg]}#{str}"
    end

    def bg(str)
      return str unless @enabled
      "#{COLORS[@bg]}#{str}"
    end

    def reset(str)
      return str unless @enabled
      "#{str}#{COLORS[:reset]}"
    end

    #
    # Write to stdout using puts, but append a prefix if it's defined.
    # @param [Object] src if this responds to :prefix, :prefix will be prepended to the output
    # @param [String] line the data to write to stdout
    #
    def display(src, line)
      if src.respond_to? :prefix
        @io.print "#{reset('')}#{src.prefix}#{reset(bg(fg(line)))}\n"
      else
        @io.print "#{reset(bg(fg(line)))}\n"
      end
    end

  end
end
