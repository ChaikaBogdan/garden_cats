extends Node2D
var allowed = ['SELECTED','IDLE',"WALK"]
func init(node):
	#node.get_node("AnimatedSprite").material.set_shader_param("visible",true)
	node.get_node("AnimatedSprite").play("selected_"+node.COLOR)
	#node.get_node("AudioMeow").play()
	#node.get_node("AudioPurring").play()
	#Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
