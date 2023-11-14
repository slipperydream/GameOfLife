extends Node2D

@export var grid_columns : int = 10
@export var grid_rows : int = 10
@onready var grid : Array
@onready var previous_grid : Array
@onready var cell_scene = preload("res://cell.tscn")
@export var cell_width = 128
@export var cell_height = 128
@export var edge_buffer = 64
@export var speed = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	reset_grid()
	randomize_grid()
	$Timer.wait_time = 1/speed

func randomize_grid():
	randomize()
	for i in range(grid_columns):
		for j in range(grid_rows): 
			if randi_range(0,1):
				grid[i][j].visible = false
			else:
				grid[i][j].visible = true

func reset_grid():
	for i in range(grid_columns):
		grid.append([])
		for j in range(grid_rows): 
			var cell = cell_scene.instantiate()
			cell.global_position = Vector2(edge_buffer + i * cell_width, edge_buffer+ j*cell_height)
			cell.visible = false
			add_child(cell)
			grid[i].append(cell)

func update_grid():
	previous_grid = grid
	for i in range(grid_columns):
		for j in range(grid_rows): 	
			var live_neighbors = get_live_neighbors(i, j)
			var cell = grid[i][j]
			if cell.visible:
				if live_neighbors < 2:
					cell.visible = false
				elif live_neighbors in range(2,3):
					cell.visible = true
				else:
					cell.visible = false
			else:
				if live_neighbors == 3:
					cell.visible = true
				else:
					cell.visible = false
							
func get_live_neighbors(col, row):
	var live_neighbors = 0
	var is_edge_cell = is_edge(col, row)
	if is_edge_cell:
		pass
	else:
		# to the left
		if previous_grid[col-1][row].visible:
			live_neighbors += 1
		# to the right
		if previous_grid[col+1][row].visible:
			live_neighbors += 1
		# above
		if previous_grid[col][row-1].visible:
			live_neighbors += 1
		# below
		if previous_grid[col][row+1].visible:
			live_neighbors += 1
		# northwest
		if previous_grid[col-1][row-1].visible:
			live_neighbors += 1
		# northeast
		if previous_grid[col+1][row-1].visible:
			live_neighbors += 1
		# southwest
		if previous_grid[col-1][row+1].visible:
			live_neighbors += 1
		# southeast
		if previous_grid[col+1][row+1].visible:
			live_neighbors += 1
	return live_neighbors
	
func is_edge(col, row):
	if col == 0 or col == grid_columns - 1:
		return true
	elif row == 0 or row == grid_rows - 1:
		return true
	else:
		return false
		

func _on_ui_start():
	$Timer.start()

func _on_timer_timeout():
	update_grid()
	$Timer.start()

func _on_ui_stop():
	$Timer.stop()

func _on_ui_reset():
	reset_grid()

func _on_ui_randomize():
	randomize_grid()
