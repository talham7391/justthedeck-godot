extends Node

var CardScene = preload("res://Scenes/objects/Card.tscn")

var normal_card_textures = {}
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
			var tex_name = "%s_%s" % [val, suit]
			normal_card_textures[tex_name] = load("res://assets/cards/textures/%s.png" % tex_name)

func instantiate(tex_name):
	var card_instance = CardScene.instance()
	for child in card_instance.get_children():
		if child is MeshInstance:
			var material = SpatialMaterial.new()
			material.flags_unshaded = true
			material.albedo_texture = normal_card_textures[tex_name]
			child.set_surface_material(0, material)
	return card_instance
