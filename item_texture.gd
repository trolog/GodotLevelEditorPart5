extends TextureRect

export(PackedScene) var this_scene
onready var object_cursor = get_node("/root/main/Editor_Object")
onready var cursor_sprite = object_cursor.get_node("cursor")
export(bool) var tile = false;
export var tile_id = 0;

func _ready():
	connect("gui_input",self,"item_clicked")
	pass 

func _process(delta):
	
	pass

func item_clicked(event):
	if(event is InputEvent):
		if(event.is_action_pressed("mb_left")):
			if(!tile):
				object_cursor.current_item = this_scene
				cursor_sprite.texture = texture
				Global.place_tile = false
			else:
				Global.current_tile = tile_id
				print(Global.current_tile)
				Global.place_tile = true
				cursor_sprite.texture = null
	pass
