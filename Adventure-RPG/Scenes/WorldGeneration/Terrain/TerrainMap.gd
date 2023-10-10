class_name TerrainMap
extends RefCounted

var lake_land_ratio := 0.1
var river_land_ratio := 0.05

var main_seed : int
var max_elevation : int
var land_noise : FractalNoise
var river_noise : FractalNoise
var terrain_map : Dictionary

func _init(_seed : int, _max_elevation : int) -> void:
	main_seed = _seed
	max_elevation = _max_elevation
	var rng := RandomNumberGenerator.new()
	rng.set_seed(main_seed)
	land_noise = FractalNoise.new(rng.randi(), 1.0, 8, 0.5, 2.0)
	river_noise = FractalNoise.new(rng.randi(), 1.0, 8, 0.5, 2.0)
	terrain_map = {}

# add a terrain_cell to terrain_map
func add_terrain_cell(vec : Vector2i) -> void:
	var raw_land_noise : float = land_noise.GetNoise(vec.x, vec.y)
	var raw_river_noise : float = absf(river_noise.GetNoise(vec.x, vec.y) * 2 - 1)
	var height_from_lake : float = lerpf(-lake_land_ratio / 2.0, 0.5, raw_land_noise)
	var height_from_river : float = lerpf(-river_land_ratio / 2.0, 0.5, raw_river_noise)
	if height_from_lake <= 0 :
		# we must be in a lake
		terrain_map[vec] = TerrainCell.new(0.0, "water")
	elif height_from_river <= 0:
		# we must be in a river
		terrain_map[vec] = TerrainCell.new(height_from_lake * max_elevation, "water")
	else:
		# we must be on land
		terrain_map[vec] = TerrainCell.new((height_from_lake + height_from_river) * max_elevation, "land")

# returns a 3x3 of vectors centered on vec
func get_3x3_vectors(vec : Vector2i) -> Dictionary:
	return {"NW" : Vector2i(vec.x - 1, vec.y - 1),
			"N" : Vector2i(vec.x, vec.y - 1),
			"NE" : Vector2i(vec.x + 1, vec.y - 1),
			"W" : Vector2i(vec.x - 1, vec.y),
			"C" : vec,
			"E" : Vector2i(vec.x + 1, vec.y),
			"SW" : Vector2i(vec.x - 1, vec.y + 1),
			"S" : Vector2i(vec.x, vec.y + 1),
			"SE" : Vector2i(vec.x + 1, vec.y + 1)}

# gets the filtered_height if it is set, else gets the unfiltered_height
func get_height(vec : Vector2i) -> int:
	var terrain_cell : TerrainCell = terrain_map[vec]
	if(terrain_cell.filtered_height != -1):
		return terrain_cell.filtered_height
	else:
		return int(terrain_cell.unfiltered_height)

# returns a 3x3 of heights from vectors in vecs
func get_3x3_heights(vecs : Dictionary) -> Dictionary:
	return {"NW" : get_height(vecs["NW"]),
			"N" : get_height(vecs["N"]),
			"NE" : get_height(vecs["NE"]),
			"W" : get_height(vecs["W"]),
			"C" : get_height(vecs["C"]),
			"E" : get_height(vecs["E"]),
			"SW" : get_height(vecs["SW"]),
			"S" : get_height(vecs["S"]),
			"SE" : get_height(vecs["SE"])}

# checks if the height is invalid and sets the filtered_height appropriately
func filter_terrain_cell_height(vec : Vector2i, heights : Dictionary) -> bool:
	var my_terrain_cell : TerrainCell = terrain_map[vec]
	if(heights["W"] < heights["C"] && heights["E"] < heights["C"]):
		my_terrain_cell.set_filtered_height(maxi(heights["W"], heights["E"]))
		return true
	
	if(heights["N"] < heights["C"]):
		if(heights["S"] < heights["C"]):
			my_terrain_cell.set_filtered_height(maxi(heights["N"], heights["S"]))
			return true
		
		if(heights["SW"] < heights["C"] && heights["E"] < heights["C"]):
			my_terrain_cell.set_filtered_height(maxi(heights["N"], maxi(heights["SW"], heights["E"])))
			return true
		
		if(heights["SE"] < heights["C"] && heights["W"] < heights["C"]):
			my_terrain_cell.set_filtered_height(maxi(heights["N"], maxi(heights["SE"], heights["W"])))
			return true
	
	if(heights["S"] < heights["C"]):
		if(heights["NW"] < heights["C"] && heights["E"] < heights["C"]):
			my_terrain_cell.set_filtered_height(maxi(heights["S"], maxi(heights["NW"], heights["E"])))
			return true
		
		if(heights["NE"] < heights["C"] && heights["W"] < heights["C"]):
			my_terrain_cell.set_filtered_height(maxi(heights["S"], maxi(heights["NE"], heights["W"])))
			return true
	
	# height is valid
	if(my_terrain_cell.filtered_height == -1):
		# height hasn't been set before
		my_terrain_cell.set_filtered_height(heights["C"])
	return false

