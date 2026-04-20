extends Node

var cut = preload("res://Scenes/Cell/cut.tscn")

var cutStarted:bool = false

func _process(delta: float) -> void:
	#print(len(get_tree().get_nodes_in_group("Cells")))
	if len(get_tree().get_nodes_in_group("Cells")) >= 100 and not cutStarted:
		$CutTimer/CutStarterTimer.start()
		cutStarted = true
	elif len(get_tree().get_nodes_in_group("Cells")) == 0 and $"/root/Globals".energy <= 0:
		get_tree().quit()

func _on_food_timer_timeout() -> void:
	var cells = get_tree().get_nodes_in_group("Cells")
	var totalCells:int = cells.size()
	
	if totalCells > $"/root/Globals".energy:
		var cellsToDie:int = totalCells - $"/root/Globals".energy
		cells.shuffle()
		
		for i in range(cellsToDie):
			cells[i].die()
		
		$"/root/Globals".energy = 0
	else:
		$"/root/Globals".energy -= totalCells


func _on_mitochondria_timer_timeout() -> void:
	$"/root/Globals".energy += (1 + int($"/root/Globals".energy_bonus / 2)) * $"/root/Globals".mitochondria 


func _on_virus_timer_timeout() -> void:
	randomize()
	get_tree().get_nodes_in_group("Cells").pick_random().add_virus()

func spawn_cut() -> void:
	randomize()
	var new_cut = cut.instantiate()
	get_parent().add_child(new_cut)
	var cell = get_tree().get_nodes_in_group("Cells").pick_random()
	new_cut.global_position = cell.global_position
	new_cut.rotation = randi_range(0, 360)

func _on_cut_timer_timeout() -> void:
	spawn_cut()


func _on_virus_starter_timer_timeout() -> void:
	$VirusTimer.start()


func _on_cut_starter_timer_timeout() -> void:
	spawn_cut()
	$CutTimer.start()

var cell = preload("res://Scenes/Cell/cell.tscn")

func spawn_cell(pos):
	var new_cell = cell.instantiate()
	get_parent().add_child(new_cell)
	new_cell.global_position = pos
	new_cell.firstPos = pos
	$"/root/Globals".cell_positions.append(pos)
