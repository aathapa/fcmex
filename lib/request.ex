defmodule Fcmex.Request do
  @moduledoc ~S"
    Perform request to FCM
  "

  use Retry
  alias Fcmex.{Util, Config, Payload}

  @fcm_endpoint "https://fcm.googleapis.com/v1/projects/:project_id/messages:send"
                |> String.replace(":project_id", Config.get_progect_id())

  def perform(to, opts) do
    with payload <- Payload.create(to, opts),
         result <- post(payload) do
      Util.parse_result(result)
    end
  end

  defp post(payload) do
    retry with: exponential_backoff() |> randomize |> expiry(10_000) do
      HTTPoison.post(
        @fcm_endpoint,
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
