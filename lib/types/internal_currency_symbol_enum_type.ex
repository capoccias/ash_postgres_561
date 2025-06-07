defmodule AshPostgres561.Types.InternalCurrencySymbolEnumType do
  use Ash.Type.Enum, values: [:token, :xp]

  @values %{0 => :token, 1 => :xp}
  @inverse_values Map.new(@values, fn {k, v} -> {v, k} end)

  @impl Ash.Type
  def storage_type(), do: :smallint

  # Casting input values (e.g., from forms or changesets)
  @impl Ash.Type
  def cast_input(value, _) do
    if value in Map.values(@values), do: {:ok, value}, else: :error
  end

  # Dumping atoms to integers for database storage
  @impl Ash.Type
  def dump_to_native(value, _) do
    if value in Map.values(@values), do: {:ok, Map.fetch!(@inverse_values, value)}, else: :error
  end

  # Loading integers from the database into atoms
  @impl Ash.Type
  def cast_stored(value, _) do
    if value in Map.keys(@values), do: {:ok, Map.fetch!(@values, value)}, else: :error
  end

  def value_from_atom(atom), do: Map.fetch!(@inverse_values, atom)
  def atom_from_value(value), do: Map.fetch!(@values, value)
end
