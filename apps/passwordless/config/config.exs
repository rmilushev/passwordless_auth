use Mix.Config

config :passwordless,
       :repo,
       emails: ~w(first@cre.actor second@cre.actor 3@cre.actor)

config :passwordless,
       Passwordless.Token,
       secret_key_base: "YBxmBMA3XEJUvZ1suUkHXg5D62WUgVw1/lxFW/NWewqKGKXeJPzaowtpDdeDp1MB"

import_config "#{Mix.env}.exs"
