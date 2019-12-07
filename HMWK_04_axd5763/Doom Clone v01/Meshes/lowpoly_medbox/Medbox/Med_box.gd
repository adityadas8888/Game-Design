extends Spatial

export var rotationRate = 150
export var quantity     = 0
var player = null
var taken = false

#--------------------------------------
func _ready() :
  add_to_group( 'medbox' )

func set_player(p):
	player = p
#-----------------------------------------------------------
func _process( delta ) :
  var rot_speed = deg2rad( rotationRate )
  rotate_y( rot_speed*delta )

#-----------------------------------------------------------
func setQuantity( qty ) :
  quantity = qty

#-----------------------------------------------------------
func _on_Area_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.name == 'Player' and taken ==false:
		$'../HUD Layer'._heal(quantity)
	queue_free()
	pass # Replace with function body.
