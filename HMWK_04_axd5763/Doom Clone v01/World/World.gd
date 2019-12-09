extends Spatial

onready var timer = get_node('Timer')
const DEFAULT_MAX_AMMO = 10
var levelData = 0
var zindex = 0
var zombies = 0
var exzombies = 0
var vartime = 5
var exit=false
var current_level = 0


func _on_Timer_timeout():
	if vartime>=0:
		vartime-=0.5
	else:
		vartime = 1
	if zombies != null and exzombies != null and global.exploded== false:
		#_addZombies( zombies.get( 'tscn', null ), [[ [ 10,   2,  10  ], "2d2" ]] )
		_addZombies( exzombies.get( 'tscn', null ), [[ [ 10,   2,  10  ], "2d2" ]] )
		$Player._set_player_zombie()
		timer.set_wait_time(vartime)
		timer.start()
#-----------------------------------------------------------

func _ready() :
  #timer.set_wait_time(vartime)
  timer.start(vartime)
  get_tree().paused = false
  
  if current_level != level.current_level:
    current_level = level.current_level
    levelData = _getLevelData( current_level )

    if current_level == 1 :
      if levelData.get( 'numberOfLevels', 0 ) != 0 :
        level.SetMaximumLevel(levelData.get( 'numberOfLevels', 0 ))
      else :
        get_node( 'HUD Layer' )._levelLoadError()
        return

    level_(levelData)

func level_(levelData) : 
  var ammo = levelData.get( 'AMMO', null )
  if ammo != null :
    _addAmmo( ammo.get( 'tscn', null ), ammo.get( 'instances', [] ) )
  
  var key = levelData.get( 'KEY', null )
  if key != null :
    _addKey( key.get( 'Keytscn', null ), key.get( 'position', [] ) )
  
  zombies = levelData.get( 'ZOMBIES', null )
  if zombies != null :
   _addZombies( zombies.get( 'tscn', null ), zombies.get( 'instances', [] ) )

  exzombies = levelData.get( 'EXZOMBIES', null )

  var barrel = levelData.get( 'OBSTACLES', null )
  if barrel != null :
    _addBarrel( barrel.get( 'tscn', null ), barrel.get( 'instances', [] ) )

  var medbox = levelData.get( 'HEALTH', null )
  if medbox != null :
    _addMedbox( medbox.get( 'tscn', null ), medbox.get( 'instances', [] ) )
	
  var arena = levelData.get( 'arenaSize', null )
  if arena != null :
    _addArena( arena.get( 'tscn', null ), arena.get( 'arenaSize', [100,100] ) )

  var walls = levelData.get( 'WALLS', null )
  if walls != null :
    _addWalls( walls.get( 'tscn', null ), walls.get( 'instances', [] ) )

  var spawnplatform = levelData.get( 'ZOMBIE_SPAWN', null )
  if spawnplatform != null :
    _addSpawnerPlatform(spawnplatform)
	
		
  get_node( 'HUD Layer' )._resetAmmo( levelData.get( 'maxAmmo', DEFAULT_MAX_AMMO ) )

#---------------------------------------------------------------------
func _physics_process(delta):
#adding exit sign if needed
	if exit==false:
		if global.Key_check()==true:
			exit=true 
			var exit = levelData.get( 'EXIT', null )
			if exit != null :
    			_addExit( exit.get( 'Exittscn', null ), exit.get( 'position', [] ) )
		    	
 
#-----------------------------------------------------------
func _input( __ ) :    # Not using event so don't name it.
  if Input.is_action_just_pressed( 'maximize' ) :
    OS.window_fullscreen = not OS.window_fullscreen
	
func _addExit( model, position ) :
  var inst
  var index = 0
  if model == null :
    print( 'There were %d exit but no model?' % len( position ) )
    return
  #var pos = instInfo
  var ExitScene = load( model )
  inst = ExitScene.instance()
  inst.name = 'Exit-%02d' % index
  inst.translation = Vector3( position[0], position[1], position[2] )
  get_node( '.' ).add_child( inst )

#-----------------------------------------------------------
func _addAmmo( model, instances ) :
  var inst
  var index = 0
  if model == null :
    print( 'There were %d ammo but no model?' % len( instances ) )
    return

  var ammoScene = load( model )

  for instInfo in instances :
    index += 1

    var pos = instInfo[ 0 ]
    var amount  = Utils.dieRoll( instInfo[ 1 ] )

    inst = ammoScene.instance()
    inst.name = 'Ammo-%02d' % index
    inst.translation = Vector3( pos[0], pos[1], pos[2] )
    inst.setQuantity( amount )
    print( '%s at %s, %d rounds.' % [ inst.name, str( pos ), amount ] )
    get_node( '.' ).add_child( inst )

