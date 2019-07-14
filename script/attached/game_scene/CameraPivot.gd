extends Spatial

var TOP_LIMIT = -35
var BOTTOM_LIMIT = -90

var mouse_pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton:
		mouse_pressed = event.pressed
	elif event is InputEventMouseMotion:
		if mouse_pressed:
			rotation_degrees.x -= event.relative.y
			if rotation_degrees.x > TOP_LIMIT:
				rotation_degrees.x = TOP_LIMIT
			elif rotation_degrees.x < BOTTOM_LIMIT:
				rotation_degrees.x = BOTTOM_LIMIT
			
