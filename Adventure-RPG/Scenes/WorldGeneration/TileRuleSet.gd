class_name TileRuleSet

var root_node : RuleSetNode

func _init():
	root_node = RuleSetNode.new()

func add_branch(pattern : Array[String], atlas_vectors : Array[Vector2i]) -> void:
	var curr_node : RuleSetNode = root_node
	for node_type in pattern:
		# iterate through the pattern
		if curr_node.get_child_node(node_type) == null:
			# need to make new node for branch
			var child_node := RuleSetNode.new()
			if node_type == pattern.back():
				# need to give this last child the atlas_vectors
				child_node.set_atlas_vectors(atlas_vectors)
			# assign child node to continue building new branch
			curr_node.set_child_node(node_type, child_node)
		# child is not null so proceed down branch
		curr_node = curr_node.get_child_node(node_type)

func get_atlas(pattern : Array[String]) -> Array[Vector2i]:
	var atlas : Array[Vector2i]
	get_atlas_(root_node, pattern, 0, atlas)
	
	return curr_node.get_atlas_vectors()

func get_atlas_(currNode : RuleSetNode, pattern : Array[String], index : int, atlas : Array[Vector2i]):
	if currNode.get_atlas_vectors().size() > 0:
		# we must be at the end of the pattern
		atlas = currNode.get_atlas_vectors()
	else:
		# we are not at the end of the pattern
		match pattern[index]:
			">":
				if currNode.get_child_node(">=") != null:
					index += 1
					GetAtlasCoords_(currNode.get_child_node(">="), pattern, index)
				if currNode.get_child_node("<>") != null:
					index += 1
					GetAtlasCoords_(currNode.get_child_node("<>"), pattern, index)
			"<":
				if currNode.get_child_node("<=") != null:
					index += 1
					GetAtlasCoords_(currNode.get_child_node("<="), pattern, index)
				if currNode.get_child_node("<") != null:
					index += 1
					GetAtlasCoords_(currNode.get_child_node("<"), pattern, index)
				if currNode.get_child_node("<>") != null:
					index += 1
					GetAtlasCoords_(currNode.get_child_node("<>"), pattern, index)
			"=":
				if currNode.get_child_node(">=") != null:
					index += 1
					GetAtlasCoords_(currNode.get_child_node(">="), pattern, index)
				if currNode.get_child_node("<=") != null:
					index += 1
					GetAtlasCoords_(currNode.get_child_node("<="), pattern, index)
				if currNode.get_child_node("=") != null:
					index += 1
					GetAtlasCoords_(currNode.get_child_node("="), pattern, index)
			_:
				print("Error: unknown pattern type: " + pattern[index])
