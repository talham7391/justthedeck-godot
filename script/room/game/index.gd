extends Spatial

func init(game_id):
	$dialog_game_id_display/label_game_id.text = "Game ID: %s" % game_id
	$dialog_game_id_display.set_exclusive(true)
	$dialog_game_id_display.popup()
	
	var client_driver = load("res://script/client/driver.gd").new()
	add_child(client_driver)
	client_driver.call_deferred("init", game_id)
