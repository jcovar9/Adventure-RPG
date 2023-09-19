class_name TerrainAssets
extends Node2D

var tileMap : TileMap
var tileDict : Dictionary = {}

func _init(_t : TileMap):
	tileMap = _t
	InitializeTileDict()
	

func InitializeTileDict() -> void:
	var SW_1 = Vector2i(0,5)
	var SW_2 = Vector2i(0,4)
	var SW_3 = Vector2i(0,3)
	tileDict["<==<==<<<"] = [SW_1, SW_2, SW_3]
	var S_1  = Vector2i(1,5)
	var S_2  = Vector2i(1,4)
	var S_3  = Vector2i(1,3)
	tileDict["======<<<"] = [S_1, S_2, S_3]
	var SE_1 = Vector2i(2,5)
	var SE_2 = Vector2i(2,4)
	var SE_3 = Vector2i(2,3)
	tileDict["==<==<<<<"] = [SE_1, SE_2, SE_3]
	var W_1  = Vector2i(0,2)
	tileDict["<==<==<=="] = [W_1]
	var E_1  = Vector2i(2,2)
	tileDict["==<==<==<"] = [E_1]
	var NW_1 = Vector2i(0,1)
	tileDict["<<<<==<=="] = [NW_1]
	var N_1  = Vector2i(1,1)
	tileDict["<<<======"] = [N_1]
	var NE_1 = Vector2i(2,1)
	tileDict["<<<==<==<"] = [NE_1]
	var DiagNW_1 = Vector2i(4,3)
	var DiagNW_2 = Vector2i(4,2)
	var DiagNW_3 = Vector2i(4,1)
	var DiagNW = [DiagNW_1, DiagNW_2, DiagNW_3]
	tileDict["=====<=<<"] = DiagNW
	tileDict["=======<<"] = DiagNW
	tileDict["==<==<=<<"] = DiagNW
	tileDict["=====<<<<"] = DiagNW
	var DiagNE_1 = Vector2i(5,3)
	var DiagNE_2 = Vector2i(5,2)
	var DiagNE_3 = Vector2i(5,1)
	var DiagNE = [DiagNE_1, DiagNE_2, DiagNE_3]
	tileDict["===<==<<="] = DiagNE
	tileDict["======<<="] = DiagNE
	tileDict["<==<==<<="] = DiagNE
	tileDict["===<==<<<"] = DiagNE
	tileDict["===<==<=="] = DiagNE
	var DiagSW_1 = Vector2i(4,4)
	var DiagSW = [DiagSW_1]
	tileDict["=<<==<==="] = DiagSW
	tileDict["==<==<==="] = DiagSW
	tileDict["<<<==<==="] = DiagSW
	tileDict["=<<==<==<"] = DiagSW
	tileDict["=<<======"] = DiagSW
	var DiagSE_1 = Vector2i(5,4)
	var DiagSE = [DiagSE_1]
	tileDict["<<=<====="] = DiagSE
	tileDict["<==<====="] = DiagSE
	tileDict["<<<<====="] = DiagSE
	tileDict["<<=<==<=="] = DiagSE
	tileDict["<<======="] = DiagSE


func DrawTile(coord : Vector2i, atlasCoord : Vector2i) -> void:
	tileMap.set_cell(0, coord, 0, atlasCoord, 0)


func GetAtlasCoords(relations : String) -> Array:
	var atlasCoords : Array
	if tileDict.has(relations):
		atlasCoords = tileDict[relations]
	else:
		atlasCoords = [Vector2i(1,2)]
	return atlasCoords
