extends Spatial

var _hand_loc = 0
func get_hand_loc():
	return _hand_loc

func set_hand_loc(hand_loc):
	var LIMIT = 16
	if -LIMIT < hand_loc and hand_loc < LIMIT:
		_hand_loc = hand_loc

var mouse_pressed = false

func _ready():
	Channel.connect("pending_put_cards_in_hand", self, "on_pending_put_cards_in_hand")
	Channel.connect("cards_in_hand", self, "on_cards_in_hand")

func on_pending_put_cards_in_hand(cards):
	add_cards_to_hand(cards)

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
	card_instance.scale = Vector3(2, 2, 2)
	add_child(card_instance)
	adjust_cards()

func remove_all_cards_in_hand():
	for card in get_children():
		remove_child(card)

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
