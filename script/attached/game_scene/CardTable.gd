extends Area

func _ready():
	State.connect("clickable_entity_changed", self, "on_clickable_entity_changed")
	Channel.connect("pending_put_cards_on_table", self, "on_pending_put_cards_on_table")

func remove_current_cards():
	var cards = get_tree().get_nodes_in_group("cards")
	for card in cards:
		card.free()

func on_pending_put_cards_on_table(cards):
	remove_current_cards()
	var players = State.get_players()
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
			child.rotation_degrees.z = 90 if card.get_side() == Constants.SIDES.FACE_DOWN else -90
		
		var player_join_order = null
		var played_by = null
		if card.get_played_by() == null:
			played_by = State.get_player_name()
		else:
			played_by = card.get_played_by()
		for player in players:
			if player["name"] == played_by:
				player_join_order = player["joinOrder"]
		card_instance.rotation_degrees.y = get_card_instance_rotation(player_join_order)
		scene.add_child(card_instance)
		card_instance.add_to_group("cards")

func on_clickable_entity_changed(entity):
	if entity == Constants.CLICKABLE_ENTITIES.TABLE:
		set_collision_layer_bit(0, true)
		set_collision_mask_bit(0, true)
	else:
		set_collision_layer_bit(0, false)
		set_collision_mask_bit(0, false)

func externally_clicked(click_position):
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
	