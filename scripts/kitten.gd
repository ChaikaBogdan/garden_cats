extends KinematicBody2D

var at_home = false
var housed = false
var at_bridge = false
var mouse_offset = Vector2()
var navigation = null
var COLOR = choose(['yellow','red'])
#var COLOR = 'red'
var STATE = null
var FORBIDEN = []
var WALK_SPEED = choose([100,150,200,250])
# warning-ignore:unused_signal
signal kitten_housed
# warning-ignore:unused_signal
signal kitten_gone
signal kitten_runaway
signal kitten_selected
signal kitten_deselected
var rng = RandomNumberGenerator.new()

onready var STATES_MAP ={
	"IDLE": $States/IDLE,
	"WALK": $States/WALK,
	"DRAGGED": $States/DRAGGED,
	"PLANT": $States/PLANT,
	"HOUSED": $States/HOUSED,
	"SELECTED":$States/SELECTED,
	"GAMEOVER":$States/GAMEOVER,
	"GONE":$States/GONE,
	"PURRING":$States/PURRING
}

func _ready():
	add_to_group("kittens")
	z_index = 2
	#$AnimatedSprite.material.set_shader_param("outline_color",Color(0,0,0))
	rng.randomize()
	STATE = STATES_MAP['IDLE']
	#AnimatedSprite.modulate = COLOR
	var scale_mod = choose([1,1.05,0.95])
	$AnimatedSprite.scale=Vector2(scale_mod,scale_mod)
	$debug.text = name +": "+ str(STATE.name)
	
	change_state("WALK")
	FORBIDEN=["SELECTED",'PLANT',"DRAGGED",'GAMEOVER','HOUSED','GONE']
	

func init(n,pos,nav):
	rng.randomize()
	name = n
	position = pos
	#randomzie cats starting points
	position = Vector2(rng.randi_range(50, 1880),rng.randi_range(50, 1050))
	navigation = nav
	hide()
	
func _physics_process(delta):
	if STATE.has_method("handle_physics_process"):
		var new_state = STATE.handle_physics_process(self,delta)
		if new_state:
			change_state(new_state)
	
func _process(delta):
	
	if STATE.has_method("handle_process"):
		var new_state =  STATE.handle_process(self,delta)
		if new_state:
			change_state(new_state)
	#$Label.text = name +": "+ str(STATE.name)

func change_state(new_state):
	if STATE.name == new_state:
		#print (name + ": " + STATE.name + " !-> STUCK")
		return
	if not (new_state in STATES_MAP.keys()):
		#print (name + ": " + STATE.name + "-> " + new_state + "  = ! ILLEGAL STATE NAME")
		return
	if not (new_state in STATE.allowed):
		#print (name + ": " + STATE.name + "-> " + new_state + "  = ! ILLEGAL TRANSITION")
		return
	if  (new_state in FORBIDEN):
		#print (name + ": " + STATE.name + "-> " + new_state + "  = ! FORBIDEN STATE")
		return
	#print (name + ": " + STATE.name + " -> " + new_state)
	
	STATE = STATES_MAP[new_state]
	$debug.text = name +": "+ str(STATE.name)
	if STATE.has_method("init"):
		var post_init_state = STATE.init(self)
		if post_init_state:
			#print (name + ": " + new_state + " -(POST)-> " + post_init_state)
			change_state(post_init_state)
		


func _on_kitten_mouse_entered():
	emit_signal("kitten_selected",self)
	
func _on_kitten_mouse_exited():
	emit_signal("kitten_deselected",self)
	
func _on_kitten_runaway():
	emit_signal("kitten_runaway")
	
func arrive_home():
	at_home = true
	
func leave_home():
	at_home = false
	
func arrive_bridge():
	at_bridge = true

func leave_bridge():
	at_bridge = false

func choose(arr): 
	arr.shuffle()
	return arr.front()

func jump():
	FORBIDEN=[]
	show()

func gameover():
	change_state("GAMEOVER")
	
func menu():
	FORBIDEN=["SELECTED","DRAGGED",'GAMEOVER','HOUSED','GONE']
	show()

func _on_Timer_timeout():
	$Timer.wait_time = choose([3,5,8,10])
	change_state(choose(["WALK","PURRING","WALK","WALK","WALK"]))
	

func _on_kitten_input_event(_viewport, event, _shape_idx):
	if STATE.has_method("handle_input"):
		var new_state = STATE.handle_input(self,event)
		if new_state:
			change_state(new_state)


func _on_PLANT_gone():
	if STATE.name == 'PLANT':
		change_state("GONE")




