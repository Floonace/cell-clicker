extends CanvasLayer

var tutorial_level = 1

func buy_components(name:String) -> void:
	if $"/root/Globals".energy >= 500:
		if not $AudioStreamPlayer2.playing:
			$AudioStreamPlayer2.play()
		$"/root/Globals".energy -= 500
		$"/root/Globals".components[name] += 1

func buy_sunbath(energy:String, energy_bonus:int, path) -> void:
	if $"/root/Globals".energy >= $"/root/Globals".sb[energy]:
		if not $AudioStreamPlayer2.playing:
			$AudioStreamPlayer2.play()
		$"/root/Globals".energy -= $"/root/Globals".sb[energy]
		$"/root/Globals".energy_bonus += energy_bonus
		$"/root/Globals".sb[energy] += int($"/root/Globals".sb[energy] * 1.15)
		if path:
			path.disabled = false

func buy_formulas(energy:int, name:String, path) -> void:
	if $"/root/Globals".energy >= energy:
		if not $AudioStreamPlayer2.playing:
			$AudioStreamPlayer2.play()
		$"/root/Globals".energy -= energy
		$"/root/Globals".formulas.append(name)
		path.disabled = true
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.time_scale = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$UI/Label.text = "Energy: "+str($"/root/Globals".energy)
	$UI/BG/ScrollContainer/VBoxContainer/SunbathingLv1.text = "Sunbathing Lv1 (+2)\n"+"("+str($"/root/Globals".sb["1"])+" Energy)"
	$UI/BG/ScrollContainer/VBoxContainer/SunbathingLv2.text = "Sunbathing Lv2 (+5)\n"+"("+str($"/root/Globals".sb["2"])+" Energy)"
	$UI/BG/ScrollContainer/VBoxContainer/SunbathingLv3.text = "Sunbathing Lv3 (+20)\n"+"("+str($"/root/Globals".sb["3"])+" Energy)"
	$UI/BG/ScrollContainer/VBoxContainer/SunbathingLv4.text = "Sunbathing Lv4 (+75)\n"+"("+str($"/root/Globals".sb["4"])+" Energy)"
	$UI/BG/ScrollContainer/VBoxContainer/SunbathingLv5.text = "Sunbathing Lv5 (+150)\n"+"("+str($"/root/Globals".sb["5"])+" Energy)"
	$UI/BG/Button.disabled = not $"/root/Globals".canCraft
	$UI/CraftScreen/ScrollContainer/VBoxContainer/VEGFButton.disabled = !$"/root/Globals".formulas.has("VEGF")
	$UI/CraftScreen/ScrollContainer/VBoxContainer/GlucagonButton2.disabled = !$"/root/Globals".formulas.has("Glucagon")
	$UI/CraftScreen/ScrollContainer/VBoxContainer/InterferonButton3.disabled = !$"/root/Globals".formulas.has("Interferon")
	$UI/CraftScreen/ScrollContainer/VBoxContainer/HistamineButton4.disabled = !$"/root/Globals".formulas.has("Histamine")
	$UI/CraftScreen/ScrollContainer/VBoxContainer/TNFAButton5.disabled = !$"/root/Globals".formulas.has("TNF-alpha")
	$UI/CraftScreen/ScrollContainer/VBoxContainer/InsulinButton6.disabled = !$"/root/Globals".formulas.has("Insulin")
	$UI/CraftScreen/ScrollContainer2/HBoxContainer/O/Amount.text = "x"+str($"/root/Globals".components["O"])
	$UI/CraftScreen/ScrollContainer2/HBoxContainer/NH/Amount.text = "x"+str($"/root/Globals".components["NH"])
	$UI/CraftScreen/ScrollContainer2/HBoxContainer/CR3/Amount.text = "x"+str($"/root/Globals".components["CR3"])
	$UI/CraftScreen/ScrollContainer2/HBoxContainer/N/Amount.text = "x"+str($"/root/Globals".components["N"])
	$UI/CraftScreen/ScrollContainer2/HBoxContainer/OH/Amount.text = "x"+str($"/root/Globals".components["OH"])
	$UI/CraftScreen/ScrollContainer2/HBoxContainer/F/Amount.text = "x"+str($"/root/Globals".components["F"])
	$UI/CraftScreen/ScrollContainer2/HBoxContainer/HN/Amount.text = "x"+str($"/root/Globals".components["HN"])
	$UI/CraftScreen/ScrollContainer2/HBoxContainer/CH3/Amount.text = "x"+str($"/root/Globals".components["CH3"])
	$UI/CraftScreen/ScrollContainer2/HBoxContainer/S/Amount.text = "x"+str($"/root/Globals".components["S"])
	$UI/CraftScreen/ScrollContainer2/HBoxContainer/NH2/Amount.text = "x"+str($"/root/Globals".components["NH2"])
	$UI/CraftScreen/ScrollContainer2/HBoxContainer/CL/Amount.text = "x"+str($"/root/Globals".components["CL"])
	$UI/CraftScreen/ScrollContainer2/HBoxContainer/F3C/Amount.text = "x"+str($"/root/Globals".components["F3C"])
	if Input.is_action_just_pressed("z"):
		$"/root/Globals".energy += 100_000
	if Input.is_action_just_pressed("ui_accept"):
		if $Tutorial.visible and tutorial_level == 1:
			tutorial_level = 2
			$Tutorial/Label1.hide()
			$Tutorial/Label2.hide()
			$Tutorial/Label3.hide()
			$Tutorial/Label4.hide()
			$Tutorial/Label5.hide()
			$Tutorial/Label6.hide()
			$UI/CraftScreen.show()
			$Tutorial/Label7.show()
			$Tutorial/Label8.show()
			$Tutorial/Label9.show()
			$Tutorial/Label10.show()
		else:
			$UI/CraftScreen.hide()
			$Tutorial/Label7.hide()
			$Tutorial/Label8.hide()
			$Tutorial/Label9.hide()
			$Tutorial/Label10.hide()
			$Tutorial.hide()
			Engine.time_scale = 1.0

