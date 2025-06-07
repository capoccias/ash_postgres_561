defmodule AshPostgres561.Accounts.User do
  use Ash.Resource,
    otp_app: :ash_postgres_561,
    domain: AshPostgres561.Accounts,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "users"
    repo AshPostgres561.Repo
  end

  code_interface do
    define :create
  end

  actions do
    defaults [:read, create: :*]
  end

  attributes do
    uuid_v7_primary_key :id
  end

  relationships do
    has_many :internal_accounts, AshPostgres561.Ledgers.InternalAccount do
      public? true
    end
  end
end
