extends Spatial

export var rotationRate = 150
export var quantity     = 0
var player = null
var explode = false
onready var timer = get_node('Timer')

#--------------------------------------
func _ready() :
  add_to_group( 'damagepowerup' )

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
	if body.name == 'Player':
		$'../HUD Layer'._updateDamagePowerupMessage()
		#$'../HUD Layer'._setPlayerHealth(20)
		timer.start(5)
	pass # Replace with function body.



func _on_Timer_timeout():
	#$'../HUD Layer'._setPlayerHealth(10)
	$'../HUD Layer'._setDamagePowerupMessage()	
	queue_free()
	pass # Replace with function body.
