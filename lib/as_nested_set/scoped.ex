defmodule AsNestedSet.Scoped do
  import Ecto.Query

  @type scope :: [atom]

  defmacro __using__(args) do
    quote do
      @scope unquote(Keyword.get(args, :scope, []))
      @before_compile AsNestedSet.Scoped
    end
  end

  defmacro __before_compile__(env) do
    scope = Module.get_attribute(env.module, :scope)

    quote do
      def __as_nested_set_scope__(), do: unquote(scope)
    end
  end

  @spec same_scope?(AsNestedSet.t(), AsNestedSet.t()) :: boolean
  def same_scope?(source, target) do
    source.__struct__ == target.__struct__ &&
      do_same_scope?(source, target)
  end

  @spec scoped_query(Ecto.Query.t(), map) :: Ecto.Query.t()
  def scoped_query(query, scope) do
    %Ecto.Query.FromExpr{source: {_, module}} = query.from
    do_scoped_query(query, scope, module.__as_nested_set_scope__())
  end

  @spec assign_scope_from(any, any) :: any
  def assign_scope_from(%{__struct__: struct} = target, %{__struct__: struct} = source) do
    scope = struct.__as_nested_set_scope__()

    Enum.reduce(scope, target, fn scope, acc ->
      Map.put(acc, scope, Map.fetch!(source, scope))
    end)
  end

  @spec scope(any) :: map
  def scope(%{__struct__: struct} = target) do
    scope = struct.__as_nested_set_scope__()

    Enum.reduce(scope, %{}, fn scope, acc ->
      Map.put(acc, scope, Map.fetch!(target, scope))
    end)
  end

  def scope(module) when is_atom(module) do
    module.__as_nested_set_scope__()
  end

  defp do_scoped_query(query, scope, scope_fields) do
    Enum.reduce(scope_fields, query, fn scope_field, acc ->
      case Map.fetch!(scope, scope_field) do
        nil ->
          acc |> where([p], is_nil(field(p, ^scope_field)))

        v ->
          acc |> where([p], field(p, ^scope_field) == ^v)
      end
    end)
  end

  defp do_same_scope?(%{__struct__: struct} = source, target) do
    scope = struct.__as_nested_set_scope__()

    Enum.all?(scope, fn field ->
      Map.get(source, field) == Map.get(target, field)
    end)
  end
end
