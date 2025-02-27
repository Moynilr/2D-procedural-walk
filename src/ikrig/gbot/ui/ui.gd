extends VBoxContainer

func _on_step_size_x_slider_value_changed(value: float) -> void:
	$stepSize.text = "Step Size " + str(value)
	get_tree().call_group("ui_set", "ui_set", "step_size", value) 

func _on_speed_min_slider_value_changed(value: float) -> void:
	$speedMin.text = "Speed min " + str(value)
	get_tree().call_group("ui_set", "ui_set", "speed_min", value) 

func _on_speed_max_slider_value_changed(value: float) -> void:
	$speedMax.text = "Speed max " + str(value)
	get_tree().call_group("ui_set", "ui_set", "speed_max", value) 

func _on_foot_before_x_slider_value_changed(value: float) -> void:
	$footBefore_x.text = "Foot before x " + str(value)
	get_tree().call_group("ui_set", "ui_set", "offssetFootBefore.x", value) 

func _on_foot_before_y_slider_value_changed(value: float) -> void:
	$footBefore_y.text = "Foot before y " + str(value)
	get_tree().call_group("ui_set", "ui_set", "offssetFootBefore.y", value) 

func _on_is_speed_constant_toggled(toggled_on: bool) -> void:
	get_tree().call_group("ui_set", "ui_set", "is_speed_constant", toggled_on) 

func _on_opposite_pg_step_slider_value_changed(value: float) -> void:
	$oppositePgStep.text = "oppositePgStep " + str(value)
	get_tree().call_group("ui_set", "ui_set", "oppositePgStep", value) 

func _on_max_leg_height_slider_value_changed(value: float) -> void:
	$max_leg_height.text = "max leg height " + str(value)
	get_tree().call_group("ui_set", "ui_set", "max_leg_height", value) 

func _on_min_leg_height_slider_value_changed(value: float) -> void:
	$min_leg_height.text = "min leg height " + str(value)
	get_tree().call_group("ui_set", "ui_set", "min_leg_height", value) 

func _on_leg_offset_slider_value_changed(value: float) -> void:
	$leg_offset.text = "leg offset " + str(value)
	get_tree().call_group("ui_set", "ui_set", "leg_offset", value) 

func _on_arm_offset_slider_value_changed(value: float) -> void:
	$armOffset.text = "armOffset L " + str(value)
	get_tree().call_group("ui_set", "ui_set", "armOffset", value) 


func _on_walk_pressed() -> void:
	_on_step_size_x_slider_value_changed(210)
	_on_is_speed_constant_toggled(false)
	_on_speed_max_slider_value_changed(180)
	_on_opposite_pg_step_slider_value_changed(0.7)
	_on_min_leg_height_slider_value_changed(45)
	_on_leg_offset_slider_value_changed(81)
	_on_foot_before_y_slider_value_changed(-10)
	_on_arm_offset_slider_value_changed(40)
	get_tree().call_group("ui_set", "ui_set", "walk_run", true) 


func _on_run_pressed() -> void:
	_on_step_size_x_slider_value_changed(510)
	_on_speed_max_slider_value_changed(280)
	_on_is_speed_constant_toggled(true)
	_on_opposite_pg_step_slider_value_changed(0.8)
	_on_min_leg_height_slider_value_changed(45)
	_on_foot_before_y_slider_value_changed(-25)
	_on_leg_offset_slider_value_changed(81)
	_on_arm_offset_slider_value_changed(40)
	get_tree().call_group("ui_set", "ui_set", "walk_run", false) 
