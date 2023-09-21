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
			var currTileCoord            := Vector2i(x, y)
			var localHeights : Dictionary = GetLocalHeights(currTileCoord)
			var relations : String        = GetRelations(localHeights)
			var atlasCoords : Array       = terrainAssets.GetAtlasCoords(relations)
			
			var tilePeakYPos : int = currTileCoord.y - localHeights["C"]
			var tilesToRender : int = currRenderCoord.y - tilePeakYPos + 1
			if atlasCoords.size() == 1:
				currRenderCoord.y = tilePeakYPos
				terrainAssets.DrawTile(currRenderCoord, atlasCoords.front())
				currRenderCoord.y -= 1
			elif tilesToRender == 1:
				terrainAssets.DrawTile(currRenderCoord, atlasCoords.back())
				currRenderCoord.y -= 1
			elif tilesToRender > 1:
				terrainAssets.DrawTile(currRenderCoord, atlasCoords.front())
				currRenderCoord.y -= 1
				tilesToRender -= 1
				while tilesToRender > 1:
					terrainAssets.DrawTile(currRenderCoord, atlasCoords[1])
					currRenderCoord.y -= 1
					tilesToRender -= 1
				terrainAssets.DrawTile(currRenderCoord, atlasCoords.back())
				currRenderCoord.y -= 1


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
			CorrectIncompatibleHeight(Vector2i(x + chunkPosition.x, y + chunkPosition.y))
	
	print("\n")
	
	for y in range(chunkPosition.y, chunkPosition.y + chunkSize):
		var row : String = ""
		for x in range(chunkPosition.x, chunkPosition.x + chunkSize):
			row += str(int(heightMap[Vector2i(x, y)])) + " "
		print(row)

func CorrectIncompatibleHeight(vector : Vector2i) -> void:
	var heights : Dictionary = GetLocalHeights(vector)
	var lesserHeights  : Array[String] = []
	var equalHeights   : Array[String] = []
	var greaterHeights : Array[String] = []
	var centerHeight : int = heights["C"]
	for key in heights:
		if heights[key] < centerHeight:
			lesserHeights.append(key)
		elif heights[key] == centerHeight:
			equalHeights.append(key)
		else:
			greaterHeights.append(key)
	if not equalHeights.has("N") and not equalHeights.has("S"):
		heightMap[vector] = float(mini(heights["N"], heights["S"]))
		print("(" + str(vector.x) + "," + str(vector.y) + "): " + str(centerHeight) + " -> " + str(mini(heights["N"], heights["S"])))
	elif not equalHeights.has("W") and not equalHeights.has("E"):
		heightMap[vector] = float(mini(heights["W"], heights["E"]))
		print("(" + str(vector.x) + "," + str(vector.y) + "): " + str(centerHeight) + " -> " + str(mini(heights["W"], heights["E"])))
#	elif (("N" in equalHeights and "W" in equalHeights and "E" in equalHeights and "S" in equalHeights) and
#		((not "NW" in equalHeights and not "SE" in equalHeights) or (not "NE" in equalHeights and not "SW" in equalHeights))):
#

func CorrectIncompatibleHeight_(vector : Vector2i) -> void:
	var heights : Dictionary = GetLocalHeights(vector)
	var madeChange : bool = true
	while madeChange:
		var center : int = heights["C"]
		madeChange = false
		if ((heights["N"] < center and heights["S"] < center) #check top & bottom
			or
			(heights["W"] < center and heights["E"] < center) #check left & right
			or #check top,left,right,bottom
			((heights["N"] == center and heights["W"] == center and heights["E"] == center and heights["S"] == center)
				and #check diagonals
				((heights["NW"] < center and heights["SE"] < center) or (heights["NE"] < center and heights["SW"] < center)))
			or #check bridge cases
			(	(heights["S"] < center and ((heights["NW"] < center and heights["E"] < center)
											or
											(heights["NE"] < center and heights["W"] < center)))
				or
				(heights["N"] < center and ((heights["E"] < center and heights["SW"] < center)
											or
											(heights["W"] < center and heights["SE"] < center)))
			)):
				heightMap[vector] -= 1.0
				heights["C"] -= 1
				madeChange = true
		
#		if ((heights["N"] > center and heights["S"] > center) #check top & bottom
#			or
#			(heights["W"] > center and heights["E"] > center) #check left & right
#			or #check top,left,right,bottom
#			((heights["N"] == center and heights["W"] == center and heights["E"] == center and heights["S"] == center)
#				and #check diagonals
#				((heights["NW"] > center and heights["SE"] > center) or (heights["NE"] > center and heights["SW"] > center)))
#			or #check bridge cases
#			(	(heights["S"] > center and ((heights["NW"] > center and heights["E"] > center)
#											or
#											(heights["NE"] > center and heights["W"] > center)))
#				or
#				(heights["N"] > center and ((heights["E"] > center and heights["SW"] > center)
#											or
#											(heights["W"] > center and heights["SE"] > center)))
#			)):
#				heightMap[vector] += 1.0
#				heights["C"] += 1
#				madeChange = true


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

