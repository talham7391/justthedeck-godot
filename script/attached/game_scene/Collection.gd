extends Spatial

func _ready():
	State.register_selector(self)
	Channel.connect("cards_in_collection", self, "on_cards_in_collection")
	Channel.connect("deselect_all_cards", self, "on_deselect_all_cards")

func on_deselect_all_cards():
	for card in get_cards_in_collection():
		card.set_selected(false)

func on_cards_in_collection(cards):
	remove_cards_from_collection()
	add_cards_to_collection(cards)

func get_cards_in_collection():
	return get_tree().get_nodes_in_group(Constants.GROUPS.CARDS_IN_COLLECTION)

func remove_cards_from_collection():
	for card in get_cards_in_collection():
		card.free()

func add_cards_to_collection(cards):
	for card in cards:
		card.set_source(Constants.SOURCES.COLLECTION)
		var card_instance = CardFactory.instantiate(card)
		for child in card_instance.get_children():
			child.rotation_degrees.y = -90
		var card_scale = 1
		card_instance.scale = Vector3(card_scale, card_scale, card_scale)
		add_child(card_instance)
		card_instance.add_to_group(Constants.GROUPS.CARDS_IN_COLLECTION)
		adjust_cards()

func get_selected_cards():
	var selected_cards = []
	for card in get_cards_in_collection():
		if card.get_selected():
			selected_cards.append(card.get_card())
	return selected_cards

func adjust_cards():
	var cards = get_cards_in_collection()
	for i in range(len(cards)):
		cards[i].translation.y = i * -7