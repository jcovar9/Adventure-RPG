class_name TerrainAssets

var tileMap : TileMap
var tileRuleSet : TileRuleSet

func _init(_t : TileMap):
	tileMap = _t
	InitializeTileRuleSet()
	

func InitializeTileRuleSet() -> void:
	tileRuleSet = TileRuleSet.new()
	var full_grass := [Vector2i(1,2)]
	tileRuleSet.add_branch(["_" , ">=", "_" ,
							">=", "=" , ">=",
							"_" , ">=", "_" ], full_grass)
	var SW := [Vector2i(0,5), Vector2i(0,4), Vector2i(0,3)]
	tileRuleSet.add_branch(["<>", "=" , ">=",
							"<" , "=" , "=" ,
							"_" , "<" , "<>"], SW)
	var S  := [Vector2i(1,5), Vector2i(1,4), Vector2i(1,3)]
	tileRuleSet.add_branch([">=", ">=", ">=",
							">=", "=" , ">=",
							"_" , "<" , "_" ], S)
	var SE := [Vector2i(2,5), Vector2i(2,4), Vector2i(2,3)]
	tileRuleSet.add_branch([">=", "=" , "<>",
							"=" , "=" , "<" ,
							"<>", "<" , "_" ], SE)
	var W  := [Vector2i(0,2)]
	tileRuleSet.add_branch(["_" , ">=", ">=",
							"<" , "=" , ">=",
							"_" , ">=", ">="], W)
	var E  := [Vector2i(2,2)]
	tileRuleSet.add_branch([">=", ">=", "_" ,
							">=", "=" , "<" ,
							">=", ">=", "_" ], E)
	var NW := [Vector2i(0,1)]
	tileRuleSet.add_branch(["_" , "<" , "<>",
							"<" , "=" , "=" ,
							"<>", "=" , ">="], NW)
	var N  := [Vector2i(1,1)]
	tileRuleSet.add_branch(["_" , "<" , "_" ,
							">=", "=" , ">=",
							">=", ">=", ">="], N)
	var NE := [Vector2i(2,1)]
	tileRuleSet.add_branch(["<>", "<" , "_" ,
							"=" , "=" , "<" ,
							">=", "=" , "<>"], SE)
	
	var DiagNW := [Vector2i(4,3), Vector2i(4,2), Vector2i(4,1)]
	tileRuleSet.add_branch(["_", ">=", "<=",
							">=", "=" , "<" ,
							"<=", "<" , "<" ], DiagNW)
	var DiagNE := [Vector2i(5,3), Vector2i(5,2), Vector2i(5,1)]
	tileRuleSet.add_branch(["<=", ">=", "_",
							"<" , "=" , ">=",
							"<" , "<" , "<="], DiagNE)
	var DiagSW := [Vector2i(4,4)]
	tileRuleSet.add_branch(["<=", "<" , "<" ,
							">=", "=" , "<" ,
							"_", ">=", "<="], DiagSW)
	var DiagSE := [Vector2i(5,4)]
	tileRuleSet.add_branch(["<" , "<" , "<=",
							"<" , "=" , ">=",
							"<=", ">=", "_"], DiagSE)



func DrawTile(coord : Vector2i, atlasCoord : Vector2i) -> void:
	# tileMap.add_layer(coord.y)
	tileMap.set_cell(0, coord, 0, atlasCoord, 0)


func GetAtlasCoords(localHeights : Dictionary) -> Array[Vector2i]:
	var pattern : Array[String] = GetPattern(localHeights)
	var atlasCoords : Array[Vector2i] = tileRuleSet.get_atlas(pattern)
	return atlasCoords


func GetPattern(localHeights : Dictionary) -> Array[String]:
	var local_positions := ["NW","N","NE","W","C","E","SW","S","SE"]
	var pattern : Array[String] = []
	for position in local_positions:
		if localHeights[position] < localHeights["C"]:
			pattern.append("<")
		elif localHeights[position] > localHeights["C"]:
			pattern.append(">")
		else:
			pattern.append("=")
	return pattern
