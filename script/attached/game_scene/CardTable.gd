extends Area

func _ready():
	connect("input_event", self, "on_input_event")
	Channel.connect("pending_player_put_cards_on_table", self, "on_pending_player_put_cards_on_table")

func on_pending_player_put_cards_on_table(player_name, cards):
	var player_join_order = null
	var players = State.get_players()
	for player in players:
		if player["name"] == player_name:
			player_join_order = player["joinOrder"]
			break
	
	if player_join_order == null:
		print("Error! Player join order not found.")
		return
	
	var root = get_tree().get_root()
	var scene = root.get_child(root.get_child_count() - 1)
	for card in cards:
		card.set_source(Constants.SOURCES.TABLE)
		var card_instance = CardFactory.instantiate(card)
		var rel_pos = Vector2(card.get_location().x, card.get_location().y)
		var card_pos = relative_to_card_table(rel_pos)
		card_instance.global_translate(Vector3(card_pos.x, 0.2, card_pos.y))
		for child in card_instance.get_children():
			child.rotation_degrees.y = 90
			child.rotation_degrees.z = -90
		card_instance.rotation_degrees.y = get_card_instance_rotation(player_join_order)
		scene.add_child(card_instance)

func on_input_event(camera, event, click_position, click_normal, shape_idx):
	return
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

func get_card_instance_rotation(player_join_order):
	var players = State.get_players()	
	var gap_size = 360 / len(players)
	return player_join_order * gap_size * -1
	