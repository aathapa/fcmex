#!/bin/bash

mix deps.get
mix deps.compile

elixir --no-halt --sname radar --cookie secret -S mix
