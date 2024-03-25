# Fcmex

[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/shufo/fcmex/ci.yml)](https://github.com/shufo/fcmex/actions?query=workflow%3ACI)
[![Hex.pm](https://img.shields.io/hexpm/v/fcmex.svg)](https://hex.pm/packages/fcmex)
[![Hex Docs](https://img.shields.io/badge/hex-docs-9768d1.svg)](https://hexdocs.pm/fcmex)
[![Coverage Status](https://coveralls.io/repos/github/shufo/fcmex/badge.svg?branch=master)](https://coveralls.io/github/shufo/fcmex?branch=master)

A Firebase Cloud Message client for Elixir

## Installation

Add to dependencies

```elixir
def deps do
  [{:fcmex, "~> 0.6.0"}]
end
```

```bash
mix deps.get
```

## Usage

Fcmex by default reading FCM server key from your environment variable `FCM_SERVER_KEY` on runtime.

If `FCM_SERVER_KEY` is not found in your environment, it fallbacks to search following line.

```elixir
config :fcmex,
  progect_id: "progect_id",
  firebase_json_path: "path to json with service account data"
```

- Send notification message to a device

```elixir
#any data from https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages#Notification
{:ok, body} = Fcmex.push("topic:topic_name", %{"message" =>  %{"notification" => %{title: "title", body: "body"}}})
#or
{:ok, body} = Fcmex.push("token:token", %{"message" =>  %{"notification" => %{title: "title", body: "body"}}})
#or
{:ok, body} = Fcmex.push("condition:condition", %{"message" =>  %{"notification" => %{title: "title", body: "body"}}})
```

- Topic subscription

```elixir
# create a subscription
{:ok, result} = Fcmex.Subscription.subscribe("topic_name", "fcm_token")

# get subscription information related with specified token
{:ok, result} = Fcmex.Subscription.get("fcm_token")
iex> result
 %{
   "application" => "application_name",
   "applicationVersion" => "3.6.1",
   "authorizedEntity" => "1234567890",
   "platform" => "IOS",
   "rel" => %{"topics" => %{"test_topic" => %{"addDate" => "2018-05-03"}}},
   "scope" => "*"
 }}

# create multiple subscriptions
{:ok, result} = Fcmex.Subscription.subscribe("topic_name", ["fcm_token", "fcm_token2"])

# unsubscribe a topic
{:ok, result} = Fcmex.Subscription.unsubscribe("topic_name", "fcm_token")

# batch unsubscribe from a topic
{:ok, result} = Fcmex.Subscription.unsubscribe("topic_name", ["fcm_token", "fcm_token2"])
```

- Check if token is unregistered or not

```elixir
iex> Fcmex.unregistered?(token)
true

iex> tokens = ["token1", "token2", ...]
iex> Fcmex.filter_unregistered_tokens(tokens)
["token1"]
```

### Configuration

You can set httpoison option as below.

```elixir
config :fcmex,
  httpoison_options: [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]
```

`fcmex` uses `Poison` to encode/decode JSON by default. If you want to use alternative library like [`Jason`](https://github.com/michalmuskala/jason), add the package to `mix.exs` and set the module to config.

```elixir
# mix.exs
def deps do
 [
   ...,
   {:jason, "~> 1.3"}
 ]
end
```

```elixir
# config/config.exs
config :fcmex, :json_library, Jason
```

## Contributing

1.  Fork it
2.  Create your feature branch (`git checkout -b my-new-feature`)
3.  Commit your changes (`git commit -am 'Add some feature'`)
4.  Push to the branch (`git push origin my-new-feature`)
5.  Create new Pull Request

## Contributors

<!-- readme: collaborators,contributors -start -->
<table>
<tr>
    <td align="center">
        <a href="https://github.com/shufo">
            <img src="https://avatars.githubusercontent.com/u/1641039?v=4" width="100;" alt="shufo"/>
            <br />
            <sub><b>Shuhei Hayashibara</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/nukosuke">
            <img src="https://avatars.githubusercontent.com/u/17716649?v=4" width="100;" alt="nukosuke"/>
            <br />
            <sub><b>Nukosuke</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/nietaki">
            <img src="https://avatars.githubusercontent.com/u/140347?v=4" width="100;" alt="nietaki"/>
            <br />
            <sub><b>Jacek Królikowski</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/qgadrian">
            <img src="https://avatars.githubusercontent.com/u/489004?v=4" width="100;" alt="qgadrian"/>
            <br />
            <sub><b>Adrián Quintás</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/Fabi755">
            <img src="https://avatars.githubusercontent.com/u/4510679?v=4" width="100;" alt="Fabi755"/>
            <br />
            <sub><b>Fabian Keunecke</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/mbramson">
            <img src="https://avatars.githubusercontent.com/u/6462927?v=4" width="100;" alt="mbramson"/>
            <br />
            <sub><b>Mathew Bramson</b></sub>
        </a>
    </td></tr>
</table>
<!-- readme: collaborators,contributors -end -->

## License

MIT
