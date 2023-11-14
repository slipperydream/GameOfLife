extends Control

signal start
signal stop
signal reset
signal randomize

# add grid size control 
# add selectable grids

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_reset_button_3_pressed():
	reset.emit()


func _on_stop_button_pressed():
	stop.emit()


func _on_start_button_pressed():
	start.emit()


func _on_randomize_button_4_pressed():
	randomize.emit()
