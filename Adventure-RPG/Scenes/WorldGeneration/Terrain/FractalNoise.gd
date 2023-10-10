class_name FractalNoise
extends RefCounted

var my_seed : int
var my_scale : float
var my_octaves : int
var my_persistence : float
var my_lacunarity : float
var my_octave_offsets : Array[Vector2]
var my_max : float
var my_min : float
var my_fast_noise : FastNoiseLite

func _init(_seed:int, _scale:float, _octaves:int, _persistence:float, _lacunarity:float) -> void:
	if (_scale <= 0):
		_scale = 0.0001
	my_seed = _seed
	my_scale = _scale
	my_octaves = _octaves
	my_persistence = _persistence
	my_lacunarity = _lacunarity
	SetOctaveOffsets()
	SetNoiseBounds()
	my_fast_noise = FastNoiseLite.new()
	my_fast_noise.set_seed(my_seed)

func SetOctaveOffsets() -> void:
	var rng := RandomNumberGenerator.new()
	rng.set_seed(my_seed)
	my_octave_offsets = []
	for i in range(0, my_octaves):
		var offsetX : float = rng.randf_range(-100000, 100000)
		var offsetY : float = rng.randf_range(-100000, 100000)
		my_octave_offsets.append(Vector2(offsetX, offsetY))

func SetNoiseBounds() -> void:
	var amplitude : float = 1.0
	var min_elevation : float = 0.0
	var max_elevation : float = 0.0
	for i in range(0, my_octaves):
		my_min += -1.0 * amplitude
		my_max +=  1.0 * amplitude
		amplitude *= my_persistence

func GetNoise(x : int, y : int) -> float:
	var amplitude : float = 1.0
	var frequency : float = .05
	var elevation : float = 0.0
	
	for i in range(0, my_octaves):
		var sampleX : float = x / my_scale * frequency + my_octave_offsets[i].x
		var sampleY : float = y / my_scale * frequency + my_octave_offsets[i].y
		var noiseValue : float = my_fast_noise.get_noise_2d(sampleX, sampleY)
		
		elevation += noiseValue * amplitude
		amplitude *= my_persistence
		frequency *= my_lacunarity
	
	return clamp(inverse_lerp(my_min, my_max, elevation), 0.0, 1.0)
