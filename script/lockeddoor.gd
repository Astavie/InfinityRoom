extends "res://script/selectable.gd"

var timer = 0;
var stage = 0;

export(NodePath) var player;

func select():
	if get_node(player).global_transform.origin.z < global_transform.origin.z:
		get_node("Locked").play();
		timer = 1;
	else:
		get_node("Open").play();
		stage = 1;

func _process(delta):
	if stage == 0:
		if timer > 0:
			timer -= delta;
			if timer <= 0:
				timer = 0;
	elif stage == 1:
		if rotation.y > -PI / 2:
			rotation.y -= PI / 100;
		if get_node(player).global_transform.origin.z < 6:
			stage = 2;
			timer = 0.5;
	elif stage == 2:
		if timer > 0:
			timer -= delta;
			rotation.y += ((PI / 2) * delta) * 2;
			if timer <= 0:
				get_node(player).get_node("Music").stop();
				get_node("Open").play();
				timer = 1.5;
				stage = 3;
	elif stage == 3:
		if timer > 0:
			timer -= delta;
			if timer <= 0:
				get_tree().change_scene("res://scene/End.tscn");

func can_select():
	return timer == 0 and stage == 0;