func _addKey( model, position ) :
  var inst
  var index = 0
  if model == null :
    print( 'There were %d key but no model?' % len( position ) )
    return
  #var pos = instInfo
  var keyScene = load( model )
  inst = keyScene.instance()
  inst.name = 'Key-%02d' % index
  inst.translation = Vector3( position[0], position[1], position[2] )
  get_node( '.' ).add_child( inst )



func _addMedbox( model, instances ) :
  var inst
  var index = 0

  if model == null :
    print( 'There were %d health but no model?' % len( instances ) )
    return

  var medScene = load( model )

  for instInfo in instances :
    index += 1

    var pos = instInfo[ 0 ]
    var amount  = Utils.dieRoll( instInfo[ 1 ] )
    inst = medScene.instance()
    inst.name = 'Med-%02d' % index
    inst.translation = Vector3( pos[0], pos[1], pos[2] )
    inst.setQuantity( amount)
    get_node( '.' ).add_child( inst )

#-----------------------------------------------------------
func _addSpawnerPlatform ( spawnerPlatformData ) :
	var platformModel = spawnerPlatformData.get( 'Platformtscn', null )
	var position = spawnerPlatformData.get( 'position', [] )
	var inst
	if platformModel == null :
		print( 'There was platform but no model?' )
		return
	var platformScene = load( platformModel )
	var pos = position[ 0 ]
	inst = platformScene.instance()
	inst.translation = Vector3( pos[0], pos[1], pos[2] )
	get_node( '.' ).add_child( inst )
func _addZombies( model, instances ) :
  var inst
  if model == null :
    print( 'There were %d zombie but no model?' % len( instances ) )
    return

  var zombieScene = load( model )

  get_node( 'HUD Layer' )._resetOpponents( len( instances ) )

  for instInfo in instances :
    zindex += 1

    var pos = instInfo[ 0 ]
    var hp  = Utils.dieRoll( instInfo[ 1 ] )

    inst = zombieScene.instance()
    inst.name = 'Zombie-%02d' % zindex
    inst.translation = Vector3( pos[0], pos[1], pos[2] )
    inst.setHealth( hp )
    print( '%s at %s, %d hp' % [ inst.name, str( pos ), hp ] )
    get_node( '.' ).add_child( inst )

func _addWalls( model, instances ) :
  var inst

  if model == null :
    print( 'There were %d walls but no model?' % len( instances ) )
    return

  var wallScene = load( model )

  for instInfo in instances :

    var pos = instInfo[ 0 ]
    var rot = instInfo[ 1 ]
    var sizescale = instInfo[ 2 ]

    inst = wallScene.instance()
    inst.translation = Vector3( pos[0], pos[1], pos[2] )
    inst.rotation = Vector3( rot[0], rot[1], rot[2] )
    inst.scale = Vector3( sizescale[0], sizescale[1], sizescale[2])
    
    get_node( '.' ).add_child( inst )	

func _addArena( model,arenaSize ) :
  if model == null :
   print( 'There was no floor model?' )
   return

  var arena = load( model )
  var inst = arena.instance()
  inst.translation = Vector3(0,-1.5,0)
  inst.scale = Vector3(arenaSize[0]/2, 0, arenaSize[0]/2)
  inst.rotation = Vector3(0,0,0)
  get_node( '.' ).add_child( inst )
		
func _addBarrel( model, instances ) :
  var inst
  var index = 0

  if model == null :
    print( 'There were %d barrel but no model?' % len( instances ) )
    return

  var BarrelScene = load( model )
  for instInfo in instances :
    index += 1

    var pos = instInfo[ 0 ]

    inst = BarrelScene.instance()
    inst.name = 'Barrel-%02d' % index
    inst.translation = Vector3( pos[0], pos[1], pos[2] )
    get_node( '.' ).add_child( inst )
#-----------------------------------------------------------
func _getLevelData( levelNumber ) :
  var levelData = {}

  var fName = 'res://Levels/Level-%02d.json' % levelNumber

  var file = File.new()
  if file.file_exists( fName ) :
    file.open( fName, file.READ )
    var text_data = file.get_as_text()
    var result_json = JSON.parse( text_data )

    if result_json.error == OK:  # If parse OK
      levelData = result_json.result

    else :
      print( 'Error        : ', result_json.error)
      print( 'Error Line   : ', result_json.error_line)
      print( 'Error String : ', result_json.error_string)

  else :
    print( 'Level %d config file did not exist.' % levelNumber )

  return levelData

#-----------------------------------------------------------