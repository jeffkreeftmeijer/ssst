defmodule Ssst do
  import Record, only: [defrecord: 2, extract: 2]
  defrecord :xmlElement, extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  defrecord :xmlText, extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

  @moduledoc """
  Ssst!
  """

  @doc """
  Lists objects in a bucket

  ## Examples

      iex> Ssst.list!("https://s3.amazonaws.com/ssst-test")
      [
        %{
          etag: "\\"4212059ccb907291311f28f8168d0b29\\"",
          key: "ssst.txt",
          last_modified: "2018-04-29T09:12:40.000Z",
          size: "5",
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
    {:ok, {{_, 200, 'OK'}, _headers, body}} = :httpc.request(:get, {to_charlist(url), []}, [], [])

    body
  end

  defp document!(body) do
    {document, _} = :xmerl_scan.string(body)

    document
  end

  defp parse!(document) do
    :xmerl_xpath.string('//ListBucketResult/Contents', document)
    |> Enum.map(fn contents ->
      [key, last_modified, etag, size, storage_class] = xmlElement(contents, :content)

      %{
        key: text!(key),
        last_modified: text!(last_modified),
        etag: text!(etag),
        size: text!(size),
        storage_class: text!(storage_class)
      }
    end)
  end

  defp text!(element) do
    [content] = xmlElement(element, :content)

    content
    |> xmlText(:value)
    |> List.to_string()
  end
end
