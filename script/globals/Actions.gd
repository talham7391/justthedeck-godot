extends Node

func put_selected_cards_on_table(location, side, remove_cards_from_source = true):
	var cards = State.get_selected_cards()
	if len(cards) == 0:
		return
	
	var cards_on_table = Utils.clone_with_location_and_side(cards, location, side)

	var action = {
		"name": "PUT_CARDS_ON_TABLE",
		"data": {
			"cards": Utils.cardsToJson(cards_on_table, true)
		}
	}
	Client.send_obj_to_server(action)
	
	if remove_cards_from_source:
		for source in Constants.SOURCES:
			var cards_to_remove = Utils.filter_cards_by_source(cards, Constants.SOURCES[source])
			if len(cards_to_remove) == 0:
				continue
			var remove_action = {
				"name": "REMOVE_CARDS_FROM_%s" % Constants.SOURCES[source].to_upper(),
				"data": {
					"cards": Utils.cardsToJson(cards_to_remove)
				}
			}
			Client.send_obj_to_server(remove_action)