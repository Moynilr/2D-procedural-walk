extends VBoxContainer


func _on_speed_min_slider_value_changed(value: float) -> void:
	$speedMin.text = "Speed  " + str(value)
	get_tree().call_group("ui_set", "ui_set", "speed", value) 
