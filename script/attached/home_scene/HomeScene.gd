extends Control

func _ready():
	$input_player_name.text = State.get_player_name()

	$button_create_game.connect("pressed", self, "on_create_game")
	$button_join_game.connect("pressed", self, "on_join_game")
	$input_player_name.connect("text_changed", self, "on_player_name_change")
	$HTTPRequest.connect("request_completed", self, "on_request_completed")

func on_player_name_change(new_name):
	State.set_player_name(new_name)

func on_create_game():
	block_input()
	$HTTPRequest.request(
		"http://localhost:8000/games",
		PoolStringArray(),
		true,
		HTTPClient.METHOD_POST
	)

func on_join_game():
	$dialog_join_game.popup()

func on_request_completed(result, response_code, headers, body):
	if response_code == HTTPClient.RESPONSE_OK:
		var json = JSON.parse(body.get_string_from_utf8())
		var data = json.result
		var game_id = data["gameId"]
		if game_id != null:
			print("Created a game - Id: %s" % game_id)
			State.set_game_id(game_id)
			get_tree().change_scene("res://Scenes/room_game.tscn")
	else:
		print("Error creating game.")
	enable_input()

func enable_input():
	for child in get_children():
		if child is Button:
			child.disabled = false

func block_input():
	for child in get_children():
		if child is Button:
			child.disabled = true