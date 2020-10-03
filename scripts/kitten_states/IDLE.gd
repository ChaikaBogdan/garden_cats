extends Node2D
var allowed = ['WALK','PLANT','SELECTED','PURRING']
func init(node):
	#Input.set_default_cursor_shape()
	#node.get_node("AnimatedSprite").material.set_shader_param("visible",false)
	node.get_node("AnimatedSprite").play("idle_"+node.COLOR)

