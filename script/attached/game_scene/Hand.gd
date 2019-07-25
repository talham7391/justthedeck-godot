extends Spatial

var _hand_loc = 0
func get_hand_loc():
	return _hand_loc

func set_hand_loc(hand_loc):
	_hand_loc = hand_loc
	return
	var LIMIT = 16
	if -LIMIT < hand_loc and hand_loc < LIMIT:
		_hand_loc = hand_loc

var mouse_pressed = false

func _ready():
	State.register_selector(self)
	
	Channel.connect("pending_put_cards_in_hand", self, "on_pending_put_cards_in_hand")
	Channel.connect("pending_remove_cards_from_hand", self, "on_pending_remove_cards_from_hand")
	Channel.connect("cards_in_hand", self, "on_cards_in_hand")

	Channel.connect("deselect_all_cards", self, "on_deselect_all_cards")

func get_cards_in_hand():
	return get_tree().get_nodes_in_group(Constants.GROUPS.CARDS_IN_HAND)

func get_selected_cards():
	var selected_cards = []
	for card in get_cards_in_hand():
		if card.get_selected():
			selected_cards.append(card.get_card())
	return selected_cards

func on_deselect_all_cards():
	for card in get_cards_in_hand():
		card.set_selected(false)

func on_pending_put_cards_in_hand(cards):
	add_cards_to_hand(cards)

func on_pending_remove_cards_from_hand(cards):
	remove_cards_from_hand(cards)

func on_cards_in_hand(cards):
	remove_all_cards_in_hand()
	add_cards_to_hand(cards)

func add_cards_to_hand(cards):
	for card in cards:
		add_card_to_hand(card)

func add_card_to_hand(card):
	card.set_source(Constants.SOURCES.HAND)
	var card_instance = CardFactory.instantiate(card)
	for child in card_instance.get_children():
		child.rotation_degrees.y = 90
	var card_scale = 1.8
	card_instance.scale = Vector3(card_scale, card_scale, card_scale)
	add_child(card_instance)
	card_instance.add_to_group(Constants.GROUPS.CARDS_IN_HAND)
	adjust_cards()

func remove_all_cards_in_hand():
	for card in get_children():
		card.free()

func remove_cards_from_hand(cards):
	for card in cards:
		for card_instance in get_children():
			if card_instance.get_card().same_card_as(card):
				card_instance.free()
				break
	adjust_cards()

func adjust_cards():
	var CARD_GAP = 5
	for i in range(get_child_count()):
		var card = get_child(i)
		card.translation.x = (i - get_child_count() / 2) * CARD_GAP + get_hand_loc()
		card.translation.y = -pow(card.translation.x, 2) / 100
		card.rotation_degrees.z = card.translation.x * -1
		card.translation.z = (i - get_child_count() / 2) * 0.2

func _input(event):
	if event is InputEventMouseButton:
		mouse_pressed = event.pressed
	elif event is InputEventMouseMotion:
		if mouse_pressed:
			set_hand_loc(get_hand_loc() + event.relative.x / 20)
			adjust_cards()
