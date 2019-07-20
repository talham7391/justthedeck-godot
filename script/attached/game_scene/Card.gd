extends Area

var _card
var _selected

func _ready():
	State.connect("clickable_entity_changed", self, "on_clickable_entity_changed")
	on_clickable_entity_changed(State.get_clickable_entity())

func fade_out():
	if _card.get_source() == Constants.SOURCES.TABLE:
		var t = Tween.new()
		add_child(t)
		t.interpolate_property(self, "translation:y", translation.y, translation.y - 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
		t.start()

func init(card):
	_card = card
	call_deferred("fade_out")

func get_selected():
	return _selected

func set_selected(selected):
	for child in get_children():
		child.translation.y = 2 if selected else 0
	_selected = selected
	
	if selected:
		State.select_card(_card)
	else:
		State.deselect_card(_card)

func toggle_selected():
	set_selected(!get_selected())

func on_clickable_entity_changed(entity):
	if entity == Constants.CLICKABLE_ENTITIES.CARD:
		set_collision_layer_bit(0, true)
		set_collision_mask_bit(0, true)
	else:
		set_collision_layer_bit(0, false)
		set_collision_mask_bit(0, false)

func externally_clicked(position):
	toggle_selected()