defmodule Passwordless.Repo do
  use GenServer
  @name __MODULE__

  def start_link(opts) do
    opts = Keyword.put_new(opts, :name, @name)
    {:ok, emails} = Keyword.fetch(opts, :emails)

    GenServer.start_link(__MODULE__, emails, opts)
  end

  def exists?(pid \\ @name, email),
    do: GenServer.call(pid, {:exists, email})

  def save(pid \\ @name, email, token) do
    GenServer.call(pid, {:save, email, token})
  end

  def fetch(pid \\ @name, email) do
    GenServer.call(pid, {:fetch, email})
  end

  def find_by_token(pid \\ @name, token) do
    GenServer.call(pid, {:find_by_token, token})
  end

  @impl true
  def init(emails) when is_list(emails) and length(emails) > 0 do
    state = Enum.reduce(emails, %{}, &Map.put(&2, &1, nil))

    {:ok, state}
  end

  def init(_), do: {:stop, "Invalid list of emails"}


  @impl true
  def handle_call({:exists, email}, _from, state) do
    {:reply, Map.has_key?(state, email), state}
  end

  def handle_call({:save, email, token}, _from, state) do
    if Map.has_key?(state, email) do
      {:reply, :ok, Map.put(state, email, token)}
    else
      {:reply, {:error, :invalid_email}, state}
    end
  end

  def handle_call({:fetch, email}, _from, state) do
    {:reply, Map.fetch(state, email), state}
  end

  def handle_call({:find_by_token, token}, _from, state) do
    {:reply, Enum.find(state, &(elem(&1, 1) == token)), state}
  end
end
