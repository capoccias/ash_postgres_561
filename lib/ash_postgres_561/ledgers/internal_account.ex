defmodule AshPostgres561.Ledgers.InternalAccount do
  use Ash.Resource,
    otp_app: :ash_postgres_561,
    domain: AshPostgres561.Ledgers,
    data_layer: AshPostgres.DataLayer

  alias __MODULE__

  postgres do
    table "internal_accounts"
    repo AshPostgres561.Repo
  end

  code_interface do
    define :create
    define :update
  end

  actions do
    defaults [:read, create: :*, update: :*]

    update :update_balance do
      require_atomic? true

      argument :amount, :decimal, allow_nil?: false

      validate {InternalAccount.Validations.BalanceIsSufficient, []},
        where: [compare(:amount, less_than: 0)]

      change atomic_update(:balance, expr(balance + type(^arg(:amount), :decimal)))
    end
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :balance, :decimal do
      default 0
      constraints min: 0
      allow_nil? false
      public? true
    end

    attribute :symbol, AshPostgres561.Types.InternalCurrencySymbolEnumType do
      default :token
      allow_nil? false
      public? true
    end

    timestamps(type: AshPostgres.TimestamptzUsec)
  end

  relationships do
    belongs_to :user, AshPostgres561.Accounts.User do
      allow_nil? false
      public? true
    end
  end
end
