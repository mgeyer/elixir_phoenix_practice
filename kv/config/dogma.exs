use Mix.Config
alias Dogma.Rule

config :dogma,
  # Override an existing rule configuration
  override: [
    %Rule.LineLength{ max_length: 100 }
  ]
