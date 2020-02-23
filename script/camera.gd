extends Camera

func _process(delta):
	get_tree().call_group("mirrors", "update_cam", global_transform);
	get_node("../Viewport").size = get_viewport().size;
