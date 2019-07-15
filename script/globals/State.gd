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