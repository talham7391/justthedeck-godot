extends Spatial

func _ready():
	Channel.connect("input_event_on_table", self, "on_input_event_on_table")
	Client.start()

var pressed_loc = null
func _input(event):
	if not State.get_select_allowed():
		return
	if event is InputEventMouseButton:
		if event.is_pressed():
			pressed_loc = event.position
		elif pressed_loc != null and pressed_loc == event.position:
			cast_ray = event.position

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
	Actions.put_selected_cards_on_table({"x": pos.x, "y": pos.y})