func _on_sun_pressed() -> void:
	$"/root/Globals".energy += 1 + $"/root/Globals".energy_bonus
	$AudioStreamPlayer.play()
	$AnimationPlayer.stop()
	$AnimationPlayer.play("click")

func _on_mitochondria_pressed() -> void:
	if not $AudioStreamPlayer2.playing:
			$AudioStreamPlayer2.play()
	if $"/root/Globals".energy >= $"/root/Globals".mitochondriaPrice and $"/root/Globals".mitochondria != 10:
		$"/root/Globals".energy -= $"/root/Globals".mitochondriaPrice
		$"/root/Globals".mitochondriaPrice *= 2
		$"/root/Globals".mitochondria += 1
	$UI/BG/ScrollContainer/VBoxContainer/Mitochondria.text = "Mitochondria ("+str($"/root/Globals".mitochondria)+"/10)\n("+str($"/root/Globals".mitochondriaPrice)+" Energy)"

func _on_sunbathing_lv_1_pressed() -> void:
	buy_sunbath("1", 2, $UI/BG/ScrollContainer/VBoxContainer/SunbathingLv2)
func _on_sunbathing_lv_2_pressed() -> void:
	buy_sunbath("2", 5, $UI/BG/ScrollContainer/VBoxContainer/SunbathingLv3)
func _on_sunbathing_lv_3_pressed() -> void:
	buy_sunbath("3", 20, $UI/BG/ScrollContainer/VBoxContainer/SunbathingLv4)
func _on_sunbathing_lv_4_pressed() -> void:
	buy_sunbath("4", 75, $UI/BG/ScrollContainer/VBoxContainer/SunbathingLv5)
func _on_sunbathing_lv_5_pressed() -> void:
	buy_sunbath("5", 250, null)

func _on_veg_fformula_pressed() -> void:
	buy_formulas(10_000, "VEGF", $UI/BG/ScrollContainer/VBoxContainer/VEGFformula)
func _on_glucagon_formula_pressed() -> void:
	buy_formulas(10_000, "Glucagon", $UI/BG/ScrollContainer/VBoxContainer/GlucagonFormula)
