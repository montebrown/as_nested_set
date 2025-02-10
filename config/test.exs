import Config

config :as_nested_set, ecto_repos: [AsNestedSet.TestRepo]

config :as_nested_set, AsNestedSet.TestRepo,
  hostname: "localhost",
  database: "as_nested_set_test",
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn
