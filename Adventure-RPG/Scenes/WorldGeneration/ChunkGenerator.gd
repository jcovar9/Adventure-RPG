extends Node2D

@onready var tileMap = $"../TileMap"

var terrainAssets : TerrainAssets
var noiseGenerator : NoiseGenerator
var chunk : Chunk

# Called when the node enters the scene tree for the first time.
func _ready():
	terrainAssets = TerrainAssets.new(tileMap)
	noiseGenerator = NoiseGenerator.new(0, 1.0, 8, .5, 2.0, [0,16,0,16])
	chunk = Chunk.new(Vector2i.ZERO, 16, 2, noiseGenerator, terrainAssets)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


