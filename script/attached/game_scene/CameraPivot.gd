extends Spatial

var TOP_LIMIT = -35
var BOTTOM_LIMIT = -90

var mouse_pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	State.connect("players_updated", self, "on_players_updated")

func on_players_updated(players):
	var my_name = State.get_player_name()
	var join_order = null
	for player in players:
		if player["name"] == my_name:
			join_order = player["joinOrder"]
	
	sit_according_to(join_order)

func sit_according_to(join_order):
	var gap_size = 360 / len(State.get_players())
	rotation_degrees.y = gap_size * join_order * -1

func _input(event):
	return
	if event is InputEventMouseButton:
		mouse_pressed = event.pressed
	elif event is InputEventMouseMotion:
		if mouse_pressed:
			rotation_degrees.x -= event.relative.y
			if rotation_degrees.x > TOP_LIMIT:
				rotation_degrees.x = TOP_LIMIT
			elif rotation_degrees.x < BOTTOM_LIMIT:
				rotation_degrees.x = BOTTOM_LIMIT
			
