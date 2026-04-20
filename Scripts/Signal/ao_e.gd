extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"/root/Globals".canCraft = false

var effects:Dictionary = {
	"VEGF": ["imagepath", "VEGF"],
	"Glucagon": ["imagepath", "Glucagon"],
	"Interferon": ["imagepath", "Interferon"],
	"Histamine": ["imagepath", "Histamine"],
	"TNF-alpha": ["imagepath", "TNF-alpha"],
	"Insulin": ["imagepath", "Insulin"],
}
var size:Dictionary = {
	"VEGF": [150.0, Vector2(4.477, 4.643)],
	"Glucagon": [250.0, Vector2(7.392, 7.666)],
	"Interferon": [150.0, Vector2(4.477, 4.643)],
	"Histamine": [250.0, Vector2(7.392, 7.666)],
	"TNF-alpha": [150.0, Vector2(4.477, 4.643)],
	"Insulin": [100.03, Vector2(3.047, 3.16)],
}

var type:String

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if type:
		$Area2D/CollisionShape2D.shape.radius = size[type][0]
		$Area2D/Sprite2D.scale = size[type][1]
	global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("left_click") and type:
		for body in $Area2D.get_overlapping_bodies():
			body.do_effect(effects[type][1])
		$"/root/Globals".canCraft = true
		queue_free()
