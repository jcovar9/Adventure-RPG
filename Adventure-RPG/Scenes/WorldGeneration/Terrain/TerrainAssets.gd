class_name TerrainAssets
extends RefCounted

var tile_map : TileMap
var tile_rule_tree : TileRuleTree

func _init(_t : TileMap):
	tile_map = _t
	initialize_tile_rule_tree()


func initialize_tile_rule_tree() -> void:
	tile_rule_tree = TileRuleTree.new()
	var flat_grass := [Vector2i(0,0),Vector2i(1,0),Vector2i(2,0),Vector2i(3,0),Vector2i(4,0)]
	tile_rule_tree.add_branch(
		["_","_","_", "d","d","d", "d","d","d",
		 "_","_","_", "d","d","d", "d","d","d",
		 "_","_","_", "d","d","d", "d","d","d"], flat_grass)
	var shore_inside_corner_SE := [Vector2i(5,0)]
	tile_rule_tree.add_branch(
		["_","_","_", "d","d","d", "d","d","d",
		 "_","a","_", "d","d","d", "d","d","d",
		 "_","a","_", "d","d","w", "d","d","w"], shore_inside_corner_SE)
	var shore_inside_side_S := [Vector2i(6,0)]
	tile_rule_tree.add_branch(
		["_","_","_", "d","d","d", "d","d","d",
		 "_","a","_", "d","d","d", "d","d","d",
		 "_","a","_", "_","w","_", "_","w","_"], shore_inside_side_S)
	var shore_inside_corner_SW := [Vector2i(7,0)]
	tile_rule_tree.add_branch(
		["_","_","_", "d","d","d", "d","d","d",
		 "_","a","_", "d","d","d", "d","d","d",
		 "_","a","_", "w","d","d", "w","d","d"], shore_inside_corner_SW)
	var shore_S_waterfall_left := [Vector2i(6,0)]
	tile_rule_tree.add_branch(
		["_","_","_", "d","d","w", "d","d","w",
		 "_","a","_", "d","d","w", "d","d","w",
		 "_","a","_", "_","a","a", "_","a","a"], shore_S_waterfall_left)
#	var SW := [Vector2i(0,5), Vector2i(0,4), Vector2i(0,3)]
#	tileRuleSet.add_branch(["<>", "=" , ">=",
#							"<" , "=" , "=" ,
#							"_" , "<" , "<>"], SW)
#	var S  := [Vector2i(1,5), Vector2i(1,4), Vector2i(1,3)]
#	tileRuleSet.add_branch([">=", ">=", ">=",
#							">=", "=" , ">=",
#							"_" , "<" , "_" ], S)
#	var SE := [Vector2i(2,5), Vector2i(2,4), Vector2i(2,3)]
#	tileRuleSet.add_branch([">=", "=" , "<>",
#							"=" , "=" , "<" ,
#							"<>", "<" , "_" ], SE)
#	var W  := [Vector2i(0,2)]
#	tileRuleSet.add_branch(["_" , ">=", ">=",
#							"<" , "=" , ">=",
#							"_" , ">=", ">="], W)
#	var E  := [Vector2i(2,2)]
#	tileRuleSet.add_branch([">=", ">=", "_" ,
#							">=", "=" , "<" ,
#							">=", ">=", "_" ], E)
#	var NW := [Vector2i(0,1)]
#	tileRuleSet.add_branch(["_" , "<" , "<>",
#							"<" , "=" , "=" ,
#							"<>", "=" , ">="], NW)
#	var N  := [Vector2i(1,1)]
#	tileRuleSet.add_branch(["_" , "<" , "_" ,
#							">=", "=" , ">=",
#							">=", ">=", ">="], N)
#	var NE := [Vector2i(2,1)]
#	tileRuleSet.add_branch(["<>", "<" , "_" ,
#							"=" , "=" , "<" ,
#							">=", "=" , "<>"], NE)
#
#	var DiagSE := [Vector2i(4,3), Vector2i(4,2), Vector2i(4,1)]
#	tileRuleSet.add_branch(["_", ">=", "<=",
#							">=", "=" , "<" ,
#							"<=", "<" , "<" ], DiagSE)
#	var DiagSW := [Vector2i(5,3), Vector2i(5,2), Vector2i(5,1)]
#	tileRuleSet.add_branch(["<=", ">=", "_",
#							"<" , "=" , ">=",
#							"<" , "<" , "<="], DiagSW)
#	var DiagNE := [Vector2i(4,4)]
#	tileRuleSet.add_branch(["<=", "<" , "<" ,
#							">=", "=" , "<" ,
#							"_", ">=", "<="], DiagNE)
#	var DiagNW := [Vector2i(5,4)]
#	tileRuleSet.add_branch(["<" , "<" , "<=",
#							"<" , "=" , ">=",
#							"<=", ">=", "_"], DiagNW)



func DrawTile(coord : Vector2i, atlasCoord : Vector2i) -> void:
	tile_map.add_layer(coord.y)
	tile_map.set_cell(0, coord, 0, atlasCoord, 0)


func GetAtlasCoords(localHeights : Dictionary) -> Array[Vector2i]:
	var pattern : Array[String] = GetPattern(localHeights)
	var atlasCoords : Array[Vector2i] = tile_rule_tree.get_atlas(pattern)
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
