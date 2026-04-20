extends CharacterBody2D

@export var id:int = 0

var type:String = "normal"
var cell = preload("res://Scenes/Cell/cell.tscn")
var virus:int = 0
var firstPos

var has_vegf:bool = false
var has_interferon:bool = false
var has_histamine:bool = false
var has_tnfa:bool = false
var has_insulin:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	$ReproductionTimer.wait_time = randf_range(4.0, 6.0)
	$ReproductionTimer.start()
	if id == 100:
		firstPos = global_position
		$"/root/Globals".cell_positions.append(firstPos)
	await get_tree().create_timer(0.1).timeout
	$Sprite.show()
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("born")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("idle")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if type == "virus":
		$Virus1.show()

func _on_reproduction_timer_timeout() -> void:
	if len(get_tree().get_nodes_in_group("Cells")) != 250:
		var spawners:Array = []
		for s in [$Spawn1, $Spawn2, $Spawn3, $Spawn4, $Spawn5, $Spawn6]:
			if not s.global_position in $"/root/Globals".cell_positions:
				spawners.append(s)
		#if id == 100:
			#print(spawners)
		if !spawners.is_empty():
			var spawner:Area2D = spawners.pick_random()
			var new_cell = cell.instantiate()
			get_parent().add_child(new_cell)
			new_cell.global_position = spawner.global_position
			new_cell.firstPos = spawner.global_position
			$"/root/Globals".cell_positions.append(spawner.global_position)

func add_virus(fromCell:bool=false) -> void:
	if type == "normal" and not has_histamine:
		if has_interferon:
			has_interferon = false
		else:
			if fromCell:
				virus += 1
				if virus == 1: $Virus1.show()
				if virus == 2: $Virus2.show()
				if virus == 3: $Virus3.show()
			else:
				virus = 1
			type = "virus"
			$VirusTimer.start()

func add_poison() -> void:
	if type == "normal" and not has_histamine:
		$Sprite.texture = load("res://Graphics/Real/Cell/poisoncell.png")
		$PoisonTimer.start(5.0)
		type = "poison"

func cancer() -> void:
	if not has_vegf:
		type = "cancer"
		$Sprite.texture = load("res://Graphics/Real/Cell/cancer.png")
		$CancerTimer.start()
		$PoisonTimer.stop()
		$Mitochondria.hide()
		$VirusTimer.stop()
		$Virus1.hide()
		$Virus2.hide()
		$Virus3.hide()

func die(wt:float=5.0) -> void:
	$AudioStreamPlayer2.play()
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	hide()
	$ReproductionTimer.stop()
	set_process(false)
	if is_in_group("Cells"):
		remove_from_group("Cells")
	if not has_insulin:
		await get_tree().create_timer(wt).timeout
	var index = $"/root/Globals".cell_positions.find(firstPos)
	if index != -1:
		$"/root/Globals".cell_positions.remove_at(index)
	queue_free()
	get_parent().get_node("Game").spawn_cell(firstPos)


func _on_virus_timer_timeout() -> void:
	virus += 1
	if virus == 2: $Virus2.show()
	if virus == 3: $Virus3.show()
	if virus == 4:
		var spawners:Array = []
		for s in [$Spawn1, $Spawn2, $Spawn3, $Spawn4, $Spawn5, $Spawn6]:
			if not s.get_overlapping_bodies().is_empty():
				spawners.append(s)
		if not spawners.is_empty():
			$VirusTimer.stop()
			hide()
			while virus > 0:
				spawners.pick_random().get_overlapping_bodies()[0].add_virus(true)
				virus -= 1
		die(30.0)

func _on_poison_timer_timeout() -> void:
	var spawners:Array = []
	for s in [$Spawn1, $Spawn2, $Spawn3, $Spawn4, $Spawn5, $Spawn6]:
		if not s.get_overlapping_bodies().is_empty():
			spawners.append(s)
	if not spawners.is_empty():
		$PoisonTimer.stop()
		spawners.pick_random().get_overlapping_bodies()[0].add_poison()
	var p_rand = randi_range(0, 5)
	if p_rand == 1 and not has_tnfa and not has_vegf:
		cancer()
	else:
		die(30.0)


func _on_cancer_timer_timeout() -> void:
	var spawners:Array = []
	for s in [$Spawn1, $Spawn2, $Spawn3, $Spawn4, $Spawn5, $Spawn6]:
		if not s.get_overlapping_bodies().is_empty():
			spawners.append(s)
	if not spawners.is_empty():
		$PoisonTimer.stop()
		spawners.pick_random().get_overlapping_bodies()[0].cancer()


func _on_life_timer_timeout() -> void:
	if type == "cancer" and not has_tnfa and not has_vegf:
		if is_in_group("Cells"):
			remove_from_group("Cells")
	else:
		die()

func do_effect(name):
	if name == "VEGF":
		has_vegf = true
		if type == "cancer": die()
	elif name == "Glucagon": $"/root/Globals".energy += 5
	elif name == "Interferon": has_interferon = true
	elif name == "Histamine": has_histamine = true
	elif name == "TNF-alpha": 
		has_tnfa = true
		if type == "poison": die()
	elif name == "Insulin": has_insulin = true
