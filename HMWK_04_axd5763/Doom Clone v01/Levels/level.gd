extends Node


var current_level=1

var maximum_level = 0

var changelevel = 1

func _changelevel():
	if changelevel>=2:
		changelevel=1
	else:
  		changelevel += 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func SetMaximumLevel( max_level ) :
	if max_level != 0 :
		maximum_level = max_level
	

# win == 1 if user won the level, else win -- 0.
func level_change(win):
	
	if  win == 1:
		
		if current_level == maximum_level :
# warning-ignore:standalone_expression
			current_level == 1
			return
		
		current_level=current_level+1
		return
	
	if (win != 1) :
		
		if current_level == 1 :
			return
		
		current_level = current_level - 1
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
