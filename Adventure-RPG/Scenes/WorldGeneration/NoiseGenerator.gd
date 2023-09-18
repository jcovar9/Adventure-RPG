extends Node2D

class NoiseGenerator:
	var seed : int
	var scale : float
	var octaves : int
	var persistance : float
	var lacunarity : float
	var rng : RandomNumberGenerator
	var octaveOffsets : Array[Vector2]
	var maxNoiseHeight : float
	var minNoiseHeight : float

	func _init(bounds, _seed, _scale, _octaves, _persistance, _lacunarity):
		seed = _seed
		scale = _scale
		octaves = _octaves
		persistance = _persistance
		lacunarity = _lacunarity
		rng = RandomNumberGenerator.new()
		rng.set_seed(seed)
		
		octaveOffsets = []
		for i in range(0,octaves):
			var offsetX : float = rng.randf_range(-100000, 100000)
			var offsetY : float = rng.randf_range(-100000, 100000)
			octaveOffsets[i] = Vector2(offsetX, offsetY)
		
		maxNoiseHeight = -1.79769e308
		minNoiseHeight = 1.79769e308
		

