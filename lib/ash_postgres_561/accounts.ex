defmodule AshPostgres561.Accounts do
  use Ash.Domain,
    otp_app: :ash_postgres_561

  resources do
    resource AshPostgres561.Accounts.User
  end
end
