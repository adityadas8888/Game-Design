extends KinematicBody

const MOVE_SPEED =   10
const MOUSE_SENS =   0.5
const MAX_ANGLE  =  88
const MIN_ANGLE  = -45
var PLAYER_HEALTH = 10
# FOV for when we zoom using "telescopic sight".
const FOV_NORMAL = 70
const FOV_ZOOM   = 6

var zoomed = false
const SENSE_DISTANCE=2

onready var anim_player = $AnimationPlayer
onready var raycast = $RayCast
onready var timer = $Timer
onready var meleeAttackSprite = get_node( 'View/Crosshair/Control/Sprite2' )
onready var gunAttackSprite = get_node( 'View/Crosshair/Control/Sprite' )
onready var anim_zombie = $AnimationZombies
var zombies=null
var player=null 

var coll
#-----------------------------------------------------------
func _ready():
  Input.set_mouse_mode( Input.MOUSE_MODE_CAPTURED )
  get_node('Camera').set_zfar(200)
  $'../HUD Layer'._setPlayerHealth(PLAYER_HEALTH)
  $'../HUD Layer'._setHealthPowerupMessage()
  $'../HUD Layer'._setDamagePowerupMessage()
  yield( get_tree(), 'idle_frame' )
  _set_player_zombie()
  get_tree().call_group( 'zombies', 'set_player', self )
  get_tree().call_group( 'barrels', 'set_player', self )
  get_tree().call_group( 'ammo', 'set_player', self )
  get_tree().call_group( 'medbox', 'set_player', self )
  get_tree().call_group( 'player', 'set_player', get_tree().get_root().get_node("World").get_node("Zombie") )
#-----------------------------------------------------------
func _input( event ) :
  if Input.is_action_just_pressed( 'zoom' ) :
    zoomed = not zoomed

  if zoomed :
    get_node( 'Camera' ).fov = FOV_ZOOM
    get_node( 'View/Crosshair' ).visible = false
    get_node( 'View/Scopesight' ).visible = true

  else :
    get_node( 'Camera' ).fov = FOV_NORMAL
    get_node( 'View/Crosshair' ).visible = true
    get_node( 'View/Scopesight' ).visible = false

  if event is InputEventMouseMotion :
    rotation_degrees.y -= MOUSE_SENS * event.relative.x

    rotation_degrees.x -= MOUSE_SENS * event.relative.y
    rotation_degrees.x = min( MAX_ANGLE, max( MIN_ANGLE, rotation_degrees.x ) )

#-----------------------------------------------------------
func _process( __ ) :    # Not using delta so don't name it.
  if Input.is_action_pressed( 'restart' ) :
    kill()
func _set_player_zombie():
	get_tree().call_group( 'player', 'set_player', self )
	get_tree().call_group( 'zombies', 'set_player', get_tree().get_root().get_node("World").get_node("Zombie") )

#-----------------------------------------------------------
func _physics_process( delta ) :
  var move_vec = Vector3()

  if Input.is_action_pressed( 'move_forwards' ) :
    move_vec.z -= 1

  if Input.is_action_pressed( 'move_backwards' ) :
    move_vec.z += 1

  if Input.is_action_pressed( 'move_left' ) :
    move_vec.x -= 1

  if Input.is_action_pressed( 'move_right' ) :
    move_vec.x += 1

  move_vec = move_vec.normalized()
  move_vec = move_vec.rotated( Vector3( 0, 1, 0 ), rotation.y )

  # warning-ignore:return_value_discarded
  move_and_collide( move_vec * MOVE_SPEED * delta )
  # This is for RMB Melee
  if Input.is_action_just_pressed( 'MeleeAttack' ):
    gunAttackSprite.set_visible(false)
    meleeAttackSprite.set_visible(true) 
    timer.start(0.6)
    var vec_to_player = self.translation - zombies.translation
    if vec_to_player.length() > SENSE_DISTANCE :
    	coll = raycast.get_collider()
    	if raycast.is_colliding() and coll.has_method( 'hurt' ) :
        	coll.hurt(1)
    	

  # Attack Zombie with Melee
     
#  if raycast.is_colliding() and coll.has_method( 'hurt' ) :
#    coll.hurt()
#    return
  
  # Attack Barrel_area with Melee
  coll = raycast.get_collider()
  if raycast.is_colliding() and (coll.name == "Barrel_area") : 
    print('Barrel Hit called')
    coll.get_parent().BarrelHit()
    return

  # Attack BarrelHit with Melee
  if raycast.is_colliding() and coll.has_method( 'BarrelHit' ) : 
    print('Barrel Hit called')
    coll.BarrelHit()
    return

  # Attack HealthPack with Melee
  if raycast.is_colliding() and coll.has_method( 'setHealthPack' ) : 
    #coll.setHealthPack()
    $'../HUD Layer'._resetPlayerHealth( 5 )
    return
   
  if Input.is_action_just_pressed( 'shoot' ) and !anim_player.is_playing() :
    meleeAttackSprite.set_visible(false)
    gunAttackSprite.set_visible(true)
    if $'../HUD Layer'._ammoUsed() :
      anim_player.play( 'shoot' )
      $'../Player Audio'._playSound( 'shoot' )

      coll = raycast.get_collider()
      if raycast.is_colliding() and coll.has_method( 'hurt' ) :
        coll.hurt(1)
		
      if raycast.is_colliding() and coll.has_method( 'explode' ) :
        coll.explode()
    else :
      $'../Player Audio'._playSound( 'empty' )
#----------------------------------------------------------	
func hurt(hurt_health) :
	if PLAYER_HEALTH>0:
        PLAYER_HEALTH-=hurt_health
        print( 'Player health %s.' %PLAYER_HEALTH )
        $'../HUD Layer'._updatePlayerHealth()
	elif PLAYER_HEALTH<=0:
		kill()
	
#-----------------------------------------------------------
func kill() :
  var timeStr = $'../HUD Layer'.getTimeStr()

  print( 'Player died at %s.' % timeStr )

  $'../Message Layer/Message'.activate( 'Player Died\n%s' % timeStr )

#-----------------------------------------------------------


func _on_Timer_timeout():
	meleeAttackSprite.set_visible(false)
	gunAttackSprite.set_visible(true)
	pass # Replace with function body.
