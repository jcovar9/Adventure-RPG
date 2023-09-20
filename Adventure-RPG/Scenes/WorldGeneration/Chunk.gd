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
		var currRenderCoord := Vector2i(x, chunkPosition.y + chunkSize - 1)
		for y in range(chunkPosition.y + chunkSize - 1, chunkPosition.y - 1, -1):
			var currTileCoord := Vector2i(x, y)
			var localHeights : Dictionary = GetLocalHeights(currTileCoord)
			var relations : String = GetRelations(localHeights)
			var atlasCoords : Array = terrainAssets.GetAtlasCoords(relations)
			var tilesToRender : int = absi(currTileCoord.y - localHeights["C"]) - absi(currRenderCoord.y)
			if tilesToRender == 0:
				pass


func RenderTile(x : int, y : int) -> void:
	var localHeights : Dictionary = GetLocalHeights(Vector2i(x,y))
	var relations : String = GetRelations(localHeights)
	var atlasCoords : Array = terrainAssets.GetAtlasCoords(relations)
	var currHeight : int = localHeights["S"]
	if localHeights["C"] - currHeight == 0:
		terrainAssets.DrawTile(Vector2i(x, y), atlasCoords.back())
	elif localHeights["C"] - currHeight == 1:
		terrainAssets.DrawTile(Vector2i(x, y), atlasCoords.front())
		terrainAssets.DrawTile(Vector2i(x, y - 1), atlasCoords.back())
	elif localHeights["C"] - currHeight == 2:
		terrainAssets.DrawTile(Vector2i(x, y), atlasCoords.front())
		terrainAssets.DrawTile(Vector2i(x, y - 1), atlasCoords[1])
		terrainAssets.DrawTile(Vector2i(x, y - 2), atlasCoords.back())
	elif localHeights["C"] - currHeight > 2:
		terrainAssets.DrawTile(Vector2i(x, y), atlasCoords.front())
		currHeight += 1
		var counter : int = 1
		while localHeights["C"] - currHeight > 1:
			terrainAssets.DrawTile(Vector2i(x, y - counter), atlasCoords[1])
			counter += 1
		terrainAssets.DrawTile(Vector2i(x, y - counter), atlasCoords.back())
		


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
	
	for x in range(0,chunkSize):
		for y in range(0,chunkSize):
			CorrectIncompatibleHeight(Vector2i(x + chunkPosition.x, y + chunkPosition.y))


func CorrectIncompatibleHeight(vector : Vector2i) -> void:
	var heights : Dictionary = GetLocalHeights(vector)
	var madeChange : bool = true
	while madeChange:
		var center : int = heights["C"]
		madeChange = false
#		if ((heights["N"] < center and heights["S"] < center) #check top & bottom
#			or
#			(heights["W"] < center and heights["E"] < center) #check left & right
#			or #check top,left,right,bottom
#			((heights["N"] == center and heights["W"] == center and heights["E"] == center and heights["S"] == center)
#				and #check diagonals
#				((heights["NW"] < center and heights["SE"] < center) or (heights["NE"] < center and heights["SW"] < center)))
#			or #check bridge cases
#			(	(heights["S"] < center and ((heights["NW"] < center and heights["E"] < center)
#											or
#											(heights["NE"] < center and heights["W"] < center)))
#				or
#				(heights["N"] < center and ((heights["E"] < center and heights["SW"] < center)
#											or
#											(heights["W"] < center and heights["SE"] < center)))
#			)):
#				heightMap[vector] -= 1.0
#				heights["C"] -= 1
#				madeChange = true
		
		if ((heights["N"] > center and heights["S"] > center) #check top & bottom
			or
			(heights["W"] > center and heights["E"] > center) #check left & right
			or #check top,left,right,bottom
			((heights["N"] == center and heights["W"] == center and heights["E"] == center and heights["S"] == center)
				and #check diagonals
				((heights["NW"] > center and heights["SE"] > center) or (heights["NE"] > center and heights["SW"] > center)))
			or #check bridge cases
			(	(heights["S"] > center and ((heights["NW"] > center and heights["E"] > center)
											or
											(heights["NE"] > center and heights["W"] > center)))
				or
				(heights["N"] > center and ((heights["E"] > center and heights["SW"] > center)
											or
											(heights["W"] > center and heights["SE"] > center)))
			)):
				heightMap[vector] += 1.0
				heights["C"] += 1
				madeChange = true


func GetLocalHeights(vector : Vector2i) -> Dictionary:
	var localHeights : Dictionary = {}
	localHeights["NW"] = int(GetHeight(Vector2i(vector.x - 1, vector.y - 1)))
	localHeights["N"]  = int(GetHeight(Vector2i(vector.x    , vector.y - 1)))
	localHeights["NE"] = int(GetHeight(Vector2i(vector.x + 1, vector.y - 1)))
	localHeights["W"]  = int(GetHeight(Vector2i(vector.x - 1, vector.y    )))
	localHeights["C"]  = int(GetHeight(vector))
	localHeights["E"]  = int(GetHeight(Vector2i(vector.x + 1, vector.y    )))
	localHeights["SW"] = int(GetHeight(Vector2i(vector.x - 1, vector.y + 1)))
	localHeights["S"]  = int(GetHeight(Vector2i(vector.x    , vector.y + 1)))
	localHeights["SE"] = int(GetHeight(Vector2i(vector.x + 1, vector.y + 1)))
	return localHeights


func GetHeight(vector : Vector2i) -> float:
	if heightMap.has(vector):
		return heightMap[vector]
	else:
		return noiseGenerator.GetNoise(vector.x, vector.y) * maxElevation

