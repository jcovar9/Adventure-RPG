class_name Chunk
extends Node2D


var chunkPosition : Vector2i
var chunkSize : int
var maxElevation : int
var noiseGenerator : NoiseGenerator
var terrainAssets : TerrainAssets
var heightMap : Dictionary

func _init(_cP:Vector2i, _cS:int, _mE:int, _nG:NoiseGenerator, _tA:TerrainAssets) -> void:
	chunkPosition = _cP
	chunkSize = _cS
	maxElevation = _mE
	noiseGenerator = _nG
	terrainAssets = _tA
	InitializeHeightMap()
	RenderChunk()

func RenderChunkTile(chunk_tile: Vector2i) -> bool:
	var local_heights : Dictionary = GetLocalHeights(chunk_tile)
	var current_tile_peak := Vector2i(chunk_tile.x, chunk_tile.y - local_heights["C"])
	var south_tile_peak := Vector2i(chunk_tile.x, chunk_tile.y + 1 - local_heights["S"])
	var atlas_coords : Array[Vector2i] = terrainAssets.GetAtlasCoords(local_heights)
	if atlas_coords[0] == Vector2i(-1,-1):
		return false
	var render_coord := Vector2i(south_tile_peak)
	var tiles_to_render : int = south_tile_peak.y - current_tile_peak.y
	if tiles_to_render == 1:
		# current chunk tile must be same height as the south chunk tile
		# render the peak of the chunk tile
		terrainAssets.DrawTile(render_coord, atlas_coords.back())
		render_coord.y -= 1
	elif tiles_to_render > 1:
		# current chunk tile must be greater height than south chunk tile
		# render the base of the chunk tile
		terrainAssets.DrawTile(render_coord, atlas_coords.front())
		render_coord.y -= 1
		tiles_to_render -= 1
		while tiles_to_render > 1:
			# iterate through the middle of the chunk tile until the peak
			terrainAssets.DrawTile(render_coord, atlas_coords[1])
			render_coord.y -= 1
			tiles_to_render -= 1
		# render the peak of the chunk tile
		terrainAssets.DrawTile(render_coord, atlas_coords.back())
		render_coord.y -= 1
	return true


func RenderChunk() -> void:
	for x in range(chunkPosition.x, chunkPosition.x + chunkSize):
		for y in range(chunkPosition.y + chunkSize - 1, chunkPosition.y - 1, -1):
			var result : bool = RenderChunkTile(Vector2i(x, y))
			if result == false:
				print("Error: got no atlas coords for chunk_tile: " + str(x) + ", " + str(y))


func GetRelations(localHeights : Dictionary) -> String:
	var relationTileOrder := ["NW","N","NE","W","C","E","SW","S","SE"]
	var relations : String = ""
	for key in relationTileOrder:
		if localHeights[key] < localHeights["C"]:
			relations += "<"
		else:
			relations += "="
	return relations


func InitializeHeightMap() -> void:
	heightMap = {}
	for x in range(0,chunkSize):
		for y in range(0,chunkSize):
			var vector := Vector2i(x + chunkPosition.x, y + chunkPosition.y)
			heightMap[vector] = noiseGenerator.GetNoise(vector.x,vector.y) * maxElevation
	
	for y in range(chunkPosition.y, chunkPosition.y + chunkSize):
		for x in range(chunkPosition.x, chunkPosition.x + chunkSize):
			printraw(str(int(heightMap[Vector2i(x, y)])) + " ")
		print("")
	
	print("\n")
	
	for x in range(0,chunkSize):
		for y in range(0,chunkSize):
			RecursivelyFixHeight(Vector2i(x + chunkPosition.x, y + chunkPosition.y))
	
	print("\n")
	
	for y in range(chunkPosition.y, chunkPosition.y + chunkSize):
		for x in range(chunkPosition.x, chunkPosition.x + chunkSize):
			printraw(str(int(heightMap[Vector2i(x, y)])) + " ")
		print("")
	
	print("\n")


