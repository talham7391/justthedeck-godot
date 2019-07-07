extends Node

var client = WebSocketClient.new()

func _ready():
	client.connect("connection_established", self, "on_connection_established")
	client.connect("connection_closed", self, "on_connection_closed")
	client.connect("connection_error", self, "on_connection_error")
	client.connect("data_received", self, "on_data_received")
	client.connect("server_close_request", self, "on_server_close_request")

func _process(delta):
	if client.get_connection_status() != WebSocketClient.CONNECTION_DISCONNECTED:
		client.poll()

func init(game_id):
	print("Connecting")
	client.connect_to_url("ws://localhost:8000/ws/%s" % game_id)

func on_connection_established(protocol):
	print("Connected")
	pass

func on_connection_closed(was_clean_close):
	print("Closed - clean: %s" % was_clean_close)
	pass

func on_connection_error():
	print("Error")
	pass

func on_data_received():
	var data = client.get_packet()
	print(data.get_string_from_utf8())

func on_server_close_request(code, reason):
	print("Server requested close because: %s" % reason)
