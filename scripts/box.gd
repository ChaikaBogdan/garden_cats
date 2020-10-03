extends KinematicBody2D
var speed = 600
var target = Vector2(990,560)
var velocity = Vector2()
signal landed
var falling = false
var in_box = 0
var gameover=false
func _ready():
	visible=false

func fall():
	$count.hide()
	$cat_in_box.hide()
	in_box = 0
	gameover=false
	$count.text="Saved: "+str(in_box)
	visible=true
	position.y-=800
	$AudioStreamPlayer2D.play()
	$AnimatedSprite.play('falling')
	$CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D.disabled = true
	falling = true
	
func _on_Area2D_body_entered(body):
	if body.has_method("arrive_home"):
		
		body.arrive_home()


func _on_Area2D_body_exited(body):
	if body.has_method("leave_home"):
		
		body.leave_home()
	


func _physics_process(delta):
	if falling == true:
		velocity = position.direction_to(target) * speed
		if position.distance_to(target) > 5:
			velocity = move_and_slide(velocity)
		else:
			$AnimatedSprite.play('idle')
			$CollisionShape2D.disabled = false
			$Area2D/CollisionShape2D.disabled = false
			falling = false
			$count.show()
			$AnimatedSprite.play("opening")
			yield(get_node("AnimatedSprite"), "animation_finished")
			emit_signal("landed")

func kitten_in_box():
	in_box+=1
	$count.text="Saved: "+str(in_box)
	

func _on_Area2D_mouse_exited():
	if gameover:
		return
	$AnimatedSprite.play('idle')
	$cat_in_box.hide()
	$count.show()
	z_index=3


func choose(arr): 
	arr.shuffle()
	return arr.front()
	
func _on_Area2D_mouse_entered():
	if gameover:
		return
	$AnimatedSprite.play('selected')
	
	#yield(get_node("AnimatedSprite"), "animation_finished")
	if in_box>0:
		$cat_in_box.show()
	$count.hide()
	z_index=1
