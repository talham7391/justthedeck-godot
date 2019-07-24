extends Area

var _card
var _selected

func _ready():
	State.connect("clickable_entity_changed", self, "on_clickable_entity_changed")
	Channel.connect("select_cards_on_table", self, "on_select_cards_on_table")
	Channel.connect("deselect_all_cards", self, "on_deselect_all_cards")
	on_clickable_entity_changed(State.get_clickable_entity())

func init(card):
	_card = card

func _exit_tree():
	set_selected(false)

func get_card():
	return _card

func get_selected():
	return _selected

func set_selected(selected):
	for child in get_children():
		child.translation.y = 2 if selected else 0
		
		if child is MeshInstance:
			var material = child.get_surface_material(0)
			if material is SpatialMaterial:
				material.albedo_color = Color.blue if selected else Color.white
	_selected = selected
	
	if selected:
		State.select_card(_card)
	else:
		State.deselect_card(_card)

func toggle_selected():
	set_selected(!get_selected())

func on_select_cards_on_table(side):
	if (
		_card.get_source() == Constants.SOURCES.TABLE and
		_card.get_side() == side
	):
		set_selected(true)

func on_deselect_all_cards():
	set_selected(false)

func on_clickable_entity_changed(entity):
	if entity == Constants.CLICKABLE_ENTITIES.CARD:
		set_collision_layer_bit(0, true)
		set_collision_mask_bit(0, true)
	else:
		set_collision_layer_bit(0, false)
		set_collision_mask_bit(0, false)

func externally_clicked(position):
	toggle_selected()