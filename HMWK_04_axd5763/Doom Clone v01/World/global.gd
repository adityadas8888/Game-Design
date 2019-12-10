extends Node

var exploded = false
var damage = 1
var addkey=false
#onready var key_path = get_node( '/World/HUD Layer/Key' )

onready var key_path = get_tree().get_root().get_node("World").get_node("HUD Layer/Key_symbol")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Add_key():
	key_path = get_tree().get_root().get_node("World").get_node("HUD Layer/Key_symbol")
	key_path.set_visible(true)
	addkey=true

func Reset_Key():
	addkey=false

func explosion():
	exploded=true

func Key_check():
	return addkey 

func damagepwr():
	damage=5

func damagepwrdec():
	damage=1