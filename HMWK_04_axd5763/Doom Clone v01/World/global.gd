extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var exploded = false
var damage = 1
var add_key=false

# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.

func Add_key():
	add_key=true
	

func explosion():
	exploded=true
	
	
func Key_check():
	return add_key 
	
	
func damagepwr():
	damage=5
	
func damagepwrdec():
	damage=1
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
