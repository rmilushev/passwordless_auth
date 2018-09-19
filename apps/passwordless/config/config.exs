use Mix.Config

config :passwordless,
       :repo,
       emails: ~w(first@cre.actor second@cre.actor 3@cre.actor)


import_config "#{Mix.env}.exs"
