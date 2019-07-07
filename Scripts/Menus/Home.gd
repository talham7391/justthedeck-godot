extends Control

func _ready():
	$button_create_game.connect("pressed", self, "on_create_game")
	$button_join_game.connect("pressed", self, "on_join_game")

func on_create_game():
	block_input()
	$HTTPRequest.connect("request_completed", self, "on_request_completed")
	$HTTPRequest.request("http://localhost:8000/test")

func on_request_completed(result, response_code, headers, body):
	print(body.get_string_from_utf8())
	enable_input()

func on_join_game():
	$dialog_join_game.popup()
	
func block_input():
	for child in get_children():
		if child is Button:
			child.disabled = true

func enable_input():
	for child in get_children():
		if child is Button:
			child.disabled = false