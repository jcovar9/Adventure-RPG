class_name NoiseGenerator
extends Node2D

var noiseSeed : int
var noiseScale : float
var octaves : int
var persistance : float
var lacunarity : float
var rng : RandomNumberGenerator
var octaveOffsets : Array[Vector2]
var max_noise_value : float
var min_noise_value : float
var fastNoise : FastNoiseLite

func _init(_se:int, _sc:float, _o:int, _p:float, _l:float) -> void:
	if (_sc <= 0):
		_sc = 0.0001
	noiseSeed = _se
	noiseScale = _sc
	octaves = _o
	persistance = _p
	lacunarity = _l
	rng = RandomNumberGenerator.new()
	rng.set_seed(noiseSeed)
	
	octaveOffsets = []
	for i in range(0,octaves):
		var offsetX : float = rng.randf_range(-100000, 100000)
		var offsetY : float = rng.randf_range(-100000, 100000)
		octaveOffsets.append(Vector2(offsetX, offsetY))
	
	SetNoiseBounds()
	
	fastNoise = FastNoiseLite.new()
	fastNoise.set_seed(noiseSeed)

func SetNoiseBounds() -> void:
	var amplitude : float = 1.0
	var total_noise_value : float = 0.0
	for i in range(0, octaves):
		var noiseValue : float = -1.0 * 2 - 1
		total_noise_value += noiseValue * amplitude
		amplitude *= persistance
	min_noise_value = total_noise_value
	
	amplitude = 1.0
	total_noise_value = 0.0
	for i in range(0, octaves):
		var noiseValue : float = 1.0 * 2 - 1
		total_noise_value += noiseValue * amplitude
		amplitude *= persistance
	max_noise_value = total_noise_value


func GetNoise(x : int, y : int) -> float:
	var amplitude : float         = max_noise_value / 2
	var frequency : float         = .05
	var total_noise_value : float = 0.0
	
	for i in range(0, octaves):
		var sampleX : float = x / noiseScale * frequency + octaveOffsets[i].x
		var sampleY : float = y / noiseScale * frequency + octaveOffsets[i].y
		
		var noiseValue : float = fastNoise.get_noise_2d(sampleX, sampleY) * 2 - 1
		
		total_noise_value += noiseValue * amplitude
		amplitude         *= persistance
		frequency         *= lacunarity
	
	return inverse_lerp(min_noise_value, max_noise_value, total_noise_value)
