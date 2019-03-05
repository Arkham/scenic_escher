defmodule ScenicEscher.Refresher do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :hello)
  end

  def init(_) do
    Process.register(self(), __MODULE__)
    {:ok, :started}
  end

  def handle_call(:refresh_home, _, state) do
    send(self(), :refresh_home)
    Process.send_after(self(), :refresh_home, 100)
    {:reply, :ok, state}
  end

  def handle_info(:refresh_home, state) do
    case Process.whereis(ScenicEscher.Scene.Home) do
      nil ->
        :no_op

      pid ->
        Process.exit(pid, :kill)
    end

    {:noreply, state}
  end
end
