class_name NoiseMap
extends Node2D

var main_seed : int
var max_elevation : int
var dominant_noise : NoiseGenerator
var river_noise : NoiseGenerator
var raw_height_map : Dictionary
var refined_height_map : Dictionary

func _init(_seed : int, _max_elevation : int) -> void:
	main_seed = _seed
	max_elevation = _max_elevation
	var rng := RandomNumberGenerator.new()
	rng.set_seed(main_seed)
	dominant_noise = NoiseGenerator.new(rng.randi(), 1.0, 8, 0.5, 2.0)
	river_noise = NoiseGenerator.new(rng.randi(), 1.0, 8, 0.5, 2.0)

func get_raw_height(x : int, y : int) -> float:
	var dom_noise : float = dominant_noise.GetNoise(x, y) * max_elevation
	
	return dom_noise
