extends Node

# PLAYER NAME
var _player_name = null

func set_player_name(player_name):
  _player_name = player_name

func get_player_name():
  return _player_name


# GAME ID
var _game_id = null

func set_game_id(game_id):
  _game_id = game_id

func get_game_id():
  return _game_id


# PLAYER STATES
var _player_states = null

signal player_states_updated
  
func set_player_states(player_states):
  _player_states = player_states
  emit_signal("player_states_updated", _player_states)

func get_player_states():
  return _player_states