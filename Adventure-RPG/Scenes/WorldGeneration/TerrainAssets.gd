extends Node2D

@onready var tilemap = $"../TileMap"

var TileDict : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	InitializeTileDict()

func InitializeTileDict() -> void:
	var SW_1 = Vector2i(0,5)
	var SW_2 = Vector2i(0,4)
	var SW_3 = Vector2i(0,3)
	TileDict["<==<==<<<"] = [SW_1, SW_2, SW_3]
	var S_1  = Vector2i(1,5)
	var S_2  = Vector2i(1,4)
	var S_3  = Vector2i(1,3)
	TileDict["======<<<"] = [S_1, S_2, S_3]
	var SE_1 = Vector2i(2,5)
	var SE_2 = Vector2i(2,4)
	var SE_3 = Vector2i(2,3)
	TileDict["==<==<<<<"] = [SE_1, SE_2, SE_3]
	var W_1  = Vector2i(0,2)
	TileDict["<==<==<=="] = [W_1]
	var E_1  = Vector2i(2,2)
	TileDict["==<==<==<"] = E_1
	var NW_1 = Vector2i(0,1)
	TileDict["<<<<==<=="] = NW_1
	var N_1  = Vector2i(1,1)
	TileDict["<<<======"] = N_1
	var NE_1 = Vector2i(2,1)
	TileDict["<<<==<==<"] = NE_1
	var DiagNW_1 = Vector2i(4,3)
	var DiagNW_2 = Vector2i(4,2)
	var DiagNW_3 = Vector2i(4,1)
	var DiagNW = [DiagNW_1, DiagNW_2, DiagNW_3]
	TileDict["=====<=<<"] = DiagNW
	TileDict["=======<<"] = DiagNW
	TileDict["==<==<=<<"] = DiagNW
	TileDict["=====<<<<"] = DiagNW
	var DiagNE_1 = Vector2i(5,3)
	var DiagNE_2 = Vector2i(5,2)
	var DiagNE_3 = Vector2i(5,1)
	var DiagNE = [DiagNE_1, DiagNE_2, DiagNE_3]
	TileDict["===<==<<="] = DiagNE
	TileDict["======<<="] = DiagNE
	TileDict["<==<==<<="] = DiagNE
	TileDict["===<==<<<"] = DiagNE
	TileDict["===<==<=="] = DiagNE
	var DiagSW_1 = Vector2i(4,4)
	var DiagSW = [DiagSW_1]
	TileDict["=<<==<==="] = DiagSW
	TileDict["==<==<==="] = DiagSW
	TileDict["<<<==<==="] = DiagSW
	TileDict["=<<==<==<"] = DiagSW
	TileDict["=<<======"] = DiagSW
	var DiagSE_1 = Vector2i(5,4)
	var DiagSE = [DiagSE_1]
	TileDict["<<=<====="] = DiagSE
	TileDict["<==<====="] = DiagSE
	TileDict["<<<<====="] = DiagSE
	TileDict["<<=<==<=="] = DiagSE
	TileDict["<<======="] = DiagSE
	













