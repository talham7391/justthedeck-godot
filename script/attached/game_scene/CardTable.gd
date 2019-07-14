extends RigidBody

var Card = preload("res://Scenes/objects/Card.tscn")

func _ready():
	connect("input_event", self, "on_input_event")
	Channel.connect("pending_player_put_cards_on_table", self, "on_pending_player_put_cards_on_table")

func on_pending_player_put_cards_on_table(playerName, cards):
	var root = get_tree().get_root()
	var scene = root.get_child(root.get_child_count() - 1)
	for card in cards:
		var card_instance = Card.instance()
		var rel_pos = Vector2(card.location.x, card.location.y)
		var card_pos = relative_to_card_table(rel_pos)
		card_instance.global_translate(Vector3(card_pos.x, 4, card_pos.y))
		scene.add_child(card_instance)

func on_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		var pos = card_table_to_relative(click_position)
		Channel.emit_signal("input_event_on_table", pos)

func relative_to_card_table(pos):
	var ref = $CollisionShape.global_transform.basis.get_scale()
	return Vector2(ref.x * pos.x, ref.z * pos.y)

func card_table_to_relative(click_position):
	var ref = $CollisionShape.global_transform.basis.get_scale()
	var play_x = click_position.x / ref.x
	var play_z = click_position.z / ref.z
	return Vector2(play_x, play_z)
	