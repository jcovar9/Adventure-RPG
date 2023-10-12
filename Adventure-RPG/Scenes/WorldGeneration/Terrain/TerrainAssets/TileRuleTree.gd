class_name TileRuleTree
extends RefCounted

var root_node : TileRuleBranch

func _init():
	root_node = TileRuleBranch.new()

# adds a pattern of tile rules to the tree
func add_branch(pattern : Array[String], atlas_vectors : Array[Vector2i]) -> void:
	var leaf_node_type : String = pattern.pop_back()
	var curr_node : TileRuleBranch = root_node
	for node_type in pattern:
		# iterate through the pattern
		if curr_node.get_child_node(node_type) == null:
			# need to make new node for branch
			var child_node := TileRuleBranch.new()
			# assign child node to continue building new branch
			curr_node.set_child_node(node_type, child_node)
		# child is not null so proceed down branch
		curr_node = curr_node.get_child_node(node_type)
	
	# need to give last node the atlas_vectors
	var leaf_node := TileRuleBranch.new()
	leaf_node.set_atlas_vectors(atlas_vectors)
	curr_node.set_child_node(leaf_node_type, leaf_node)

# gets the atlas tiles associated with the given pattern of tile rules
func get_atlas(pattern : Array[String]) -> Array[Vector2i]:
	var current_nodes : Array[TileRuleBranch] = [root_node]
	for node_type in pattern:
		# iterate through the pattern
		var next_nodes : Array[TileRuleBranch] = []
		for curr_node in current_nodes:
			# iterate through the current nodes
			var next_node : TileRuleBranch = curr_node.get_child_node(node_type)
			if next_node != null:
				next_nodes.append(next_node)
			var next_any_node : TileRuleBranch = curr_node.get_child_node("_")
			if next_any_node != null:
				next_nodes.append(next_any_node)
		
		current_nodes = next_nodes
		if current_nodes.size() == 0:
			# we have no branches that fit the pattern
			print("Error: atlas search stopped at node_type: " + node_type)
			return [Vector2i(-1,-1)]
	
	if current_nodes.size() == 1:
		return current_nodes[0].get_atlas_vectors()
	else:
		printraw("Error: found too many branches for pattern: ")
		print(pattern)
		return [Vector2i(-1,-1)]



#func get_atlas(pattern : Array[String]) -> Array[Vector2i]:
#	var atlas : Array[Vector2i] = []
#	get_atlas_(root_node, pattern, 0, atlas)
#	return atlas
#
#func get_atlas_(currNode : RuleSetNode, pattern : Array[String], index : int, atlas : Array[Vector2i]):
#	if currNode.get_atlas_vectors().size() > 0:
#		# we must be at the end of the pattern, update the atlas by reference
#		atlas.append_array(currNode.get_atlas_vectors())
#	else:
#		# we are not at the end of the pattern
#		var pattern_index : String = pattern[index]
#		index += 1
#		match pattern_index:
#			">":
#				if currNode.get_child_node(">=") != null:
#					get_atlas_(currNode.get_child_node(">="), pattern, index, atlas)
#				if currNode.get_child_node("<>") != null:
#					get_atlas_(currNode.get_child_node("<>"), pattern, index, atlas)
#			"<":
#				if currNode.get_child_node("<=") != null:
#					get_atlas_(currNode.get_child_node("<="), pattern, index, atlas)
#				if currNode.get_child_node("<") != null:
#					get_atlas_(currNode.get_child_node("<"), pattern, index, atlas)
#				if currNode.get_child_node("<>") != null:
#					get_atlas_(currNode.get_child_node("<>"), pattern, index, atlas)
#			"=":
#				if currNode.get_child_node(">=") != null:
#					get_atlas_(currNode.get_child_node(">="), pattern, index, atlas)
#				if currNode.get_child_node("<=") != null:
#					get_atlas_(currNode.get_child_node("<="), pattern, index, atlas)
#				if currNode.get_child_node("=") != null:
#					get_atlas_(currNode.get_child_node("="), pattern, index, atlas)
#			_:
#				print("Error: unknown pattern type: " + pattern[index])
