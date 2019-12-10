extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var exploded = false
var damage = 1
var addkey=false
#onready var key_path = get_node( '/World/HUD Layer/Key' )
# Called when the node enters the scene tree for the first time.
onready var key_path = get_tree().get_root().get_node("World").get_node("HUD Layer/Key_symbol")
func _ready():

	pass # Replace with function body.

func Add_key():
	key_path.set_visible(true)
	addkey=true
	

func explosion():
	exploded=true
	
	
func Key_check():
	return addkey 
	
	
func damagepwr():
	damage=5
	
func damagepwrdec():
	damage=1
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
