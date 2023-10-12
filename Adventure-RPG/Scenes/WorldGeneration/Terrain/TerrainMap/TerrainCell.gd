class_name TerrainCell
extends RefCounted

var unfiltered_height : float
var filtered_height : int
var biome : String
var layers_used : Array[int]

func _init(_unfiltered_height : float, _biome : String) -> void:
	unfiltered_height = _unfiltered_height
	filtered_height = -1
	biome = _biome
	layers_used = []

func set_filtered_height(_filtered_height : int) -> void:
	filtered_height = _filtered_height

func set_biome(_biome : String) -> void:
	biome = _biome

func add_layer_used(layer : int) -> void:
	layers_used.append(layer)
