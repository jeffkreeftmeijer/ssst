defmodule Ssst.Sandbox do
  def start_link(responses \\ []) do
    Agent.start_link(fn -> responses end, name: __MODULE__)
  end

  @moduledoc """
  Ssst!
  """

  @doc """
  Lists objects in a bucket from a prepared response

  ## Examples

      iex> Ssst.Sandbox.start_link(
      ...>   list!: %{["https://s3.amazonaws.com/ssst-test"] => [%{
      ...>     etag: "\\"be2a401b3cab43750487fc4341ee628f\\"",
      ...>     key: "private.txt",
      ...>     last_modified: DateTime.from_naive!(~N[2018-04-29 19:43:04.000Z], "Etc/UTC"),
      ...>     size: 4,
      ...>     storage_class: "STANDARD",
      ...>     owner: %{id: "65a011a29cdf8ec533ec3d1ccaae921c"}
      ...>   }]}
      ...> )
      ...> Ssst.Sandbox.list!("https://s3.amazonaws.com/ssst-test")
      [
        %{
          etag: "\\"be2a401b3cab43750487fc4341ee628f\\"",
          key: "private.txt",
          last_modified: DateTime.from_naive!(~N[2018-04-29 19:43:04.000Z], "Etc/UTC"),
          size: 4,
          storage_class: "STANDARD",
          owner: %{id: "65a011a29cdf8ec533ec3d1ccaae921c"}
        },
      ]

  """
  def list!(url) do
    Agent.get(__MODULE__, &find_response!(&1, :list!, [url]))
  end

  @doc """
  Gets an object from a bucket with a prepared response

  ## Examples

      iex> Ssst.Sandbox.start_link(
      ...>   get!: %{["https://s3.amazonaws.com/ssst-test/ssst.txt"] => "ssst!"}
      ...> )
      ...> Ssst.Sandbox.get!("https://s3.amazonaws.com/ssst-test/ssst.txt")
      "ssst!"

  """
  def get!(url) do
    Agent.get(__MODULE__, &find_response!(&1, :get!, [url]))
  end

  defp find_response!(state, key, args) do
    state
    |> Keyword.fetch!(key)
    |> Map.get(args)
  end
end

# defmodule SystemMock do
#   def start_link do
#     Agent.start_link(fn -> %{} end, name: __MODULE__)
#   end

#   def set(mock, command, result) do
#     Agent.update(mock, &Map.put(&1, command, result))
#   end

#   def cmd("hostname" = cmd, [] = args) do
#     execute_command_and_replace_result(
#       {cmd, args},
#       "Alices-MBP.fritz.box\n"
#     )
#   end

#   def cmd("git" = cmd, ~w(rev-parse --abbrev-ref HEAD) = args) do
#     execute_command_and_replace_result(
#       {cmd, args},
#       "develop\n"
#     )
#   end

#   def cmd("git" = cmd, ~w(rev-parse HEAD) = args) do
#     execute_command_and_replace_result(
#       {cmd, args},
#       "7f8136915fe249efa47a21a89ff0f04e880264fc\n"
#     )
#   end

#   def cmd("git" = cmd, ~w(status --porcelain) = args) do
#     execute_command_and_replace_result(
#       {cmd, args},
#       " M lib/system_data.ex\n"
#     )
#   end

#   defp execute_command_and_replace_result({cmd, args} = command, replacement) do
#     case System.cmd(cmd, args) do
#       {_, 0} -> {get(command) || replacement, 0}
#       result -> result
#     end
#   end

#   defp get(command) do
#     case Process.whereis(__MODULE__) do
#       nil -> nil
#       _ -> Agent.get(__MODULE__, &Map.get(&1, command))
#     end
#   end
# end
