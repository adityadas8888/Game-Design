extends StaticBody
onready var timer = get_node('Timer')
onready var raycast = $RayCast
# warning-ignore:unused_class_variable
onready var anim_player = $AnimationPlayer
var player = null
var exploded = false
var health = 2

#-----------------------------------------------------------
func _ready() :
  add_to_group( 'barrels' )

func set_player(p):
	player = p
#-----------------------------------------------------------
# warning-ignore:unused_argument
func _physics_process( delta ) :
	if exploded:
		return
	if player == null:
		return

func explode():
	health-=global.damage
	$AudioStreamPlayer._playSound('hit')
	if health<=0 and exploded !=true:
		$AudioStreamPlayer._playSound('explosion')
		var bodies = $Area.get_overlapping_bodies()
		#print(bodies)
		find_zombie_body(bodies)
		exploded = true
		get_node("barrelmesh").visible=false
		$CollisionShape.disabled = true
		anim_player.play("explode")
		timer.set_wait_time(2)
		timer.start()
		
func setHealth( hp ) :
  health =  hp

func _on_Timer_timeout():
	queue_free() # Replace with function body.
		
func find_zombie_body(bodies):
	for i in bodies:
		if i.has_method('hurt'):
			i.hurt(global.damage)