extends Node2D
var allowed = []
func init(node):
	#node.get_node("AnimatedSprite").modulate = node.COLOR
	node.get_node("AnimatedSprite").play("gone_"+node.COLOR)
	node.emit_signal("kitten_gone",node)
