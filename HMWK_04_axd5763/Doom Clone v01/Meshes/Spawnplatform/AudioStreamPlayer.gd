extends AudioStreamPlayer

var sounds = {
    'hit' : load( 'res://Audio/Metal_clang.wav' ),
    'explosion'   : load( 'res://Audio/Barrel_exploding.wav' )
  }

func _playSound( which, fromTime = 0.0 ) :
  var sound = sounds.get( which, null )

  if sound == null :
    print( 'Platform: Unknown sound "%s" requested.' % which )
    return

  stream = sound

  play( fromTime )


