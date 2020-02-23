extends KinematicBody

const SelectableClass = preload("res://script/selectable.gd");

var rotation_helper;
var camera;
var viewport_camera;

var MOUSE_SENSITIVITY = 0.15;
var MOVEMENT_SPEED = 4;
var SPRINT_MODIFIER = 2;

var RAY_LENGTH = 3;

var click = false;

export(NodePath) var lmb;
export(NodePath) var world;

var step = 0;
var STEP_SIZE = 200;

var canmove = false;
var play = false;
var time = 3;

func _ready():
	get_node(world).visible = false;
	
	add_to_group("mirrors");
	rotation_helper = $RotationHelper;
	camera = $RotationHelper/Camera;
	viewport_camera = $RotationHelper/Viewport/Camera;
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

func update_cam(main_cam_transform):
	viewport_camera.global_transform = main_cam_transform;

func _physics_process(delta):
	if time > 0:
		time -= delta;
		if time <= 2 and not canmove:
			canmove = true;
			get_node(world).visible = true;
			get_node("Switch").play();
	elif not play:
		get_node("Music").play();
		play = true;
	
	if not canmove:
		return;
	
	# Move
	var cam_xform = camera.get_global_transform();
	
	var dir = Vector3();
	
	if Input.is_action_pressed("movement_forward"):
		dir -= cam_xform.basis.z;
	if Input.is_action_pressed("movement_backward"):
		dir += cam_xform.basis.z;
	if Input.is_action_pressed("movement_left"):
		dir -= cam_xform.basis.x;
	if Input.is_action_pressed("movement_right"):
		dir += cam_xform.basis.x;
	
	dir.y = 0;
	
	if Input.is_action_just_pressed("sprint"):
		step = STEP_SIZE;
	
	if dir.length_squared() > 0:
		dir = dir.normalized();
		
		if Input.is_action_pressed("sprint"):
			dir *= SPRINT_MODIFIER;
		
		var move = move_and_slide(dir * MOVEMENT_SPEED, Vector3(0, 1, 0));
		step += move.length();
	
		if (step > STEP_SIZE):
			step = 0;
			get_node("Footstep").play();
	else:
		step = STEP_SIZE;
	
	# Raycast
	var from = camera.project_ray_origin(get_viewport().size / 2);
	var to = from + camera.project_ray_normal(get_viewport().size / 2) * RAY_LENGTH;
	
	var space_state = get_world().direct_space_state;
	var result = space_state.intersect_ray(from, to);
	
	if result.has("collider") and result.collider is SelectableClass and result.collider.can_select():
		if click:
			get_node(lmb).visible = false;
			result.collider.select();
		else:
			get_node(lmb).visible = true;
	else:
		get_node(lmb).visible = false;
	
	click = false;

func _input(event):
	if not canmove:
		return;
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Look around
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1));
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1));
		
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot
	elif event.is_action_pressed("pause"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			# Pause
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
		else:
			# Unpause
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	elif event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		click = true;