func RecursivelyFixHeight(vector : Vector2i) -> void:
	var local_vectors : Array[Vector2i] = GetLocalVectors(vector)
	var local_heights : Dictionary = GetLocalHeights(vector)
	var less_heights : Array[String] = []
	var center_height : int = local_heights["C"]
	for key in local_heights:
		if local_heights[key] < center_height:
			less_heights.append(key)
	local_vectors.erase(Vector2i(vector))
	if FixHeight(vector, less_heights):
		for local_vector in local_vectors:
			if local_vector in heightMap:
				RecursivelyFixHeight(local_vector)


func FixHeight(vector : Vector2i, less_heights : Array[String]) -> bool:
	if ifArrayInArray(["N", "S"], less_heights):
		heightMap[vector] = minf(GetHeight(Vector2i(vector.x, vector.y - 1)), GetHeight(Vector2i(vector.x, vector.y + 1)))
		return true
	elif ifArrayInArray(["W", "E"], less_heights):
		heightMap[vector] = minf(GetHeight(Vector2i(vector.x - 1, vector.y)), GetHeight(Vector2i(vector.x + 1, vector.y)))
		return true
#	elif ifArrayInArray(["NW", "SE"], unequalHeights):
#		AdjustHeightMap(vector, localVectors)
#		return true
#	elif ifArrayInArray(["NE", "SW"], unequalHeights):
#		AdjustHeightMap(vector, localVectors)
#		return true
#	elif ifArrayInArray(["S", "NW", "E"], unequalHeights):
#		AdjustHeightMap(vector, localVectors)
#		return true
#	elif ifArrayInArray(["S", "NE", "W"], unequalHeights):
#		AdjustHeightMap(vector, localVectors)
#		return true
#	elif ifArrayInArray(["N", "E", "SW"], unequalHeights):
#		AdjustHeightMap(vector, localVectors)
#		return true
#	elif ifArrayInArray(["N", "W", "SE"], unequalHeights):
#		AdjustHeightMap(vector, localVectors)
#		return true
	else:
		return false


#func AdjustHeightMap(vector : Vector2i, local_vectors : Array[Vector2i]) -> void:
#	var heightCounts : Dictionary = {int(GetHeight(vector)) : 1}
#	var most_common_height : int = int(GetHeight(vector))
#	for local_vector in local_vectors:
#		var local_vector_height : int = int(GetHeight(local_vector))
#		if heightCounts.has(local_vector_height):
#			heightCounts[local_vector_height] += 1
#		else:
#			heightCounts[local_vector_height] = 1
#		if heightCounts[most_common_height] < heightCounts[local_vector_height]:
#			most_common_height = local_vector_height
#	heightMap[vector] = most_common_height


func ifArrayInArray(keys : Array[String], array : Array[String]) -> bool:
	for key in keys:
		if not key in array:
			return false
	return true


func GetLocalHeights(vector : Vector2i) -> Dictionary:
	var local_heights : Dictionary = {}
	var local_vectors : Array[Vector2i] = GetLocalVectors(vector)
	var directions := ["NW","N","NE","W","C","E","SW","S","SE"]
	for i in range(0, directions.size()):
		local_heights[directions[i]] = int(GetHeight(local_vectors[i]))
	return local_heights


func GetLocalVectors(vector : Vector2i) -> Array[Vector2i]:
	return [Vector2i(vector.x - 1, vector.y - 1),
			Vector2i(vector.x    , vector.y - 1),
			Vector2i(vector.x + 1, vector.y - 1),
			Vector2i(vector.x - 1, vector.y    ),
			Vector2i(vector)                    ,
			Vector2i(vector.x + 1, vector.y    ),
			Vector2i(vector.x - 1, vector.y + 1),
			Vector2i(vector.x    , vector.y + 1),
			Vector2i(vector.x + 1, vector.y + 1)]


func GetHeight(vector : Vector2i) -> float:
	if heightMap.has(vector):
		return heightMap[vector]
	else:
		return noiseGenerator.GetNoise(vector.x, vector.y) * maxElevation

