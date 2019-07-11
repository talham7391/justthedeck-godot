extends Node

signal player_states

var client = WebSocketClient.new()
var player_name = null

func _ready():
	client.connect("connection_established", self, "on_connection_established")
	client.connect("connection_closed", self, "on_connection_closed")
	client.connect("connection_error", self, "on_connection_error")
	client.connect("data_received", self, "on_data_received")
	client.connect("server_close_request", self, "on_server_close_request")

func _process(delta):
	if client.get_connection_status() != WebSocketClient.CONNECTION_DISCONNECTED:
		client.poll()

func init(game_id, p_name):
	player_name = p_name
	print("Connecting")
	client.connect_to_url("ws://localhost:8000/ws/%s" % game_id)

func on_connection_established(protocol):
	print("Connected")
	print("Sending name to server.")
	var data = {
		"action": "SET_NAME",
		"data": {
			"name": player_name,
		},
	}
	var err = client.get_peer(1).put_packet(JSON.print(data).to_utf8())
	pass

func on_connection_closed(was_clean_close):
	print("Closed - clean: %s" % was_clean_close)
	pass

func on_connection_error():
	print("Error")
	pass

func on_data_received():
	var data = client.get_peer(1).get_packet()
	var json = JSON.parse(data.get_string_from_utf8())
	handle_message(json.result)

func on_server_close_request(code, reason):
	print("Server requested close because: %s" % reason)

func handle_message(mssg):
	if mssg["action"] == "PLAYER_STATES":
		emit_signal("player_states", mssg["states"])
	
