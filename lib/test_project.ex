defmodule TestProject do
  @moduledoc """
  Documentation for TestProject.
  """

  @doc """
  Hello world.

  ## Examples

      iex> TestProject.hello
      :world

  """
  def hello do
    :world
  end

  def setup_network do
    Nerves.Network.setup "wlan0", networks: [
      [ssid: "netis_3C69A8", key_mgmt: :"WPA-PSK", psk: "denismisha1408"],
      [ssid: "myn", key_mgmt: :"WPA-PSK", psk: "aaaaaaaa", priority: 10]
    ]
  end
  def take_and_read_picture() do
    Picam.Camera.start_link

    Picam.next_frame
    |> Base.encode64()
    |> IO.puts()
  end
end
# MIX_TARGET=rpi3 NERVES_NETWORK_SSID=netis_3C69A8 NERVES_NETWORK_PSK=denismisha1408 mix firmware.burn
