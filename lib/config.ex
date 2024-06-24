defmodule Fcmex.Config do
  @moduledoc ~S"
    A configuration for FCM
  "

  def new do
    [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer  #{Fcmex.TokenExtractor.get_token()}"}
    ]
  end

  def retrieve_on_run_time(key) do
    System.get_env(key)
  end

  def httpoison_options() do
    Application.get_env(:fcmex, :httpoison_options, [])
  end

  def get_project_id() do
    Application.get_env(:fcmex, :project_id, "")
  end

  def get_service_json_path do
    Application.get_env(:fcmex, :service_account_json_path, "")
  end

  def json_library do
    Application.get_env(:fcmex, :json_library, Poison)
  end
end