func _on_interferon_formula_pressed() -> void:
	buy_formulas(10_000, "Interferon", $UI/BG/ScrollContainer/VBoxContainer/InterferonFormula)
func _on_histamine_formula_pressed() -> void:
	buy_formulas(10_000, "Histamine", $UI/BG/ScrollContainer/VBoxContainer/HistamineFormula)
func _on_tn_falpha_formula_pressed() -> void:
	buy_formulas(10_000, "TNF-alpha", $"UI/BG/ScrollContainer/VBoxContainer/TNF-alphaFormula")
func _on_insulin_formula_pressed() -> void:
	buy_formulas(10_000, "Insulin", $UI/BG/ScrollContainer/VBoxContainer/InsulinFormula)

func _on_o_pressed() -> void:
	buy_components("O")
func _on_nh_pressed() -> void:
	buy_components("NH")
func _on_cr_3_pressed() -> void:
	buy_components("CR3")
func _on_n_pressed() -> void:
	buy_components("N")
func _on_oh_pressed() -> void:
	buy_components("OH")
func _on_f_pressed() -> void:
	buy_components("F")
func _on_hn_pressed() -> void:
	buy_components("HN")
func _on_ch_3_pressed() -> void:
	buy_components("CH3")
func _on_s_pressed() -> void:
	buy_components("S")
func _on_nh_2_pressed() -> void:
	buy_components("NH2")
func _on_cl_pressed() -> void:
	buy_components("CL")
func _on_f_3c_pressed() -> void:
	buy_components("F3C")


func _on_button_pressed() -> void:
	$UI/CraftScreen.visible = true
	Engine.time_scale = 0.05


func _on_exit_button_pressed() -> void:
	$UI/CraftScreen.visible = false
	Engine.time_scale = 1.0

func reset(name:String):
	$UI/CraftScreen.visible = false
	Engine.time_scale = 1.0
	var x:PackedScene = preload("res://Scenes/Signal/ao_e.tscn")
	var y = x.instantiate()
	y.type = name
	get_tree().get_first_node_in_group("Level").add_child(y)

func error():
	pass

func _on_craft_button_pressed() -> void:
	if $UI/CraftScreen/InsulinFormula.visible:
		if $UI/CraftScreen/InsulinFormula/O_1.is_full and \
		$UI/CraftScreen/InsulinFormula/O_2.is_full and \
		$UI/CraftScreen/InsulinFormula/OH_1.is_full:
			reset("Insulin")
			for slot in $UI/CraftScreen/InsulinFormula.get_children():
				if slot is TextureRect and "is_full" in slot:
					slot.is_full = false
					slot.texture = null
		else:
			error()
	if $UI/CraftScreen/VEGFFormula.visible:
		if $UI/CraftScreen/VEGFFormula/O_1.is_full and \
		$UI/CraftScreen/VEGFFormula/N_1.is_full and \
		$UI/CraftScreen/VEGFFormula/CR3_1.is_full and \
		$UI/CraftScreen/VEGFFormula/HN_1.is_full and \
		$UI/CraftScreen/VEGFFormula/NH_1.is_full:
			reset("VEGF")
			for slot in $UI/CraftScreen/VEGFFormula.get_children():
				if slot is TextureRect and "is_full" in slot:
					slot.is_full = false
					slot.texture = null
		else:
			error()
	if $UI/CraftScreen/GlucagonFormula.visible:
		if $UI/CraftScreen/GlucagonFormula/F_1.is_full and \
		$UI/CraftScreen/GlucagonFormula/N_1.is_full and \
		$UI/CraftScreen/GlucagonFormula/OH_1.is_full and \
		$UI/CraftScreen/GlucagonFormula/HN_1.is_full:
			reset("Glucagon")
			for slot in $UI/CraftScreen/GlucagonFormula.get_children():
				if slot is TextureRect and "is_full" in slot:
					slot.is_full = false
					slot.texture = null
		else:
			error()
	if $UI/CraftScreen/InterferonFormula.visible:
		if $UI/CraftScreen/InterferonFormula/S_1.is_full and \
		$UI/CraftScreen/InterferonFormula/CH3_1.is_full and \
		$UI/CraftScreen/InterferonFormula/HN_1.is_full:
			reset("Interferon")
			for slot in $UI/CraftScreen/InterferonFormula.get_children():
				if slot is TextureRect and "is_full" in slot:
					slot.is_full = false
					slot.texture = null
		else:
			error()
	if $UI/CraftScreen/HistamineFormula.visible:
		if $UI/CraftScreen/HistamineFormula/N_1.is_full and \
		$UI/CraftScreen/HistamineFormula/NH2_1.is_full and \
		$UI/CraftScreen/HistamineFormula/HN_1.is_full:
			reset("Histamine")
			for slot in $UI/CraftScreen/HistamineFormula.get_children():
				if slot is TextureRect and "is_full" in slot:
					slot.is_full = false
					slot.texture = null
		else:
			error()
	if $UI/CraftScreen/TNFAFormula.visible:
		if $UI/CraftScreen/TNFAFormula/N_1.is_full and \
		$UI/CraftScreen/TNFAFormula/N_2.is_full and \
		$UI/CraftScreen/TNFAFormula/S_1.is_full and \
		$UI/CraftScreen/TNFAFormula/F3C_1.is_full and \
		$UI/CraftScreen/TNFAFormula/CL_1.is_full:
			reset("TNF-alpha")
			for slot in $UI/CraftScreen/TNFAFormula.get_children():
				if slot is TextureRect and "is_full" in slot:
					slot.is_full = false
					slot.texture = null
		else:
			error()


