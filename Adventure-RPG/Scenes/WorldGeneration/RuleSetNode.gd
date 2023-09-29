class_name RuleSetNode

var atlas_vectors : Array[Vector2i]
var less_greater_node : RuleSetNode
var greater_equal_node : RuleSetNode
var less_equal_node : RuleSetNode
var equal_node : RuleSetNode
var less_node : RuleSetNode
var any_node : RuleSetNode

func _init():
	atlas_vectors = []
	less_greater_node = null
	greater_equal_node = null
	less_equal_node = null
	equal_node = null
	less_node = null
	any_node = null
	
func set_atlas_vectors(vectors : Array[Vector2i]) -> void:
	atlas_vectors = vectors

func get_atlas_vectors() -> Array[Vector2i]:
	return atlas_vectors

func set_child_node(node_type : String, node : RuleSetNode) -> void:
	match node_type:
		"<>":
			less_greater_node = node
		">=":
			greater_equal_node = node
		"<=":
			less_equal_node = node
		"=":
			equal_node = node
		"<":
			less_node = node
		"_":
			any_node = node
		_:
			print("Set Error: unknown node_type: " + node_type)

func get_child_node(node_type) -> RuleSetNode:
	match node_type:
		"<>":
			return less_greater_node
		">=":
			return greater_equal_node
		"<=":
			return less_equal_node
		"=":
			return equal_node
		"<":
			return less_node
		"_":
			return any_node
		_:
			print("Get Error: unknown node_type: " + node_type)
			return null
