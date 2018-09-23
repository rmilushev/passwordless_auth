defmodule Passwordless.RepoTest do
  use ExUnit.Case, async: true

  alias Passwordless.Repo

  describe ".init/1" do
    test "returns error when emails are wrong" do
      Process.flag(:trap_exit, true)

      name = :repo_test_1

      Repo.start_link(name: name, emails: "")

      assert_receive {:EXIT, _, "Invalid list of emails"}
    end

    test "it starts the genserver when emails is a list" do
      name = :repo_test_1
      assert {:ok, _pid} = Repo.start_link(name: name, emails: ["probe@cre.actor"])
    end
  end

  describe ".exists?/2" do
    test "returns true if email is in the repo's state" do
      name = :repo_test_2
      email = "first@cre.actor"
      {:ok, _pid} = Repo.start_link(name: name, emails: [email])
      assert Repo.exists?(name, email)

    end

    test "returns false if email is not in the repo's emails" do
      name = :repo_test_3
      email = "second@cre.actor"
      {:ok, _pid} = Repo.start_link(name: name, emails: [email])

      refute Repo.exists?(name, "not_found@cre.actor")

    end
  end

  describe ".save/3" do
    test "returns :ok and saves the token in state when email exists" do
      name = :repo_test_4
      email = "3@cre.actor"
      token = "token123456"

      {:ok, _pid} = Repo.start_link(name: name, emails: [email])

      assert :ok = Repo.save(name, email, token)
      assert %{"3@cre.actor" => ^token} = :sys.get_state(name)
    end

    test "returns {:error, :invalid_email} when email does not exist" do
      name = :repo_test_5
      email = "4@cre.actor"
      token = "token-val"

      {:ok, _pid} = Repo.start_link(name: name, emails: [email])

      assert {:error, :invalid_email} = Repo.save(name, "no@cre.actor", token)

    end
  end

  describe ".fetch/2" do
    test "returns {:ok, token} for passed email" do
      name = :repo_test_6
      email = "r@cre.actor"
      token = "token-value"

      {:ok, _pid} = Repo.start_link(name: name, emails: [email])
      :ok = Repo.save(name, email, token)

      assert {:ok, ^token} = Repo.fetch(name, email)

    end

    test "returns :error when token not found" do
      name = :repo_test_7
      email = "r@cre.actor"
      token = "token-value"

      {:ok, _pid} = Repo.start_link(name: name, emails: [email])
      :ok = Repo.save(name, email, token)

      assert :error = Repo.fetch(name, "not_found@cre.actor")

    end
  end

  describe ".find_by_token/2" do
    test "returns the {email, token} if token is present" do
      name = :repo_test_8
      email = "8@cre.actor"
      token = "token-value"

      {:ok, _pid} = Repo.start_link(name: name, emails: [email])
      :ok = Repo.save(name, email, token)

      assert {^email, ^token} = Repo.find_by_token(name, token)
    end

    test "returns nil if token not found" do
      name = :repo_test_9
      email = "9@cre.actor"
      token = "token_value"

      {:ok, _pid} = Repo.start_link(name: name, emails: [email])

      :ok = Repo.save(name, email, token)

      assert nil == Repo.find_by_token(name, "other_token")
    end
  end
end
