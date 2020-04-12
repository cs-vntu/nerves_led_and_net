# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

import_config "../../my_app_ui/config/config.exs"

config :test_project, target: Mix.target()

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.

config :shoehorn,
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

node_name = if Mix.env() != :prod, do: "test_project"

config :nerves_init_gadget,
  mdns_domain: "hello_network.local",
  node_name: node_name,
  node_host: :mdns_domain,
  # ifname: "usb0",

  # To use wired Ethernet:
  # ifname: "eth0",
  # address_method: :dhcp

  # To use WiFi:
  ifname: "wlan0",
  address_method: :dhcp

config :test_project, interface: :wlan0, port: 4001

key_mgmt = "WPA-PSK"
# MIX_TARGET=rpi3 NERVES_NETWORK_SSID=netis_3C69A8 NERVES_NETWORK_PSK=denismisha1408 iex -S mix

config :nerves_network, :default,
  wlan0: [
    ssid: System.get_env("NERVES_NETWORK_SSID"),
    psk: System.get_env("NERVES_NETWORK_PSK"),
    key_mgmt: String.to_atom(key_mgmt)
  ]

config :nerves_leds, names: [ error: "led0", connect: "led1" ]
config :nerves_leds,
  states: [
  	fastblink: [ trigger: "timer", delay_off: 40, delay_on: 30 ],
  	blip: [ trigger: "timer", delay_off: 1000, delay_on: 100 ]]

config :logger, backends: [RingLogger]

if Mix.target() != :host do
  import_config "target.exs"
end
