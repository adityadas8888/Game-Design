extends CanvasLayer
var elapsedTime = 0
var lastTime    = 0
var level = 0
var health = 0
var maxhealth = 0
#-----------------------------------------------------------
func _ready() :
  elapsedTime = 0

#-----------------------------------------------------------
func _process( delta ) :
  _updateHUDTime( delta )

#-----------------------------------------------------------
func _updateHUDTime( delta ) :
  elapsedTime += delta

  if elapsedTime - lastTime > 1 :
    lastTime = elapsedTime

    get_node( 'LevelTime' ).text = getTimeStr()

func getTimeStr() :
  var minutes = int( elapsedTime / 60 )
  var seconds = int( elapsedTime - minutes*60 )

  return '%02d:%02d' % [ minutes, seconds ]

#-----------------------------------------------------------
var maxAmmo = 0
var numAmmo = 0

func _resetAmmo( qty ) :
  maxAmmo = qty
  numAmmo = qty
  _setAmmoMessage()

func _updateAmmo( qty ) :
  if numAmmo+qty> maxAmmo:
    numAmmo=maxAmmo
  else:
    numAmmo+=qty
  _setAmmoMessage()

func _setAmmoMessage() :
  get_node( 'Ammo' ).text = '%d / %d' % [ numAmmo, maxAmmo ]

func _setHealth() :
	get_node('PlayerHealth').text = '%d / %d' % [ health, maxhealth ]

func _setHealthPowerupMessage() :
  get_node( 'HealthPowerup' ).text = '%s' % 'inactive'
  get_node( 'HealthPowerup' ).add_color_override("font_color", Color(1,0,0,1))
func _setDamagePowerupMessage() :
	get_node('DamagePowerup').text = '%s' % 'inactive'
	get_node( 'DamagePowerup' ).add_color_override("font_color", Color( 0, 1, 0, 1 ))
	
func _updateHealthPowerupMessage() :
  get_node( 'HealthPowerup' ).text = '%s' % 'Meth mode on'
  get_node( 'HealthPowerup' ).add_color_override("font_color", Color(1,0,0,1))
func _updateDamagePowerupMessage() :
	get_node('DamagePowerup').text = '%s' % 'Hulk Smash'
	get_node( 'DamagePowerup' ).add_color_override("font_color", Color( 0, 1, 0, 1 ))
	
func _setPlayerHealth(qty) :
	maxhealth = qty
	health = qty
	_setHealth()

func _heal(qty) :
	if health+qty>maxhealth:
		health = maxhealth
	else:
		health=qty
	_setHealth()
func _updatePlayerHealth() :
	health-=1
	get_node('PlayerHealth').text= '%d / %d' % [ health, maxhealth]

func _ammoUsed() :
  var success = numAmmo != 0

  if success :
    numAmmo -= 1

  _setAmmoMessage()
  return success

#-----------------------------------------------------------
var maxOpponents = 0
var numOpponents = 0

func _resetOpponents( qty ) :
  maxOpponents += qty
  numOpponents += qty
  _setOpponentMessage()

func _setOpponentMessage() :
  get_node( 'Opponents' ).text = '%d / %d' % [ numOpponents, maxOpponents ]

func _opponentDied() :
  numOpponents -= 1
  _setOpponentMessage()

  if numOpponents == 0 :
    nextlevel._changelevel()
    var timeStr = $'../HUD Layer'.getTimeStr()
    print( 'Last opponent died at %s.' % timeStr )
    $'../Message Layer/Message'.activate( 'Player Wins!\n%s' % timeStr )

#-----------------------------------------------------------
