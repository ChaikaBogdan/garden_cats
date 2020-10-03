extends Node2D

var allowed = ['PLANT','IDLE','SELECTED','WALK','PURRING']
var path = []
var path_index = 0
var color = null

func init(node):
	#if not node.visible:
	#	node._on_kitten_runaway()
	#	node.show()
	
	var dest_y = node.rng.randi_range(50, 1050)
	var dest_x = node.rng.randi_range(50, 1880)
	clear_path()
	path = node.navigation.get_simple_path(node.position,Vector2(dest_x,dest_y))
	#color = node.COLOR
	node.get_node("AudioPurring").stop()
	#update()

func _draw():
	return
	for i in range(path.size()):
		draw_circle(path[i],5,Color.black)
		if i < path.size() -1:
			draw_line(path[i], path[i+1], Color.black, 1)

func calculate_direction(radians):
	var deg = rad2deg(radians)
	var deg_str = str(deg)
	if deg <= -90 and deg >= -180:
		return "up_left"
	elif deg >= -90 and deg <= 0:
		return "down_left"
	elif deg >= 90 and deg <=180:
		return "up_right"	
	elif (deg >= 0 and deg <= 90):
		return "down_right"
	print ("ANOMALY!: ",deg_str)
	return deg_str
		
	
	
		
func handle_physics_process(node,delta):
	var distance_to_walk = node.WALK_SPEED * delta
	if not(distance_to_walk > 0 and path.size() > 0):
		clear_path()
		return "IDLE"
	var target = path[path_index]
	var distance_to_next_point = node.position.distance_to(target)
	if distance_to_walk >= distance_to_next_point:
		path_index +=1
		if path_index >= path.size():
			clear_path()
			if node.at_bridge:
				return "IDLE"
			else:
				return 'PLANT'
	var velocity = (target - node.position).normalized() * node.WALK_SPEED 
	
	var result = node.move_and_slide(velocity)
	#for i in node.get_slide_count():
	#	var collision = node.get_slide_collision(i)
	#	print("I collided with ", collision.collider.name)
	var direction = calculate_direction(result.angle_to(Vector2(0,1)))
	
	match direction:
		'up_left':
			node.get_node("AnimatedSprite").play("walk_up_left_"+node.COLOR)
		"down_left":
			node.get_node("AnimatedSprite").play("walk_down_left_"+node.COLOR)
		"up_right":
			node.get_node("AnimatedSprite").play("walk_up_right_"+node.COLOR)
		"down_right":
			node.get_node("AnimatedSprite").play("walk_down_right_"+node.COLOR)
		_:
			print(direction)
		


	#for redraw
	#node.get_node("debug").text=direction
	#update()

func clear_path():
	path = []
	path_index = 0
	
