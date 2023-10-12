extends Node2D

@onready var tileMap = $"../TileMap"

var terrain_assets : TerrainAssets
var terrain_map : TerrainMap
@export var seed : int = 0
@export var chunk_size : int = 16
@export var max_elevation : int = 10
@export var render_space_distance : int = 2
@export var tile_set : TileSet
var render_space_origin : Vector2i
var filter_space_distance : int
var filter_space_origin : Vector2i
var unfilter_space_distance : int
var unfilter_space_origin : Vector2i

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

############################################################
# INITIALIZATION
# initializes chunk that has an origin of 'vec'
func initialize_chunk(vec : Vector2i) -> void:
	for x in range(vec.x, vec.x + chunk_size):
		for y in range(vec.y, vec.y + chunk_size):
			terrain_map.add_terrain_cell(Vector2i(x,y))

############################################################
# FILTERING
# filters invalid terrain cell heights from chunk that has origin of 'vec'
func filter_chunk(vec : Vector2i) -> void:
	for x in range(vec.x, vec.x + chunk_size):
		for y in range(vec.y, vec.y + chunk_size):
			var vecs : Dictionary = terrain_map.get_3x3_vectors(Vector2i(x,y))
			filter_chunk_recurse(vecs)

# recursive helper function to filter invalid terrain cell heights out
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

############################################################
# RENDERING
# render the chunk that has an origin of 'vec'
func render_chunk(vec : Vector2i) -> void:
	for x in range(vec.x, vec.x + chunk_size):
		# iterate through the chunk from left to right
		var start_vec := Vector2i(x, vec.y + chunk_size - 1)
		render_chunk_line(start_vec)

# render the chunk line from bottom up starting at 'start_vec'
func render_chunk_line(start_vec : Vector2i):
	var vector_3x3 : Dictionary = terrain_map.get_3x3_vectors(start_vec)
	var terrain_cell_3x3 : Dictionary = terrain_map.get_3x3_terrain_cells(vector_3x3)
	render_terrain_cell(vector_3x3, terrain_cell_3x3)
	for y in range(0,chunk_size - 1):
		move_3x3s_up(vector_3x3, terrain_cell_3x3)
		render_terrain_cell(vector_3x3, terrain_cell_3x3)

# helper function to move the terrain_cell 3x3 up by one
func move_3x3s_up(vector_3x3 : Dictionary, terrain_cell_3x3 : Dictionary):
	move_vector3x3_up(vector_3x3)
	terrain_cell_3x3["SW"] = terrain_cell_3x3["W"]
	terrain_cell_3x3["S"] = terrain_cell_3x3["C"]
	terrain_cell_3x3["SE"] = terrain_cell_3x3["E"]
	terrain_cell_3x3["W"] = terrain_cell_3x3["NW"]
	terrain_cell_3x3["C"] = terrain_cell_3x3["N"]
	terrain_cell_3x3["E"] = terrain_cell_3x3["NE"]
	terrain_cell_3x3["NW"] = terrain_map.terrain_map[vector_3x3["NW"]]
	terrain_cell_3x3["N"] = terrain_map.terrain_map[vector_3x3["N"]]
	terrain_cell_3x3["NE"] = terrain_map.terrain_map[vector_3x3["NE"]]

# helper function to move the vector 3x3 up by one
func move_vector3x3_up(vector_3x3 : Dictionary) -> void:
	vector_3x3["SW"] = vector_3x3["W"]
	vector_3x3["S"] = vector_3x3["C"]
	vector_3x3["SE"] = vector_3x3["E"]
	vector_3x3["W"] = vector_3x3["NW"]
	vector_3x3["C"] = vector_3x3["N"]
	vector_3x3["E"] = vector_3x3["NE"]
	vector_3x3["NW"] = Vector2i(vector_3x3["W"], vector_3x3["W"] - 1)
	vector_3x3["N"] = Vector2i(vector_3x3["C"], vector_3x3["C"] - 1)
	vector_3x3["NE"] = Vector2i(vector_3x3["E"], vector_3x3["E"] - 1)

# renders all blocks of a specific terrain cell
func render_terrain_cell(vector_3x3 : Dictionary, terrain_cell_3x3 : Dictionary) -> void:
	# get lowest height neighbor
	# loop until at height of my_terrain_cell
		# get_pattern()
		# get_atlas_coords()
		# draw tile
	var start_height : int = get_lowest_nearby_height(terrain_cell_3x3)
	for curr_height in range(start_height, terrain_map.get_height(vector_3x3["C"])):
		pass
	pass

# helper function to return the lowest nearby height in the terrain_cell_3x3
func get_lowest_nearby_height(terrain_cell_3x3 : Dictionary) -> int:
	var lowest_height : int = terrain_cell_3x3["C"].filtered_height
	for key in terrain_cell_3x3:
		var curr_height : int = terrain_cell_3x3[key].filtered_height
		if(curr_height < lowest_height):
			lowest_height = curr_height
	return lowest_height

func get_pattern(terrain_cell_3x3 : Dictionary, block_height : int):
	pass

func get_block_type(terrain_cell : TerrainCell, block_height : int):
	pass

# renders the block of the terrain_cell at a specific height
func render_terrain_cell_block(terrain_cell : TerrainCell, block_height : int, surrounding_blocks : Dictionary) -> void:
	pass
