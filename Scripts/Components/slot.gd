extends TextureRect

@export var component:String = "O"

var is_full:bool = false

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if typeof(data) != TYPE_DICTIONARY or not data.has("name"):
		return false
	
	if is_full:
		return false
	
	if data["name"] != component:
		return false
	
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	texture = data["texture"]
	is_full = true
	$"/root/Globals".components[component] = $"/root/Globals".components[component]-1

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_full:
			is_full = false
			texture = null
			$"/root/Globals".components[component] = $"/root/Globals".components[component]+1
