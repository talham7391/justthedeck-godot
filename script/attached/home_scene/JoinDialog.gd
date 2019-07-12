extends PopupDialog

func _ready():
	$input_game_id.connect("text_changed", self, "on_game_id_changed")
	$button_try_join.connect("pressed", self, "try_join")
	$HTTPRequest.connect("request_completed", self, "on_request_completed")

func on_game_id_changed(new_game_id):
	State.set_game_id(new_game_id)

func try_join():
	var game_id = State.get_game_id()
	$HTTPRequest.request("http://localhost:8000/games/%s/state" % game_id)

func on_request_completed(result, response_code, headers, body):
	if response_code == HTTPClient.RESPONSE_OK:
		get_tree().change_scene("res://Scenes/room_game.tscn")
	else:
		print("Game not found.")
