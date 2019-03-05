use Mix.Config

config :exsync,
  reload_timeout: 75,
  reload_callback: {GenServer, :call, [ScenicEscher.Refresher, :refresh_home]}
