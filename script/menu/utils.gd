extends Node

func join_game(root, game_id, player_name):
	var curr_scene = root.get_child(root.get_child_count() - 1)
	root.remove_child(curr_scene)
	curr_scene.call_deferred("free")
	
	var room_game_resource = load("res://Scenes/room_game.tscn")
	var room_game = room_game_resource.instance()
	root.add_child(room_game)
	room_game.call_deferred("init", game_id, player_name)