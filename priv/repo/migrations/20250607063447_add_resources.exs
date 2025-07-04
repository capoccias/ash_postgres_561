defmodule AshPostgres561.Repo.Migrations.AddResources do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:users, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v7()"), primary_key: true
    end

    create table(:internal_accounts, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v7()"), primary_key: true
      add :balance, :decimal, null: false, default: "0"
      add :symbol, :smallint, null: false, default: 0

      add :inserted_at, :"timestamptz(6)",
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :"timestamptz(6)",
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :user_id,
          references(:users,
            column: :id,
            name: "internal_accounts_user_id_fkey",
            type: :uuid,
            prefix: "public"
          ),
          null: false
    end
  end

  def down do
    drop constraint(:internal_accounts, "internal_accounts_user_id_fkey")

    drop table(:internal_accounts)

    drop table(:users)
  end
end
