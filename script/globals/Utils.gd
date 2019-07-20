extends Node

var CardData = preload("res://script/locals/CardData.gd")

func clone_card(card):
	var cd = CardData.new(null, null, null)
	return cd.copy(card)

func clone_with_location_and_side(cards, location, side):
	var new_cards = []
	for card in cards:
		new_cards.append(clone_card(card).set_location(location).set_side(side))
	return new_cards

func jsonToCard(json):
	var cd = CardData.new(json["value"], json["suit"], json["type"])
	if "location" in json:
		cd.set_location(json["location"])
	if "side" in json:
		cd.set_side(json["side"])
	return cd

func jsonToCards(json):
	var cards = []
	for card in json:
		cards.append(jsonToCard(card))
	return cards

func cardsToJson(cards, add_table_info = false):
	var json_cards = []
	for card in cards:
		json_cards.append(card.get_json(add_table_info))
	return json_cards