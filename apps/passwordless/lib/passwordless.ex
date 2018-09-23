defmodule Passwordless do
  @moduledoc """
  Passwordless keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Passwordless.{Repo, Token}

  def provide_token_for(repo \\ Repo, email)
  def provide_token_for(_, email) when email in [nil, ""], do: {:error, :invalid_email}

  def provide_token_for(repo, email) do
    with true <- Repo.exists?(repo, email),
         {:ok, token} <- Token.generate(email),
         :ok <- Repo.save(repo, email) do
      {:ok, token}
    else
      false ->
        {:error, :not_found}
      other ->
        {:error, :internal_error, other}
    end
  end

  def verify_token(repo \\ Repo, token) do
    repo
    |> Repo.finf_by_token(token)
    |> do_verify()
  end

  defp do_verify(nil), do: {:error, :not_found}

  defp do_verify({email, token}), do: Token.verify(token, email)
end
