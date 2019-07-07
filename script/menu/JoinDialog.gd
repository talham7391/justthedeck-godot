extends PopupDialog
var utils = load("res://script/menu/utils.gd").new()

func _ready():
	$button_try_join.connect("pressed", self, "try_join")
	$HTTPRequest.connect("request_completed", self, "on_request_completed")

func try_join():
	var game_id = $input_game_id.text
	$HTTPRequest.request("http://localhost:8000/games/%s" % game_id)

func on_request_completed(result, response_code, headers, body):
	if response_code == HTTPClient.RESPONSE_OK:
		var json = JSON.parse(body.get_string_from_utf8())
		var data = json.result
		utils.join_game(get_tree().get_root(), data["gameId"])
	else:
		print("Game not found.")