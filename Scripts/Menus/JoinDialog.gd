extends PopupDialog

func _ready():
	$button_try_join.connect("pressed", self, "try_join")

func try_join():
	var game_id = $input_game_id.text
	print("Trying to join game id: %s" % game_id)