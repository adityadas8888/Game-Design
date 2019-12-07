extends Spatial

export var rotationRate = 150
export var quantity     = 0
var player = null
var explode = false

#--------------------------------------
func _ready() :
  add_to_group( 'key' )

func set_player(p):
	player = p
#-----------------------------------------------------------
func _process( delta ) :
  var rot_speed = deg2rad( rotationRate )
  rotate_y( rot_speed*delta )

#-----------------------------------------------------------
func setQuantity( qty ) :
  quantity = qty


func _on_Area_body_entered(body):
	if body.name == 'Player':
		global.Add_key()
		queue_free()
	 # Replace with function body.


func _on_Area_area_shape_entered(area_id, area, area_shape, self_shape):
	pass # Replace with function body.
