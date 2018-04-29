defmodule Ssst do
  import Record, only: [defrecord: 2, extract: 2]
  defrecord :xmlElement, extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  defrecord :xmlText, extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
  @http Application.get_env(:ssst, :http, :httpc)

  @moduledoc """
  Ssst!
  """

  @doc """
  Lists objects in a bucket

  ## Examples

      iex> Ssst.list!("https://s3.amazonaws.com/ssst-test")
      [
        %{
          etag: "\\"be2a401b3cab43750487fc4341ee628f\\"",
          key: "private.txt",
          last_modified: DateTime.from_naive!(~N[2018-04-29 19:43:04.000Z], "Etc/UTC"),
          size: 4,
          storage_class: "STANDARD",
          owner: %{id: "65a011a29cdf8ec533ec3d1ccaae921c"}
        },
        %{
          etag: "\\"4212059ccb907291311f28f8168d0b29\\"",
          key: "ssst.txt",
          last_modified: DateTime.from_naive!(~N[2018-04-29 09:12:40.000Z], "Etc/UTC"),
          size: 5,
          storage_class: "STANDARD"
        }
      ]

  """
  def list!(url) do
    url
    |> get!()
    |> document!()
    |> parse!()
  end

  defp get!(url) do
    {:ok, {{_, 200, 'OK'}, _headers, body}} = @http.request(:get, {to_charlist(url), []}, [], [])

    body
  end

  defp document!(body) do
    {document, _} = :xmerl_scan.string(body)

    document
  end

  defp parse!(document) do
    '//ListBucketResult/Contents'
    |> :xmerl_xpath.string(document)
    |> parse!([])
    |> Enum.reverse()
  end

  defp parse!([head | tail], acc) do
    content = xmlElement(head, :content)
    parse!(tail, [element!(content, %{}) | acc])
  end

  defp parse!([], acc), do: acc

  defp element!([head | tail], acc) do
    name = xmlElement(head, :name)

    acc =
      case name do
        :Key ->
          Map.put(acc, :key, text!(head))

        :LastModified ->
          Map.put(acc, :last_modified, date_time!(head))

        :ETag ->
          Map.put(acc, :etag, text!(head))

        :Size ->
          Map.put(acc, :size, integer!(head))

        :StorageClass ->
          Map.put(acc, :storage_class, text!(head))

        :ID ->
          Map.put(acc, :id, text!(head))

        :Owner ->
          content = xmlElement(head, :content)
          Map.put(acc, :owner, element!(content, %{}))

        _ ->
          acc
      end

    element!(tail, acc)
  end

  defp element!([], acc), do: acc

  defp text!(element) do
    element
    |> value!()
    |> List.to_string()
  end

  defp date_time!(element) do
    {:ok, date_time, 0} =
      element
      |> text!()
      |> DateTime.from_iso8601()

    date_time
  end

  defp integer!(element) do
    element
    |> value!()
    |> List.to_integer()
  end

  defp value!(element) do
    [content] = xmlElement(element, :content)

    xmlText(content, :value)
  end
end
