class_name TerrainAssets
extends Node2D

var tileMap : TileMap
var tileDict : Dictionary = {}

func _init(_t : TileMap):
	tileMap = _t
	InitializeTileDict()
	

func InitializeTileDict() -> void:
	var SW := [Vector2i(0,5), Vector2i(0,4), Vector2i(0,3)]
	tileDict["<==<==<<<"] = SW
	var S  := [Vector2i(1,5), Vector2i(1,4), Vector2i(1,3)]
	tileDict["======<<<"] = S
	tileDict["======<<="] = S
	tileDict["=======<<"] = S
	var SE := [Vector2i(2,5), Vector2i(2,4), Vector2i(2,3)]
	tileDict["==<==<<<<"] = SE
	var W  := [Vector2i(0,2)]
	tileDict["<==<==<=="] = W
	tileDict["===<==<=="] = W
	tileDict["<==<====="] = W
	var E  := [Vector2i(2,2)]
	tileDict["==<==<==<"] = E
	tileDict["==<==<==="] = E
	tileDict["=====<==<"] = E
	var NW := [Vector2i(0,1)]
	tileDict["<<<<==<=="] = NW
	var N  := [Vector2i(1,1)]
	tileDict["<<<======"] = N
	tileDict["=<<======"] = N
	tileDict["<<======="] = N
	var NE := [Vector2i(2,1)]
	tileDict["<<<==<==<"] = NE
	
	var DiagNW := [Vector2i(4,3), Vector2i(4,2), Vector2i(4,1)]
	tileDict["=====<=<<"] = DiagNW
	tileDict["==<==<=<<"] = DiagNW
	tileDict["=====<<<<"] = DiagNW
	var DiagNE := [Vector2i(5,3), Vector2i(5,2), Vector2i(5,1)]
	tileDict["===<==<<="] = DiagNE
	tileDict["<==<==<<="] = DiagNE
	tileDict["===<==<<<"] = DiagNE
	var DiagSW := [Vector2i(4,4)]
	tileDict["=<<==<==="] = DiagSW
	tileDict["<<<==<==="] = DiagSW
	tileDict["=<<==<==<"] = DiagSW
	var DiagSE := [Vector2i(5,4)]
	tileDict["<<=<====="] = DiagSE
	tileDict["<<<<====="] = DiagSE
	tileDict["<<=<==<=="] = DiagSE


func DrawTile(coord : Vector2i, atlasCoord : Vector2i) -> void:
	tileMap.set_cell(0, coord, 0, atlasCoord, 0)


func GetAtlasCoords(relations : String) -> Array[Vector2i]:
	var atlasCoords : Array[Vector2i]
	if tileDict.has(relations):
		atlasCoords = tileDict[relations]
	else:
		atlasCoords = [Vector2i(1,2)]
	return atlasCoords
