extends KinematicBody
onready var timer = get_node('Timer')
var MOVE_SPEED = 3

const SENSE_DISTANCE = 20

onready var raycast = $RayCast
onready var anim_player = $AnimationPlayer

var player = null
var dead = false
var health = 1
var hurt_health= 1

#-----------------------------------------------------------
func _ready() :
  anim_player.play( 'walk' )
  add_to_group( 'zombies' )
#-----------------------------------------------------------
func _physics_process( delta ) :
  if dead :
    return

  if player == null :
    return
  MOVE_SPEED=3
  var vec_to_player = player.translation - translation

  vec_to_player = vec_to_player.normalized()
  raycast.cast_to = vec_to_player * 1.5

  # warning-ignore:return_value_discarded
  move_and_collide( vec_to_player * MOVE_SPEED * delta )

  if raycast.is_colliding() :
    var coll = raycast.get_collider()
    if coll != null and coll.name == 'Player' :
     if hurt_health>0:
      coll.hurt(hurt_health)
      hurt_health=0
      MOVE_SPEED=0
      timer.set_wait_time(2)
      timer.start()
#-----------------------------------------------------------
func hurt( howMuch = 1 ) :
  health -= howMuch

  if health <= 0 :
    dead = true
    var bodies = $Area.get_overlapping_bodies()
    print(bodies)
    find_any_body(bodies)
    $CollisionShape.disabled = true
    anim_player.play( 'die' )
    print( '%s died.' % name )
    $'../Zombie Audio'._playSound( 'die' )
    $'../HUD Layer'._opponentDied()

  else :
    anim_player.play( 'wounded' )
    var bodies = $Area.get_overlapping_bodies()
    find_any_body(bodies)
    print( '%s wounded by %d hp , now has %d hp.' % [ name, howMuch, health ] )
    #$'../Zombie Audio'._playSound( 'grunt' )

#-----------------------------------------------------------
func setHealth( hp ) :
  health =  hp

#-----------------------------------------------------------
func set_player( p ) :
	player = p

#-----------------------------------------------------------


func _on_Timer_timeout():
	hurt_health=1
	MOVE_SPEED=3
	
	
func find_any_body(bodies):
	for i in bodies:
		print(i)
		if i.has_method('hurt'):
			i.hurt(1)

