extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("born")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Area2D2.get_overlapping_bodies():
		for body in $Area2D2.get_overlapping_bodies():
			body.die(30.0)
	if $Area2D.get_overlapping_bodies():
		#print(len($Area2D.get_overlapping_bodies()))
		for body in $Area2D.get_overlapping_bodies():
			var rand:int = randi_range(0, 1)
			if rand == 1 and body.virus == 0:
				var new_rand:int = randi_range(0, 1)
				if new_rand == 0:
					body.add_virus()
				else:
					body.add_poison()

func _on_timer_timeout() -> void:
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	queue_free()
