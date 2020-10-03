extends Node2D
var allowed = ['GAMEOVER','IDLE']
func init(node):
	#Input.set_default_cursor_shape()
	#node.hide()
	Input.vibrate_handheld(50)
	node.emit_signal("kitten_housed",node)
	node.get_node("AudioPurring").stop()
	return 'GAMEOVER'
	
	
