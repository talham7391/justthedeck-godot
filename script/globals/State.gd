extends Node


# PLAYER NAME
var _player_name = Defaults.default_player_name

func set_player_name(player_name):
  _player_name = player_name

func get_player_name():
  return _player_name


# GAME ID
var _game_id = Defaults.default_game_id

func set_game_id(game_id):
  _game_id = game_id

func get_game_id():
  return _game_id


# PLAYER STATES
var _players = null

signal players_updated
  
func set_players(players):
  _players = players
  emit_signal("players_updated", _players)

func get_players():
  return _players


# CLICKABLE ENTITY

var _clickable_entity = Constants.CLICKABLE_ENTITIES.CARD

signal clickable_entity_changed

func set_clickable_entity(entity):
	_clickable_entity = entity
	emit_signal("clickable_entity_changed", _clickable_entity)

func get_clickable_entity():
	return _clickable_entity


# SELECT ALLOWED

var _select_allowed = true

signal select_allowed_changed

func get_select_allowed():
	return _select_allowed

func set_select_allowed(select_allowed):
	_select_allowed = select_allowed
	emit_signal("select_allowed_changed", _select_allowed)


# SELECTED CARDS

var _selected_cards = []

signal selected_cards_changed

func get_selected_cards():
	return _selected_cards

func select_card(card):
	_selected_cards.append(card)
	emit_signal("selected_cards_changed", _selected_cards)

func deselect_card(card):
	for i in range(len(_selected_cards)):
		if card.equals(_selected_cards[i]):
			_selected_cards.remove(i)
			break
	emit_signal("selected_cards_changed", _selected_cards)


# PLAY CARDS SIDE

var _play_cards_side = null

signal play_cards_side_changed

func get_play_cards_side():
	return _play_cards_side

func set_play_cards_side(play_cards_side):
	_play_cards_side = play_cards_side
	emit_signal("play_cards_side_changed", _play_cards_side)
