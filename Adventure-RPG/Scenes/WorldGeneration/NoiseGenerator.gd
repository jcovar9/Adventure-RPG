class_name NoiseGenerator

var noiseSeed : int
var noiseScale : float
var octaves : int
var persistance : float
var lacunarity : float
var rng : RandomNumberGenerator
var octaveOffsets : Array[Vector2]
var maxNoiseHeight : float
var minNoiseHeight : float
var fastNoise : FastNoiseLite

func _init(_se:int, _sc:float, _o:int, _p:float, _l:float, bounds:Array[int]) -> void:
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
	
	maxNoiseHeight = -1.79769e308
	minNoiseHeight = 1.79769e308
	
	fastNoise = FastNoiseLite.new()
	fastNoise.set_seed(noiseSeed)
	
	for x in range(bounds[0], bounds[1]):
		for y in range(bounds[2], bounds[3]):
			var noiseValue : float = GetNoiseValue(x, y)
			UpdateNoiseHeightBounds(noiseValue)

func GetNoiseValue(x : int, y : int) -> float:
	var amplitude : float         = 1.0
	var frequency : float         = 1.0
	var totalNoiseValue : float   = 0.0
	
	for i in range(0, octaves):
		var sampleX : float    = x / noiseScale * frequency + octaveOffsets[i].x
		var sampleY : float    = y / noiseScale * frequency + octaveOffsets[i].y
		
		var noiseValue : float = fastNoise.get_noise_2d(sampleX, sampleY) * 2 - 1
		
		totalNoiseValue += noiseValue * amplitude
		amplitude       *= persistance
		frequency       *= lacunarity
	
	return totalNoiseValue

func UpdateNoiseHeightBounds(noiseValue : float) -> void:
	if noiseValue > maxNoiseHeight:
		maxNoiseHeight = noiseValue
	elif noiseValue < minNoiseHeight:
		minNoiseHeight = noiseValue

func GetNoise(x : int, y : int) -> float:
	var noise : float = GetNoiseValue(x, y)
	UpdateNoiseHeightBounds(noise)
	return inverse_lerp(minNoiseHeight, maxNoiseHeight, noise)
