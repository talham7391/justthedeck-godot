extends Node

var _type
var _value
var _suit
var _source
var _side
var _location

func _init(value, suit, type):
	_value = value
	_suit = suit
	_type = type

func get_type():
	return _type

func get_value():
	return _value

func get_suit():
	return _suit

func get_source():
	return _source

func set_source(source):
	_source = source
	return self

func get_side():
	return _side

func set_side(side):
	_side = side
	return self

func get_location():
	return _location

func set_location(location):
	_location = location
	return self

func same_card_as(card):
	if (
		get_suit() == card.get_suit() and
		get_type() == card.get_type() and
		get_value() == card.get_value()
	) :
		return true
	else:
		return false

func equals(card):
	if (
		get_suit() == card.get_suit() and
		get_type() == card.get_type() and
		get_value() == card.get_value() and
		get_location() == card.get_location() and
		get_side() == card.get_side() and
		get_source() == card.get_source()
	):
		return true
	else:
		return false

func copy(card):
	_suit = card.get_suit()
	_value = card.get_value()
	_type = card.get_type()
	set_location(card.get_location())
	set_side(card.get_side())
	set_source(card.get_source())
	return self

func get_json(add_table_info = false):
	var json = {
		"suit": get_suit(),
		"value": get_value(),
		"type": get_type()
	}
	if add_table_info:
		json["location"] = get_location()
		json["side"] = get_side()
	return json