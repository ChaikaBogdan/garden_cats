extends Node2D
var allowed = []
func init(node):
	#Input.set_default_cursor_shape()
	#node.get_node("AnimatedSprite").play("idle_"+node.COLOR)
	node.queue_free()
