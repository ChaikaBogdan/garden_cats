extends TextureRect
signal try_again

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_popup(cats_plants,max_cats):
	$RichTextLabel.text="Score: "+str(max_cats-cats_plants)+"/"+str(max_cats)+"\n"
	if cats_plants > 0 and cats_plants<max_cats:
		$RichTextLabel.text+="Better luck next time!"
	elif cats_plants == 0:
		$RichTextLabel.text+="You saved them all!"
	elif cats_plants==max_cats:
		$RichTextLabel.text+="They all gone..."
	show()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_pressed():
	emit_signal("try_again")
