extends Node

export var quantity = 0
var player = null
var explode = false

#-----------------------------------------------------------
# Called when the node enters the scene tree for the first time.
func _ready() :
  add_to_group( 'exit' )

#-----------------------------------------------------------
func set_player(p):
	player = p

#-----------------------------------------------------------
func _process( delta ) :
  pass

#-----------------------------------------------------------
func setQuantity( qty ) :
  quantity = qty

#-----------------------------------------------------------
func _on_Area_body_entered(body):
	if body.name == 'Player':
		$'../HUD Layer'.player_won()
		global.Reset_Key()
		queue_free()
