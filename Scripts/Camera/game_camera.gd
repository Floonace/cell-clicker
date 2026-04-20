extends Camera2D

const SPEED:int = 3

var canDrag:bool = true


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	global_position += Vector2(Input.get_action_raw_strength("d") - Input.get_action_raw_strength("a"), Input.get_action_raw_strength("s") - Input.get_action_raw_strength("w")) * 5 
	if Input.is_action_just_pressed("scroll_up"):
		zoom += Vector2(0.1, 0.1)
	if Input.is_action_just_pressed("scroll_down"):
		zoom -= Vector2(0.1, 0.1)
			
	#if Input.is_action_pressed("left_click") and canDrag:
	#	global_position = global_position.lerp(get_global_mouse_position(), SPEED*delta)
