extends Spatial

func _ready():
	var game_id = State.get_game_id()
	$dialog_game_id_display/label_game_id.text = "Game ID: %s" % game_id
	$dialog_game_id_display.set_exclusive(true)
	$dialog_game_id_display.popup()
	
	Channel.connect("input_event_on_table", self, "on_input_event_on_table")
	
	Client.start()

func on_input_event_on_table(pos):
	var data = {
		"name": "PUT_CARDS_ON_TABLE",
		"data": {
			"cards": [{
				"type": "Normal",
				"suit": "Diamonds","number": 3,
				"side": "FACE_UP",
				"location": {
					"x": pos.x,
					"y": pos.y,
				}
			}]
		}
	}
	var err = Client.send_obj_to_server(data)
	print(err)
