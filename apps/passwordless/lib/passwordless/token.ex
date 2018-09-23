defmodule Passwordless.Token do
  alias Phoenix.Token, as: PhoenixToken

  @salt "token_salt"
  @max_age :timer.minutes(5) / 1000
  @secret Application.get_env(:passwordless, __MODULE__)[:secret_key_base]

  def generate(data) when data in [nil, ""], do: {:error, :invalid}

  def generate(data) do
    {:ok, PhoenixToken.sign(@secret, @salt, data)}
  end

  def verify(token, data, max_age \\ @max_age) do
    case PhoenixToken.verify(
      @secret,
      @salt,
      token,
      max_age: max_age) do
        {:ok, ^data} ->
          {:ok, data}

        {:ok, _other} ->
          {:error, :invalid}

        {:error, reason} ->
          {:error, reason}
      end
  end
end
