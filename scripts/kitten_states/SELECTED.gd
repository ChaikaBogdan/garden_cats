extends Node2D
var allowed = ['DRAGGED','IDLE']
func init(node):
	#node.get_node("AnimatedSprite").material.set_shader_param("visible",true)
	node.get_node("AnimatedSprite").play("selected_"+node.COLOR)
	node.get_node("AudioMeow").play()
	node.get_node("AudioPurring").play()
	
	#Input.set_default_cursor_shape(Input.CURSOR_CROSS)

func handle_physics_process(node,_delta):
	if Input.is_action_pressed("mouse_left"):
		node.mouse_offset = node.position - get_global_mouse_position()
		return 'DRAGGED'

	
