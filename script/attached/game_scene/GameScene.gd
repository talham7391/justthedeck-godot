extends Spatial

func _ready():
	var game_id = State.get_game_id()
	$dialog_game_id_display/label_game_id.text = "Game ID: %s" % game_id
	$dialog_game_id_display.set_exclusive(true)
	$dialog_game_id_display.popup()
	
	Client.start()
