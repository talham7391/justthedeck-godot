extends Node

func put_selected_cards_on_table(location, remove_cards_from_source = true):
	var orig_cards = State.get_selected_cards()
	if len(orig_cards) == 0:
		return
	
	var cards = Utils.clone_cards(orig_cards)
	
	if remove_cards_from_source:
		_remove_cards_from_source(cards)
	
	for card in cards:
		card.set_played_by(State.get_player_name())
	
	var cards_on_table = Utils.clone_with_location_and_side(cards, location, State.get_play_cards_side())
	var action = {
		"name": "PUT_CARDS_ON_TABLE",
		"data": {
			"cards": Utils.cardsToJson(cards_on_table, true)
		}
	}
	Client.send_obj_to_server(action)
	
	Channel.emit_signal("cards_played", cards)

func put_selected_cards_in_collection():
	var orig_cards = State.get_selected_cards()
	if len(orig_cards) == 0:
		return
	
	var cards = Utils.clone_cards(orig_cards)
	_remove_cards_from_source(cards)
	
	var action = {
		"name": "ADD_CARDS_TO_COLLECTION",
		"data": {
			"cards": Utils.cardsToJson(cards)
		}
	}
	Client.send_obj_to_server(action)

func put_selected_cards_in_hand():
	var orig_cards = State.get_selected_cards()
	if len(orig_cards) == 0:
		return
	
	var cards = Utils.clone_cards(orig_cards)
	_remove_cards_from_source(cards)
	
	var action = {
		"name": "ADD_CARDS_TO_HAND",
		"data": {
			"cards": Utils.cardsToJson(cards)
		}
	}
	Client.send_obj_to_server(action)

func distribute_selected_cards():
	var orig_cards = State.get_selected_cards()
	if len(orig_cards) == 0:
		return
	
	var cards = Utils.clone_cards(orig_cards)
	_remove_cards_from_source(cards)
	
	var action = {
		"name": "DISTRIBUTE_CARDS",
		"data": {
			"cards": Utils.cardsToJson(cards)
		}
	}
	Client.send_obj_to_server(action)

func _remove_cards_from_source(cards):
	for source in Constants.SOURCES:
		var cards_to_remove = Utils.filter_cards_by_source(cards, Constants.SOURCES[source])
		if len(cards_to_remove) == 0:
			continue
		
		var include_table_info = true if Constants.SOURCES[source] == Constants.SOURCES.TABLE else false
		var remove_action = {
			"name": "REMOVE_CARDS_FROM_%s" % Constants.SOURCES[source].to_upper(),
			"data": {
				"cards": Utils.cardsToJson(cards_to_remove, include_table_info)
			}
		}
		Client.send_obj_to_server(remove_action)