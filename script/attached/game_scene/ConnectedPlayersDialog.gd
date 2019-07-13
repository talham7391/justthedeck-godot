extends PopupDialog

func _ready():
	popup_exclusive = true
	State.connect("players_updated", self, "on_players_updated")
	call_deferred("popup")

func on_players_updated(players):
	set_connected_players(players)

func set_connected_players(connected_players):
	var t = ""
	for p in connected_players:
		if p["connected"]:
			t += "%s - Connected\n" % p["name"]
		else:
			t += "%s - Disconnected\n" % p["name"]
	$label_connected_players.text = t