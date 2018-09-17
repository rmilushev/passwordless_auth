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
end
