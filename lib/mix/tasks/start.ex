defmodule Mix.Tasks.Start do
    use Mix.Task

    @moduledoc """
      Handle the command line parsing and the dispatch to
      the various functions that end up generating a
      table of the last _n_ issues in a github project
    """



  def run(argv) do
    parse_args(argv)
  end

  def parse_args(argv) do
    {options,_,_} = OptionParser.parse(argv, switches: [name: :string,
                                             aliases: [n: :name]])
    IO.puts options[:name]
  end

end
