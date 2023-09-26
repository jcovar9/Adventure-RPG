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


func RenderChunk() -> void:
	for x in range(chunkPosition.x, chunkPosition.x + chunkSize):
		var renderCoord := Vector2i(x, chunkPosition.y + chunkSize - 1)
		for y in range(chunkPosition.y + chunkSize - 1, chunkPosition.y - 1, -1):
			var currentTile := Vector2i(x, y)
			var localHeights : Dictionary = GetLocalHeights(currentTile, GetLocalVectors(currentTile))
			var relations : String = GetRelations(localHeights)
			var atlasCoords : Array[Vector2i] = terrainAssets.GetAtlasCoords(relations)
			
			var currentPeak : int = currentTile.y - localHeights["C"]
			if y == chunkPosition.y + chunkSize - 1:
				renderCoord.y = currentPeak
			
			if renderCoord.y == currentPeak:
				#just render the top tile cuz thats all that can be seen
				terrainAssets.DrawTile(renderCoord, atlasCoords[0])
				renderCoord.y -= 1
			elif renderCoord.y > currentPeak:
				#check how many tiles to render
				var tilesToRender : int = renderCoord.y - currentPeak + 1
				terrainAssets.DrawTile(renderCoord, atlasCoords[0])
				renderCoord.y -= 1
				tilesToRender -= 1
				while tilesToRender > 1:
					terrainAssets.DrawTile(renderCoord, atlasCoords[1])
					renderCoord.y -= 1
					tilesToRender -= 1
				terrainAssets.DrawTile(renderCoord, atlasCoords[2])
				renderCoord.y -= 1
			else:
				#do nothing this tile is blocked
				pass
			


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
		var row : String = ""
		for x in range(chunkPosition.x, chunkPosition.x + chunkSize):
			row += str(int(heightMap[Vector2i(x, y)])) + " "
		print(row)
	
	print("\n")
	
	for x in range(0,chunkSize):
		for y in range(0,chunkSize):
			RecursivelyFixHeight(Vector2i(x + chunkPosition.x, y + chunkPosition.y))
	
	print("\n")
	
	for y in range(chunkPosition.y, chunkPosition.y + chunkSize):
		var row : String = ""
		for x in range(chunkPosition.x, chunkPosition.x + chunkSize):
			row += str(int(heightMap[Vector2i(x, y)])) + " "
		print(row)
	
	print("\n")


func RecursivelyFixHeight(vector : Vector2i) -> void:
	var localVectors : Array[Vector2i] = GetLocalVectors(vector)
	var localHeights : Dictionary = GetLocalHeights(vector, localVectors)
	var equalHeights   : Array[String] = []
	var unequalHeights : Array[String] = []
	var centerHeight : int = localHeights["C"]
	for key in localHeights:
		if localHeights[key] == centerHeight:
			equalHeights.append(key)
		else:
			unequalHeights.append(key)
	if FixHeight(vector, localVectors, unequalHeights):
		for localVector in localVectors:
			if localVector in heightMap:
				RecursivelyFixHeight(localVector)


func FixHeight(vector : Vector2i, localVectors : Array[Vector2i], unequalHeights : Array[String]) -> bool:
	if ifArrayInArray(["N", "S"], unequalHeights):
		AdjustHeightMap(vector, localVectors)
		return true
	elif ifArrayInArray(["W", "E"], unequalHeights):
		AdjustHeightMap(vector, localVectors)
		return true
	elif ifArrayInArray(["NW", "SE"], unequalHeights):
		AdjustHeightMap(vector, localVectors)
		return true
	elif ifArrayInArray(["NE", "SW"], unequalHeights):
		AdjustHeightMap(vector, localVectors)
		return true
	elif ifArrayInArray(["S", "NW", "E"], unequalHeights):
		AdjustHeightMap(vector, localVectors)
		return true
	elif ifArrayInArray(["S", "NE", "W"], unequalHeights):
		AdjustHeightMap(vector, localVectors)
		return true
	elif ifArrayInArray(["N", "E", "SW"], unequalHeights):
		AdjustHeightMap(vector, localVectors)
		return true
	elif ifArrayInArray(["N", "W", "SE"], unequalHeights):
		AdjustHeightMap(vector, localVectors)
		return true
	else:
		return false


func AdjustHeightMap(vector : Vector2i, localVectors : Array[Vector2i]) -> void:
	var heightCounts : Dictionary = {int(GetHeight(vector)) : 1}
	var mostCommonHeight : int = int(GetHeight(vector))
	for localVector in localVectors:
		var localVectorHeight : int = int(GetHeight(localVector))
		if heightCounts.has(localVectorHeight):
			heightCounts[localVectorHeight] += 1
		else:
			heightCounts[localVectorHeight] = 1
		if heightCounts[mostCommonHeight] < heightCounts[localVectorHeight]:
			mostCommonHeight = localVectorHeight
	heightMap[vector] = mostCommonHeight


func ifArrayInArray(keys : Array[String], array : Array[String]) -> bool:
	for key in keys:
		if not key in array:
			return false
	return true


func GetLocalHeights(vector : Vector2i, localVectors : Array[Vector2i]) -> Dictionary:
	var localHeights : Dictionary = {}
	var directions := ["NW","N","NE","W","E","SW","S","SE"]
	localHeights["C"]  = int(GetHeight(vector))
	for i in range(0, directions.size()):
		localHeights[directions[i]] = int(GetHeight(localVectors[i]))
	return localHeights


func GetLocalVectors(vector : Vector2i) -> Array[Vector2i]:
	return [Vector2i(vector.x - 1, vector.y - 1),
			Vector2i(vector.x    , vector.y - 1),
			Vector2i(vector.x + 1, vector.y - 1),
			Vector2i(vector.x - 1, vector.y    ),
			Vector2i(vector.x + 1, vector.y    ),
			Vector2i(vector.x - 1, vector.y + 1),
			Vector2i(vector.x    , vector.y + 1),
			Vector2i(vector.x + 1, vector.y + 1)]


func GetHeight(vector : Vector2i) -> float:
	if heightMap.has(vector):
		return heightMap[vector]
	else:
		return noiseGenerator.GetNoise(vector.x, vector.y) * maxElevation

