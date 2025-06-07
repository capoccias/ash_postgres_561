defmodule AshPostgres561.Ledgers do
  use Ash.Domain,
    otp_app: :ash_postgres_561

  resources do
    resource AshPostgres561.Ledgers.InternalAccount
  end
end
