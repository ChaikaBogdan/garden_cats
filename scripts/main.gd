extends Node2D


var path = []
var kitten_scene = preload("res://scenes/kitten.tscn")
const max_cats = 10
var cats_count = max_cats
var cats_on_level = max_cats
var selected = null
var cats = []
var flowers = []
onready var navigation = $Navigation2D


func _ready():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	hide_ui()
	init_kittens(max_cats)
	#init_flowers(10)
	get_tree().call_group("kittens", "menu")
	


func reset():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	reset_cats()
	reset_plants()
	randomize()
	cats_count = max_cats
	cats_on_level = max_cats
	init_kittens(cats_on_level)
	for k in cats:
		k.hide()
	#init_flowers(10)
	update_ui_counters()
	$box.fall()
	
func init_kittens(count):
	for id in range(count):
		launch_kitten(id)
	cats_count = count
	
	

func launch_kitten(id):
		var kitten = kitten_scene.instance()
		#absolute cat starting point
		kitten.init('kat' + str(id),$box.position+Vector2(0,0),navigation)
		add_child(kitten)
		kitten.connect("kitten_housed", self, "_on_kitten_housed")
		kitten.connect("kitten_selected", self, "_on_kitten_selected")
		kitten.connect("kitten_deselected", self, "_on_kitten_deselected")
		kitten.connect("kitten_runaway", self, "_on_kitten_runaway")
		kitten.connect("kitten_gone", self, "_on_kitten_gone")
		cats.append(kitten)

func _on_kitten_housed(_cat):
	selected = null
	#$CanvasLayer/gone.text = "Cat Housed!"
	cats_count = cats_count - 1 
	$box.kitten_in_box()
	game_over_check()
	

func _on_kitten_gone(_cat):
	cats_on_level = cats_on_level -1
	cats_count = cats_count - 1 
	game_over_check()
	
func _on_kitten_runaway():
	cats_count = cats_count + 1 
	update_ui_counters()
	
func _on_kitten_selected(cat):
	if selected==null:
		selected = cat
		cat.change_state("SELECTED")

func _on_kitten_deselected(cat):
	if selected == cat and selected.STATE.name != "DRAGGED":
		selected = null
		cat.change_state("IDLE")

func reset_plants():
	for f in flowers:
		if is_instance_valid(f):
			f.queue_free()
	flowers=[]

func reset_cats():
	for k in cats:
		if is_instance_valid(k):
			k.queue_free()
	cats=[]

func game_over_check():
	update_ui_counters()
	if cats_count <= 0:
		get_tree().call_group("kittens", "gameover")
		$box.gameover=true
		$box/cat_in_box.show()
		$box/AnimatedSprite.play('selected')
		$box/count.hide()
		$CanvasLayer/tryagain.show_popup(max_cats-cats_on_level,max_cats)
		$CanvasLayer/tryagain.show()
		
		
func hide_ui():
	$CanvasLayer/Sprite.hide()
	$CanvasLayer/gone.hide()
	$CanvasLayer/left.hide()

func show_ui():
	$CanvasLayer/Sprite.show()
	$CanvasLayer/gone.show()
	$CanvasLayer/left.show()
	
	
func _on_AcceptDialog_confirmed():
	reset()


func _on_Area2D_body_entered(body):
	if body.has_method("arrive_bridge"):
	   body.arrive_bridge()

func update_ui_counters():
	$CanvasLayer/left.text = "Cats left: " + str(cats_count)
	$CanvasLayer/gone.text = "Gone Plants: "+str(max_cats-cats_on_level)
	
func _on_Area2D_body_exited(body):
	if body.has_method("leave_bridge"):
	   body.leave_bridge()


func _on_box_landed():
	get_tree().call_group("kittens", "jump")


func _on_start_start():
	Input.vibrate_handheld(100)
	$CanvasLayer/start.hide()
	$Label.hide()
	show_ui()
	reset()


func _on_tryagain_try_again():
	Input.vibrate_handheld(100)
	$CanvasLayer/tryagain.hide()
	reset()
