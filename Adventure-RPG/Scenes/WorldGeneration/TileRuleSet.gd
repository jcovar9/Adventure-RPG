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
	var current_branches : Array[RuleSetNode] = [root_node]
	for sub_pattern in pattern:
		# iterate through the pattern
		var next_branches : Array[RuleSetNode] = []
		for branch in current_branches:
			# iterate through the current branches that fit the pattern
			match sub_pattern:
				# if the branch has a child that fits the current pattern then add it
				">":
					if branch.get_child_node(">=") != null:
						next_branches.append(branch.get_child_node(">="))
					if branch.get_child_node("<>") != null:
						next_branches.append(branch.get_child_node("<>"))
					if branch.get_child_node("_") != null:
						next_branches.append(branch.get_child_node("_"))
				"<":
					if branch.get_child_node("<=") != null:
						next_branches.append(branch.get_child_node("<="))
					if branch.get_child_node("<") != null:
						next_branches.append(branch.get_child_node("<"))
					if branch.get_child_node("<>") != null:
						next_branches.append(branch.get_child_node("<>"))
					if branch.get_child_node("_") != null:
						next_branches.append(branch.get_child_node("_"))
				"=":
					if branch.get_child_node(">=") != null:
						next_branches.append(branch.get_child_node(">="))
					if branch.get_child_node("<=") != null:
						next_branches.append(branch.get_child_node("<="))
					if branch.get_child_node("=") != null:
						next_branches.append(branch.get_child_node("="))
					if branch.get_child_node("_") != null:
						next_branches.append(branch.get_child_node("_"))
				_:
					print("Error: unexpected pattern type: " + sub_pattern)
					return [Vector2i(-1,-1)]
		current_branches = next_branches
		if current_branches.size() == 0:
			# we have no branches that fit the pattern
			print("Error: atlas search stopped at sub_pattern: " + sub_pattern)
			return [Vector2i(-1,-1)]
	if current_branches.size() == 1:
		return current_branches[0].get_atlas_vectors()
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
