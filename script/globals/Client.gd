extends Node

var client = null

func start():
	client = WebSocketClient.new()
	client.connect("connection_established", self, "on_connection_established")
	client.connect("connection_closed", self, "on_connection_closed")
	client.connect("connection_error", self, "on_connection_error")
	client.connect("data_received", self, "on_data_received")
	client.connect("server_close_request", self, "on_server_close_request")

	print("Connecting")
	var game_id = State.get_game_id()
	client.connect_to_url("ws://localhost:8000/ws/%s" % game_id)

func _process(delta):
	if client != null and client.get_connection_status() != WebSocketClient.CONNECTION_DISCONNECTED:
		client.poll()

func on_connection_established(protocol):
	print("Connected")
	print("Sending name to server.")
	var data = {
		"name": "SET_NAME",
		"data": {
			"name": State.get_player_name()
		}
	}
	var err = send_obj_to_server(data)
	print(err)

func on_connection_closed(was_clean_close):
	print("Closed - clean: %s" % was_clean_close)

func on_connection_error():
	print("Error")

func on_data_received():
	var data = client.get_peer(1).get_packet()
	var json = JSON.parse(data.get_string_from_utf8())
	handle_message_from_server(json.result)

func on_server_close_request(code, reason):
	print("Server requested close because: %s" % reason)
	
func send_obj_to_server(data):
	return client.get_peer(1).put_packet(JSON.print(data).to_utf8())

func handle_message_from_server(mssg):
	if mssg["name"] == "PLAYERS":
		State.set_players(mssg["players"])
	
	if mssg["name"] == "CARDS_ON_TABLE":
		print("Got cards on table!")
		print(mssg)

	if mssg["name"] == "PLAYER_PUT_CARDS_ON_TABLE":
		Channel.emit_signal(
			"pending_player_put_cards_on_table",
			mssg["playerName"],
			mssg["cards"]
		)