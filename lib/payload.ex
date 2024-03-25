defmodule Fcmex.Payload do
  @moduledoc ~S"
    Create a payload
  "

  def create(to, payload) when is_binary(to) do
    cond do
      String.contains?(to, "topic:") ->
        topic = String.replace(to, "topic:", "")
        put_in(payload, ["message", "topic"], topic)

      String.contains?(to, "token:") ->
        token = String.replace(to, "token:", "")
        put_in(payload, ["message", "token"], token)

      String.contains?(to, "condition:") ->
        condition = String.replace(to, "condition:", "")
        put_in(payload, ["message", "condition"], condition)
    end
  end

  def create(_to, _payload),
    do:
      raise(
        "https://firebase.google.com/docs/cloud-messaging/send-message#send-messages-to-multiple-devices\nImportant: The send methods described in this section were deprecated on June 21, 2023, and will be removed in June 2024. For protocol, instead use the standard HTTP v1 API send method, implementing your own batch send by iterating through the list of recipients and sending to each recipient's token. For Admin SDK methods, make sure to update to the next major version. See the Firebase FAQ for more information."
      )
end
