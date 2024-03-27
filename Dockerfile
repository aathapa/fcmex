FROM elixir:1.14.0

RUN apt-get update -qq && apt-get install -y libpq-dev && apt-get install -y build-essential inotify-tools erlang-dev erlang-parsetools apt-transport-https ca-certificates && apt-get update

RUN mix local.hex --force && mix local.rebar --force

RUN mkdir /home/app && cd /home/app

ARG MIX_ENV
ENV MIX_ENV $MIX_ENV

ADD entrypoint.sh /entrypoint.sh

WORKDIR /home/app
RUN chmod +x /entrypoint.sh
CMD [ "/entrypoint.sh" ]
