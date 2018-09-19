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

    children = [
      worker(
        Passwordless.Repo,
        [[emails: emails()]]
      )
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Passwordless.Supervisor)
  end

  defp emails, do: Application.get_env(:passwordless, :repo)[:emails]
end
