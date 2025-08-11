extends Control

onready var health_bar = get_node("ProgressBar")
onready var health_label = get_node("Label")

func update_health(current_health, max_health):
	health_bar.value = current_health
	health_bar.max_value = max_health
	health_label.text = "Health: " + str(current_health) + "/" + str(max_health)
	
	# Color del feedback
	if current_health < max_health * 0.3: # Menos del 30%
		health_bar.modulate = Color.red
	elif current_health < max_health * 0.6: # Menos del 60%
		health_bar.modulate = Color.yellow
	else:
		health_bar.modulate = Color.green
func _ready():
	# Make UI not block input
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Apply to all children too
	for child in get_children():
		if child is Control:
			child.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	print("UI nodes found:")
	print("ProgressBar: ", $ProgressBar)
	print("Label: ", $Label)
