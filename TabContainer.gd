extends TabContainer

onready var object_cursor = get_node("/root/main/Editor_Object")

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("toggle_editor"):
		if(!Global.filesystem_shown):
			Global.playing = !Global.playing
			visible = !Global.playing

func _on_TabContainer_mouse_entered():
	object_cursor.can_place = false
	object_cursor.hide()
	pass # Replace with function body.

func _on_TabContainer_mouse_exited():
	object_cursor.can_place = true
	object_cursor.show()
	pass # Replace with function body.
