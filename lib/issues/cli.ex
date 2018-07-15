defmodule Issues.CLI do

  @default_count 4

  import IO, only: [puts: 1]
  import Issues.TableFormatter, only: [ print_table_for_columns: 2 ]


  def main(argv) do
     argv
     |> parse_args
     |> process
  end

  def parse_args(argv) do
      OptionParser.parse(argv, switches: [help: :boolean],
                               aliases: [h:     :help])
      |> elem(1)
      |> args_to_internal_representation()
  end

  def args_to_internal_representation([user, project, count]) do
    { user, project, String.to_integer(count) }
  end

  def args_to_internal_representation([user, project]) do
    { user, project, @default_count }
  end

  def args_to_internal_representation(_) do
    :help
  end

  def process(:help) do
    puts """
            usage: issues <user> <project> [ count  | #{@default_count} ]
         """
    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_into_descending_order()
    |> last(count)
    |> print_table_for_columns(["number", "created_at", "title"])
  end

  def last(list, count) do
    list
    |> Enum.take(count)
    |> Enum.reverse
  end

  def sort_into_descending_order(list_of_issues) do
    list_of_issues
    |> Enum.sort(fn il, i2 -> il["created_at"] >= i2["created_at"] end)
  end

  def decode_response({:ok, body}) do
      body
  end

  def decode_response({:error, error}) do
    puts "Error fetching from Github: #{error["message"]}"
  end
end
