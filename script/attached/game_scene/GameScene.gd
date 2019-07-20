extends Spatial

func _ready():
	var game_id = State.get_game_id()
	$dialog_game_id_display/label_game_id.text = "Game ID: %s" % game_id
	$dialog_game_id_display.set_exclusive(true)
	$dialog_game_id_display.popup()
	
	Channel.connect("input_event_on_table", self, "on_input_event_on_table")
	
	Client.start()

var pressed_loc = null
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			pressed_loc = event.position
		elif pressed_loc != null and pressed_loc == event.position:
			cast_ray = event.position
	
	if event is InputEventKey and event.is_pressed() and event.scancode == KEY_SPACE:
		Actions.put_selected_cards_on_table({"x": 0.5, "y": 0.5}, Constants.SIDES.FACE_UP)

var cast_ray = null
func _physics_process(delta):
	if cast_ray != null:
		var from = $camera_pivot/camera.project_ray_origin(cast_ray)
		var to = from + $camera_pivot/camera.project_ray_normal(cast_ray) * 50
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(from, to, [], 0x7FFFFFFF, true, true)
		if "collider" in result:
			result.collider.externally_clicked(result.position)
		cast_ray = null

func on_input_event_on_table(pos):
	var num_idx = randi() % 13
	var suit_idx = randi() % 4
	var data = {
		"name": "PUT_CARDS_ON_TABLE",
		"data": {
			"cards": [{
				"type": "Normal",
				"suit": "%s" % CardFactory.normal_cards["suits"][suit_idx],
				"value": CardFactory.normal_cards["values"][num_idx],
				"side": "FACE_UP",
				"location": {
					"x": pos.x,
					"y": pos.y,
				}
			}]
		}
	}
	var err = Client.send_obj_to_server(data)

