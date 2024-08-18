extends Node

const HOST = "127.0.0.1"
const PORT = 13337

func _ready():
	#get_tree().paused = true
	multiplayer.server_relay = false
	if DisplayServer.get_name() == "headless":
		print("Automatically starting dedicated server.")
		create_server.call_deferred()

func create_server():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer

func connect_to_server():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(HOST, PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return
	multiplayer.multiplayer_peer = peer
