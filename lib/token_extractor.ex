defmodule Fcmex.TokenExtractor do
  use GenServer
  alias Fcmex.{Config, Util}

  @firebase_scope "https://www.googleapis.com/auth/firebase.messaging"

  @impl true
  def init(_) do
    credentials =
      Config.get_service_json_path()
      |> File.read!()
      |> Config.json_library().decode!()

    {:ok, %{"credentials" => credentials, "token" => nil, "expires_after" => nil}}
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def get_token(scopes \\ @firebase_scope), do: GenServer.call(__MODULE__, {:get_token, scopes})

  @impl true
  def handle_call({:get_token, scopes}, _from, %{"credentials" => credentials, "token" => nil}) do
    %{"access_token" => token, "expires_after" => expires_after} =
      get_new_token(credentials, scopes)

    {:reply, token,
     %{"credentials" => credentials, "token" => token, "expires_after" => expires_after}}
  end

  def handle_call(
        {:get_token, scopes},
        _from,
        %{"credentials" => credentials, "expires_after" => expires_after} = state
      ) do
    now_seconds = :os.system_time(:seconds)

    state =
      cond do
        now_seconds > expires_after ->
          %{"access_token" => token, "expires_after" => expires_after} =
            get_new_token(credentials, scopes)

          %{"credentials" => credentials, "token" => token, "expires_after" => expires_after}

        true ->
          state
      end

    {:reply, state["token"], state}
  end

  defp get_new_token(
         %{
           "client_email" => service_account_email,
           "private_key" => private_key,
           "token_uri" => token_uri
         },
         scopes
       ) do
    now_seconds = :os.system_time(:seconds)
    expires_after = now_seconds + 60 * 59

    payload = %{
      "iss" => service_account_email,
      "scope" => scopes,
      "aud" => token_uri,
      "exp" => expires_after,
      "iat" => now_seconds
    }

    {_, %{} = key_map} =
      JOSE.JWK.from_pem(private_key)
      |> JOSE.JWK.to_map()

    signer = Joken.Signer.create("RS256", key_map)

    {:ok, token, _} = Joken.encode_and_sign(payload, signer)

    {:ok, %{"access_token" => token}} =
      HTTPoison.post(
        token_uri,
        Jason.encode!(%{
          grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
          assertion: token
        })
      )
      |> Util.parse_result()

    %{"access_token" => token, "expires_after" => expires_after}
  end
end
