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
