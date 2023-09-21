extends Node2D

@onready var tileMap = $"../TileMap"

var terrainAssets : TerrainAssets
var noiseGenerator : NoiseGenerator
var chunk : Chunk

# Called when the node enters the scene tree for the first time.
func _ready():
	terrainAssets = TerrainAssets.new(tileMap)
	noiseGenerator = NoiseGenerator.new(1, 200.0, 8, .5, 2.0, [-16,16,-16,16])
	chunk = Chunk.new(Vector2i(0 , 0 ), 16, 10, noiseGenerator, terrainAssets)
	chunk = Chunk.new(Vector2i(0 , 16), 16, 10, noiseGenerator, terrainAssets)
	chunk = Chunk.new(Vector2i(16,  0), 16, 10, noiseGenerator, terrainAssets)
	chunk = Chunk.new(Vector2i(16, 16), 16, 10, noiseGenerator, terrainAssets)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