func _on_vegf_button_pressed() -> void:
	if "VEGF" in $"/root/Globals".formulas:
		$UI/CraftScreen/VEGFFormula.show()
		
		$UI/CraftScreen/InsulinFormula.hide()
		$UI/CraftScreen/GlucagonFormula.hide()
		$UI/CraftScreen/InterferonFormula.hide()
		$UI/CraftScreen/HistamineFormula.hide()
		$UI/CraftScreen/TNFAFormula.hide()


func _on_insulin_button_6_pressed() -> void:
	if "Insulin" in $"/root/Globals".formulas:
		$UI/CraftScreen/InsulinFormula.show()
		
		$UI/CraftScreen/VEGFFormula.hide()
		$UI/CraftScreen/GlucagonFormula.hide()
		$UI/CraftScreen/InterferonFormula.hide()
		$UI/CraftScreen/HistamineFormula.hide()
		$UI/CraftScreen/TNFAFormula.hide()


func _on_glucagon_button_2_pressed() -> void:
	$UI/CraftScreen/GlucagonFormula.show()
		
	$UI/CraftScreen/InsulinFormula.hide()
	$UI/CraftScreen/VEGFFormula.hide()
	$UI/CraftScreen/InterferonFormula.hide()
	$UI/CraftScreen/HistamineFormula.hide()
	$UI/CraftScreen/TNFAFormula.hide()


func _on_interferon_button_3_pressed() -> void:
	$UI/CraftScreen/InterferonFormula.show()
		
	$UI/CraftScreen/InsulinFormula.hide()
	$UI/CraftScreen/VEGFFormula.hide()
	$UI/CraftScreen/GlucagonFormula.hide()
	$UI/CraftScreen/HistamineFormula.hide()
	$UI/CraftScreen/TNFAFormula.hide()


func _on_histamine_button_4_pressed() -> void:
	$UI/CraftScreen/HistamineFormula.show()
		
	$UI/CraftScreen/InsulinFormula.hide()
	$UI/CraftScreen/VEGFFormula.hide()
	$UI/CraftScreen/GlucagonFormula.hide()
	$UI/CraftScreen/InterferonFormula.hide()
	$UI/CraftScreen/TNFAFormula.hide()


func _on_tnfa_button_5_pressed() -> void:
	$UI/CraftScreen/TNFAFormula.show()
		
	$UI/CraftScreen/InsulinFormula.hide()
	$UI/CraftScreen/VEGFFormula.hide()
	$UI/CraftScreen/GlucagonFormula.hide()
	$UI/CraftScreen/InterferonFormula.hide()
	$UI/CraftScreen/HistamineFormula.hide()
