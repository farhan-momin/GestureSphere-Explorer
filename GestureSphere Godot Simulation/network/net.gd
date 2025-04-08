extends Node2D

func _ready():
  get_tree().connect("network_peer_connected", self, "_player_connected")

func _player_connected(id):
  print("Player connected to server!")
  #Game on!
  globals.otherPlayerId = id
  var game = preload("res://Game.tscn").instance()
  get_tree().get_root().add_child(game)
  hide()

func _on_buttonHost_pressed():
  print("Hosting network")
  var host = NetworkedMultiplayerENet.new()
  var res = host.create_server(4242,2)
  if res != OK:
    print("Error creating server")
    return

  $buttonJoin.hide()
  $buttonHost.disabled = true
  get_tree().set_network_peer(host)


func _on_buttonJoin_pressed():
  print("Joining network")
  var host = NetworkedMultiplayerENet.new()
  host.create_client("127.0.0.1",4242)
  get_tree().set_network_peer(host)
  $buttonHost.hide()
  $buttonJoin.disabled = true