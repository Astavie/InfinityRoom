extends "res://script/selectable.gd"

var open = false;

func select():
	open = true;
	get_node("Opening").play();

func _process(delta):
	if open and rotation.y < PI / 2:
		rotation.y += PI / 100;

func can_select():
	return not open;
