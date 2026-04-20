extends TextureRect

@export var component:String = "O"

func _get_drag_data(at_position: Vector2) -> Variant:
	if $"/root/Globals".components[component] <= 0:
		return null
	else:
		var data = {
			"name": component,
			"texture": texture
		}
		
		var preview_texture:TextureRect = TextureRect.new()
		preview_texture.texture = texture
		preview_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		preview_texture.custom_minimum_size = size
		preview_texture.modulate = Color(1, 1, 1, 0.6)
		
		var control = Control.new()
		preview_texture.position = -size / 2.0
		control.add_child(preview_texture)
		
		set_drag_preview(control)
		
		return data
