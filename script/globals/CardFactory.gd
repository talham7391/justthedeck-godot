extends Node

var CardScene = preload("res://Scenes/objects/Card.tscn")

var card_textures = {}

var normal_cards = {
	"values": [
		"ace",
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
		10,
		"jack",
		"queen",
		"king"
	],
	"suits": [
		"hearts",
		"clubs",
		"diamonds",
		"spades"
	]
}

func _ready():
	load_textures()

func load_textures():
	for val in normal_cards["values"]:
		for suit in normal_cards["suits"]:
			var tex_name = "normal_%s_%s" % [val, suit]
			card_textures[tex_name] = load("res://assets/cards/textures/%s.png" % tex_name)

func instantiate(card):
	var card_instance = CardScene.instance()
	card_instance.init(card)
	for child in card_instance.get_children():
		if child is MeshInstance:
			var material = SpatialMaterial.new()
			material.flags_unshaded = true
			var tex_name = "%s_%s_%s" % [card.get_type(), card.get_value(), card.get_suit()]
			material.albedo_texture = card_textures[tex_name]
			child.set_surface_material(0, material)
	return card_instance
