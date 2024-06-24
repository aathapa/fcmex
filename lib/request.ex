defmodule Fcmex.Request do
  @moduledoc ~S"
    Perform request to FCM
  "

  use Retry
  alias Fcmex.{Util, Config, Payload}

  def perform(to, opts) do
    with payload <- Payload.create(to, opts),
         result <- post(payload) do
      Util.parse_result(result)
    end
  end

  def fcm_endpoint do
    project_id = Config.get_project_id()
    "https://fcm.googleapis.com/v1/projects/#{project_id}/messages:send"
  end

  defp post(payload) do
    retry with: exponential_backoff() |> randomize |> expiry(10_000) do
      HTTPoison.post(
        fcm_endpoint(),
        payload
        |> Config.json_library().encode!(),
        Config.new(),
        Config.httpoison_options()
      )
    after
      result -> result
    else
      error -> error
    end
  end
end
