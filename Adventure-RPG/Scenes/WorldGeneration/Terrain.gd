extends Node2D

@onready var tileMap = $"../TileMap"

var terrain_assets : TerrainAssets
var terrain_map : TerrainMap
var chunk_size : int = 16
var render_space_distance : int = 2
var render_space_origin : Vector2i
var filter_space_distance : int
var filter_space_origin : Vector2i
var unfilter_space_distance : int
var unfilter_space_origin : Vector2i
var seed : int = 0
var max_elevation : int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	render_space_origin = Vector2i(render_space_distance * chunk_size * -1, render_space_distance * chunk_size * -1)
	filter_space_distance = render_space_distance + 1
	filter_space_origin = Vector2i(filter_space_distance * chunk_size * -1, filter_space_distance * chunk_size * -1)
	unfilter_space_distance = render_space_distance + 2
	unfilter_space_origin = Vector2i(unfilter_space_distance * chunk_size * -1, unfilter_space_distance * chunk_size * -1)
	
	terrain_assets = TerrainAssets.new(tileMap)
	terrain_map = TerrainMap.new(seed, max_elevation)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func initialize_chunk(vec : Vector2i) -> void:
	for x in range(vec.x, vec.x + chunk_size):
		for y in range(vec.y, vec.y + chunk_size):
			terrain_map.add_terrain_cell(Vector2i(x,y))


# recursively filters invalid terrain cell heights out
func filter_chunk_recurse(vecs : Dictionary) -> void:
	var heights : Dictionary = terrain_map.get_3x3_heights(vecs)
	if(terrain_map.filter_terrain_cell_height(vecs["C"], heights)):
		# a change to height was made so recurse through the nearby vectors
		vecs.erase("C")
		for vec in vecs:
			if(filter_space_origin.x <= vec.x && vec.x < filter_space_origin.x + chunk_size * filter_space_distance * 2 &&
			 filter_space_origin.y <= vec.y && vec.y < filter_space_origin.y + chunk_size * filter_space_distance * 2):
				# this vec is within the filter_space
				filter_chunk_recurse(terrain_map.get_3x3_vectors(vec))

# filters invalid terrain cell heights in the chunk
func filter_chunk(vec : Vector2i) -> void:
	for x in range(vec.x, vec.x + chunk_size):
		for y in range(vec.y, vec.y + chunk_size):
			var vecs : Dictionary = terrain_map.get_3x3_vectors(Vector2i(x,y))
			filter_chunk_recurse(vecs)


# renders the block of the terrain_cell at a specific height
func render_terrain_cell_block(terrain_cell : TerrainCell, height : int, surrounding_blocks : Dictionary) -> void:
	pass

# renders all blocks of a specific terrain cell
func render_terrain_cell(terrain_cells : Dictionary) -> void:
	pass

func render_chunk(vec : Vector2i) -> void:
	pass
