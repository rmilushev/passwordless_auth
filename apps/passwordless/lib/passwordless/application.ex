defmodule Passwordless.Application do
  @moduledoc """
  The Passwordless Application Service.

  The passwordless system business domain lives in this application.

  Exposes API to clients such as the `PasswordlessWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      
    ], strategy: :one_for_one, name: Passwordless.Supervisor)
  end
end
