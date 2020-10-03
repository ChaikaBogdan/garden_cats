extends Node2D
var allowed = ['SELECTED','WALK','GONE']
signal gone
var alert_label
func init(node):
	node.get_node("AnimatedSprite").play("plant_"+node.COLOR)
	node.get_node("AudioPlanting").play()
	node.get_node("AudioPurring").stop()
	#yield(get_node("AnimatedSprite"), "animation_finished")
	var time = choose([5,7])
	$Timer.wait_time = time
	$Timer.start()
	#node.get_node("AnimatedSprite").modulate = node.COLOR
	
func choose(arr): 
	arr.shuffle()
	return arr.front()

func handle_process(node,delta):
	if $Timer.time_left<=4:
		node.get_node("AnimatedSprite").play("plant_warning_"+node.COLOR)
		
	
func _on_Timer_timeout():
	$Timer.stop()
	emit_signal("gone")
	
	

