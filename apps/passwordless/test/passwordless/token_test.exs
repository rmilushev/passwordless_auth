defmodule Passwordless.TokenTest do
  use ExUnit.Case, async: true

  alias Passwordless.Token

  describe ".generate/1" do
    test "returns :invalid when passed data is empty" do
      assert {:error, :invalid} = Token.generate(nil)
      assert {:error, :invalid} = Token.generate("")
    end

    test "returns {:ok, :token}" do
      assert {:ok, _token} = Token. generate("foo")
    end

  end

  describe ".verify/3" do
    test "returns {:ok, data} when token is valid" do
      {:ok, token} = Token.generate("foo")

      assert {:ok, "foo"} = Token.verify(token, "foo")
    end
  end
end
