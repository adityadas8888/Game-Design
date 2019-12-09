extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var quantity     = 0
var player = null
var explode = false

# Called when the node enters the scene tree for the first time.
func _ready() :
  add_to_group( 'exit' )

func set_player(p):
	player = p
#-----------------------------------------------------------
func _process( delta ) :
  pass

#-----------------------------------------------------------
func setQuantity( qty ) :
  quantity = qty


func _on_Area_body_entered(body):
	if body.name == 'Player':
		global.Add_key()
		$'../HUD Layer'.player_won()
		queue_free()
	 # Replace with function body.


