defmodule Phoenix.MTM.Helpers do
  @moduledoc """
  Provides HTML helpers for Phoenix.
  """

  import Phoenix.HTML
  import Phoenix.HTML.Tag
  import Phoenix.HTML.Form

  @doc """
  Generates a list of checkboxes and labels to update a Phoenix
  many_to_many relationship.


  ## Example

      <%= Phoenix.MTM.Helpers.collection_checkboxes f, :tags, Enum.map(@tags, fn tag -> {tag.name, tag.id} end), selected: Enum.map(f.data.tags, &(&1.id)) %>

  """
  def collection_checkboxes(form, field, collection, opts \\ []) do
    name = field_name(form, field) <> "[]"
    selected = Keyword.get(opts, :selected, [])
    input_opts = Keyword.get(opts, :input_opts, [])
    label_opts = Keyword.get(opts, :label_opts, [])

    inputs = Enum.reduce(collection, [], fn {label, value}, acc ->
      id = field_id(form, field) <> "_#{value}"

      input_opts =
        input_opts
        |> Keyword.put(:type, "checkbox")
        |> Keyword.put(:id, id)
        |> Keyword.put(:name, name)
        |> Keyword.put(:value, "#{value}")

      input_opts =
        if Enum.member?(selected, value) do
          Keyword.put(input_opts, :checked, true)
        else
          input_opts
        end

      acc ++ [
        tag(:input, input_opts),
        label(form, field, "#{label}", [for: id] ++ label_opts)
      ]
    end)

    html_escape(
      inputs ++
      hidden_input(form, field, [name: name, value: ""])
    )
  end
end