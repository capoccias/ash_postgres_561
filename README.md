# A reproduction for AshPostgres issue #561
https://github.com/ash-project/ash_postgres/issues/561


## Created using helper script on ash-hq.org
```sh
sh <(curl 'https://ash-hq.org/install/ash_postgres_561?install=phoenix') \
    && cd ash_postgres_561 && mix igniter.install ash ash_phoenix \
    ash_postgres --yes && mix ash.setup
```

## To reproduce:
1. `mix setup`\
  This expects a db at localhost:5432
1. `iex -S mix phx.server`\
  This is set to run on port 3000
1. 
```elixir
import Ash.Query
alias AshPostgres561.Ledgers.InternalAccount
alias AshPostgres561.Accounts.User

user = User.create!
internal_account = InternalAccount.create!(%{user_id: user.id, balance: Decimal.new(1)})
internal_account |> Ash.Changeset.for_update(:update_balance, %{amount: Decimal.new("-1")}) |> Ash.update!
```

## Additional info

I was getting an error that was fixed by adding the `protocols.ex` file per some llm help:

```
** (Ash.Error.Unknown)
Bread Crumbs:
  > Returned from bulk query update: AshPostgres561.Ledgers.InternalAccount.update_balance


Unknown Error

* ** (Protocol.UndefinedError) protocol Jason.Encoder not implemented for type Decimal (a struct), Jason.Encoder protocol must always be explicitly implemented.

If you own the struct, you can derive the implementation specifying which fields should be encoded to JSON:

    @derive {Jason.Encoder, only: [....]}
    defstruct ...

It is also possible to encode all fields, although this should be used carefully to avoid accidentally leaking private information when new fields are added:

    @derive Jason.Encoder
    defstruct ...

Finally, if you don't own the struct you want to encode to JSON, you may use Protocol.derive/3 placed outside of any module:

    Protocol.derive(Jason.Encoder, NameOfTheStruct, only: [...])
    Protocol.derive(Jason.Encoder, NameOfTheStruct)
. This protocol is implemented for the following type(s): Any, Ash.CiString, Ash.Union, Atom, BitString, Date, DateTime, Ecto.Association.NotLoaded, Ecto.Schema.Metadata, Float, Integer, Jason.Fragment, Jason.OrderedObject, List, Map, NaiveDateTime, Time

Got value:

    Decimal.new("0")

  (jason 1.4.4) lib/jason.ex:164: Jason.encode!/2
  (ash_sql 0.2.78) lib/expr.ex:1960: AshSql.Expr.default_dynamic_expr/6
  (ash_sql 0.2.78) lib/expr.ex:724: AshSql.Expr.default_dynamic_expr/6
  (ash_sql 0.2.78) lib/expr.ex:1776: AshSql.Expr.default_dynamic_expr/6
  (ash_sql 0.2.78) lib/expr.ex:128: AshSql.Expr.default_dynamic_expr/6
  (ash_sql 0.2.78) lib/expr.ex:714: AshSql.Expr.default_dynamic_expr/6
  (ash_sql 0.2.78) lib/expr.ex:1776: AshSql.Expr.default_dynamic_expr/6
  (ash_sql 0.2.78) lib/atomics.ex:242: anonymous fn/3 in AshSql.Atomics.query_with_atomics/6
  (elixir 1.18.3) lib/enum.ex:4968: Enumerable.List.reduce/3
  (elixir 1.18.3) lib/enum.ex:2600: Enum.reduce_while/3
  (ash_sql 0.2.78) lib/atomics.ex:215: AshSql.Atomics.query_with_atomics/6
  (ash_postgres 2.6.3) lib/data_layer.ex:1482: AshPostgres.DataLayer.update_query/4
  (ash 3.5.15) lib/ash/actions/update/bulk.ex:572: Ash.Actions.Update.Bulk.do_atomic_update/5
  (ash 3.5.15) lib/ash/actions/update/bulk.ex:257: Ash.Actions.Update.Bulk.run/6
  (ash 3.5.15) lib/ash/actions/update/update.ex:169: Ash.Actions.Update.run/4
  (ash 3.5.15) lib/ash.ex:3622: Ash.update/3
  (ash 3.5.15) lib/ash.ex:3540: Ash.update!/3
  (elixir 1.18.3) src/elixir.erl:386: :elixir.eval_external_handler/3
  (stdlib 6.2.2) erl_eval.erl:919: :erl_eval.do_apply/7
  (elixir 1.18.3) src/elixir.erl:364: :elixir.eval_forms/4
    (ash 3.5.15) lib/ash/error/unknown.ex:3: Ash.Error.Unknown."exception (overridable 2)"/1
    (ash 3.5.15) /ash_postgres_561/deps/splode/lib/splode.ex:264: Ash.Error.to_class/2
    (ash 3.5.15) lib/ash/error/error.ex:108: Ash.Error.to_error_class/2
    (ash 3.5.15) lib/ash/actions/update/bulk.ex:808: Ash.Actions.Update.Bulk.do_atomic_update/5
    (ash 3.5.15) lib/ash/actions/update/bulk.ex:257: Ash.Actions.Update.Bulk.run/6
    (ash 3.5.15) lib/ash/actions/update/update.ex:169: Ash.Actions.Update.run/4
    (ash 3.5.15) lib/ash.ex:3622: Ash.update/3
    (ash 3.5.15) lib/ash.ex:3540: Ash.update!/3
    iex:36: (file)
```