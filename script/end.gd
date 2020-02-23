extends Node2D

var timer = 4;

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	get_node("Switch").play();

func _process(delta):
	if timer >= 2:
		timer -= delta;
		if timer < 2:
			get_node("Switch").play();
	else:
		timer -= delta;
	
	if timer < -2:
		get_node("Label2").visible = false;
	elif timer < 0:
		get_node("Label").visible = false;
		get_node("Label2").visible = true;
	elif timer < 2:
		get_node("Label").visible = true;
