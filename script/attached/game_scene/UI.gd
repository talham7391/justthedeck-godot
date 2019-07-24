extends Control

var _playing_cards = false

func _ready():
	Channel.connect("cards_played", self, "on_cards_played")
	
	var game_id = State.get_game_id()
	$game_id_container/label_game_id.text = "Game ID: %s" % game_id
	
	$deselect_cards_button.connect("button_up", self, "on_deselect_cards_button_click")

	$play_cards_on_table_button.connect("button_up", self, "on_play_cards_on_table_button_click")
	$play_cards_on_table_dialog.connect("popup_hide", self, "on_dialog_hide")
	$play_cards_on_table_dialog/face_up_button.connect("button_up", self, "on_play_cards_face_up")
	$play_cards_on_table_dialog/face_down_button.connect("button_up", self, "on_play_cards_face_down")
	
	$put_cards_in_hand_button.connect("button_up", self, "on_put_cards_in_hand_button_click")
	
	$select_cards_on_table_button.connect("button_up", self, "on_select_cards_on_table_button_click")
	$select_cards_on_table_dialog.connect("popup_hide", self, "on_dialog_hide")
	$select_cards_on_table_dialog/face_up_button.connect("button_up", self, "on_select_face_up")
	$select_cards_on_table_dialog/face_down_button.connect("button_up", self, "on_select_face_down")
	$select_cards_on_table_dialog/both_button.connect("button_up", self, "on_select_both")
	
	on_deselect_cards_button_click()

func on_select_cards_on_table_button_click():
	$select_cards_on_table_dialog.popup()
	State.set_select_allowed(false)

func on_deselect_cards_button_click():
	Channel.emit_signal("deselect_all_cards")

func on_play_cards_on_table_button_click():
	if _playing_cards:
		stop_played_cards()
	else:
		$play_cards_on_table_dialog.popup()
		State.set_select_allowed(false)

func on_put_cards_in_hand_button_click():
	Actions.put_selected_cards_in_hand()

func on_play_cards_face_up():
	allow_play_cards(Constants.SIDES.FACE_UP)

func on_play_cards_face_down():
	allow_play_cards(Constants.SIDES.FACE_DOWN)

func allow_play_cards(side):
	_playing_cards = true
	$deselect_cards_button.disabled = true
	$select_cards_on_table_button.disabled = true
	$play_cards_on_table_button.text = "Cancel"
	State.set_play_cards_side(side)
	State.set_clickable_entity(Constants.CLICKABLE_ENTITIES.TABLE)
	$play_cards_on_table_dialog.hide()

func stop_played_cards():
	_playing_cards = false
	$deselect_cards_button.disabled = false
	$select_cards_on_table_button.disabled = false
	$play_cards_on_table_button.text = "Play Selected Card on Table"
	State.set_play_cards_side(null)
	State.set_clickable_entity(Constants.CLICKABLE_ENTITIES.CARD)

func on_cards_played(cards):
	stop_played_cards()

func on_select_face_up():
	$select_cards_on_table_dialog.hide()
	Channel.emit_signal("select_cards_on_table", Constants.SIDES.FACE_UP)

func on_select_face_down():
	$select_cards_on_table_dialog.hide()
	Channel.emit_signal("select_cards_on_table", Constants.SIDES.FACE_DOWN)

func on_select_both():
	$select_cards_on_table_dialog.hide()
	on_select_face_up()
	on_select_face_down()

func on_dialog_hide():
	State.set_select_allowed(true)