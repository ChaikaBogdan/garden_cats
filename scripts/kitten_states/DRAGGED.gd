extends Node2D
var allowed = ['HOUSED','SELECTED']

func init(node):
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	node.get_node("AnimatedSprite").play("dragged_"+node.COLOR)
	node.get_node("AudioPurring").play()
	node.FORBIDEN = ["SELECTED"]
	node.z_index = 99
	Input.vibrate_handheld(50)

func handle_physics_process(node,_delta):
	node.position = get_global_mouse_position() + node.mouse_offset
	#Input.set_default_cursor_shape(Input.CURSOR_CAN_DRAG)
	if Input.is_action_just_released("mouse_left"):
		node.get_node("AudioPurring").stop()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		node.FORBIDEN = []
		node.z_index = 2
		if node.at_home:
			return "HOUSED"
		return "SELECTED"
	
		
