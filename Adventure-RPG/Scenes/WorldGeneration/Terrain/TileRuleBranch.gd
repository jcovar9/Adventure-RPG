class_name TileRuleBranch
extends RefCounted

var atlas_vectors : Array[Vector2i]
var any_node : TileRuleBranch
var dirt_node : TileRuleBranch
var air_node : TileRuleBranch
var water_node : TileRuleBranch

func _init():
	atlas_vectors = []
	any_node = null
	dirt_node = null
	air_node = null
	water_node = null

func set_atlas_vector(vectors : Array[Vector2i]) -> void:
	atlas_vectors = vectors

func get_atlas_vectors() -> Array[Vector2i]:
	return atlas_vectors

func set_child_node(node_type : String, node : TileRuleBranch) -> void:
	match node_type:
		"_":
			any_node = node
		"d":
			dirt_node = node
		"a":
			air_node = node
		"w":
			water_node = node
		_:
			print("set_chld_node() Error: unknown node_type: " + node_type)

func get_child_node(node_type : String) -> TileRuleBranch:
	match node_type:
		"_":
			return any_node
		"d":
			return dirt_node
		"a":
			return air_node
		"w":
			return water_node
		_:
			print("get_child_node() Error: unknown node_type: " + node_type)
			return null
