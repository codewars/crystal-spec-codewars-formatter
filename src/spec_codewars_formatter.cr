require "spec"

class CodewarsFormatter < Spec::Formatter
  def initialize(@io : IO = STDOUT)
    @context_starts = [] of Time
    @example_start = Time::Span.zero
  end

  def push(context)
    @io.puts "\n<DESCRIBE::>#{escape_lf(context.description)}"
    @context_starts.push Time.utc
  end

  def pop
    span = Time.utc - @context_starts.pop
    @io.puts "\n<COMPLETEDIN::>#{span.total_milliseconds.round(4)}"
  end

  def before_example(description)
    @io.puts "\n<IT::>#{escape_lf(description)}"
    @example_start = Time.utc
  end

  def report(result)
    span = Time.utc - @example_start
    case result.kind
      when :success
        @io.puts "\n<PASSED::>Test Passed"

      when :fail
        if (ex = result.exception) && (msg = ex.message)
          @io.puts "\n<FAILED::>#{escape_lf(msg)}"
        else
          @io.puts "\n<FAILED::>Test Failed"
        end

      when :error
        if ex = result.exception
          @io.puts "\n<ERROR::>#{escape_lf(ex.message || "Unexpected Error")}"
          if backtrace = ex.backtrace?
            @io.puts "\n<LOG::-Backtrace>#{escape_lf(backtrace.join('\n'))}"
          end
        else
          @io.puts "\n<ERROR::>Unexpected Error"
        end

      when :pending

      else
    end

    @io.puts "\n<COMPLETEDIN::>#{span.as(Time::Span).total_milliseconds.round(4)}"
  end

  def print_results(elapsed_time : Time::Span, aborted : Bool)
  end

  def finish
  end

  private def escape_lf(line)
    line.gsub("\n", "<:LF:>")
  end
end
