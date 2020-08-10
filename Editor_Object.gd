extends Node2D

var can_place = true;
var is_panning = true
var do_save = false

onready var level = get_node("/root/main/Level")
onready var editor = get_node("/root/main/cam_container")
onready var editor_cam = editor.get_node("Camera2D")

onready var popup : FileDialog = get_node("/root/main/Item_Select/FileDialog")

onready var tile_map : TileMap = level.get_node("TileMap")

var current_item #packed scene to plac

func _ready():
	editor_cam.current = true
	pass 

func _process(delta):
	print(do_save)
	global_position = get_global_mouse_position()
	
	if !Global.place_tile:
		if(!Global.filesystem_shown):
			if(current_item != null and can_place and Input.is_action_just_pressed("mb_left")):
				var new_item = current_item.instance()
				level.add_child(new_item)
				new_item.owner = level
				new_item.global_position = get_global_mouse_position()
	else:
		if(can_place):
			if(!Global.filesystem_shown):
				if Input.is_action_pressed("mb_left"):
					place_tile()
				if Input.is_action_pressed("mb_right"):
					delete_tile()
		
	move_editor()
	
	is_panning = Input.is_action_pressed("mb_middle")

	if Input.is_action_pressed("save"):
		Global.filesystem_shown = true
		popup.window_title = "Save Level"
		do_save = true
		popup.mode = 4
		popup.show()
	if Input.is_action_pressed("load"):
		Global.filesystem_shown = true
		popup.window_title = "Load Level"
		popup.mode = 0
		popup.show()
	pass

func save_level():
	var toSave : PackedScene = PackedScene.new()
	tile_map.owner = level
	toSave.pack(level)
	print(popup.current_path)
	ResourceSaver.save(popup.current_path,toSave)

func load_level():
	var toLoad : PackedScene = PackedScene.new()
	toLoad = ResourceLoader.load(popup.current_path)
	var this_level = toLoad.instance()
	get_parent().remove_child(level)
	level.queue_free()
	get_parent().add_child(this_level)
	tile_map = get_parent().get_node("Level/TileMap")
	level = this_level
	
func place_tile():
	var mousePosition = tile_map.world_to_map(get_global_mouse_position())
	tile_map.set_cell(mousePosition.x,mousePosition.y,Global.current_tile)
	pass
	
func delete_tile():
	var mousePosition = tile_map.world_to_map(get_global_mouse_position())
	tile_map.set_cell(mousePosition.x,mousePosition.y,-1)
	pass

func move_editor():
	if(!Global.filesystem_shown):
		if Input.is_action_pressed("w"):
			editor.global_position.y -= 10
		if Input.is_action_pressed("a"):
			editor.global_position.x -= 10
		if Input.is_action_pressed("s"):
			editor.global_position.y += 10
		if Input.is_action_pressed("d"):
			editor.global_position.x += 10
	pass
	
func _unhandled_input(event):
	if(!Global.filesystem_shown):
		if(event is InputEventMouseButton):
			if(event.is_pressed()):
				if(event.button_index == BUTTON_WHEEL_UP):
					editor_cam.zoom -= Vector2(0.1,0.1) 
				if(event.button_index == BUTTON_WHEEL_DOWN):
					editor_cam.zoom += Vector2(0.1,0.1) 
		if(event is InputEventMouseMotion):
			if(is_panning):
				editor.global_position -= event.relative * editor_cam.zoom
	pass
	
func save_button_pressed():
	popup.show()
	pass # Replace with function body.
	
func save_level_popup_confirmed():
	print(do_save)
	if popup.window_title == "Save a File":
		save_level()
	else:
		load_level()
	pass # Replace with function body.

func _on_FileDialog_hide():
	Global.filesystem_shown = false
	do_save = false
	pass # Replace with function body.
