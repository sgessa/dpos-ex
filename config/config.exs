# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :dpos, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:dpos, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

config :dpos,
  lwf: [
    nethash: "704f232786a9bff25d0630c06abbc34957448ba6309d6dcef949cf9a6f43954a",
    version: "0.1.4",
    port: 18124
  ],
  "lwf-t": [
    nethash: "c16656e85880df9a41abed0aa13b2987b0d853adadc91cbc7e5c8332ea37ccc9",
    version: "0.1.4",
    port: 18101
  ]
