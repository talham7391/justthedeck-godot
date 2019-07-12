extends PopupDialog

func _ready():
	popup_exclusive = true
	State.connect("player_states_updated", self, "on_player_states_updated")
	call_deferred("popup")

func on_player_states_updated(player_states):
	set_connected_players(player_states)

func set_connected_players(connected_players):
	var t = ""
	for p in connected_players:
		if p["connected"]:
			t += "%s\n" % p["name"]
	$label_connected_players.text = t