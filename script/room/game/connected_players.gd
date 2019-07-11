extends PopupDialog

func _ready():
	popup_exclusive = true
	call_deferred("popup")

func init(driver):
	driver.connect("player_states", self, "on_player_states")

func set_connected_players(connected_players):
	print("this ran")
	var t = ""
	for p in connected_players:
		if p["connected"]:
			t += "%s\n" % p["name"]
	$label_connected_players.text = t

func on_player_states(player_states):
	set_connected_players(player_states)