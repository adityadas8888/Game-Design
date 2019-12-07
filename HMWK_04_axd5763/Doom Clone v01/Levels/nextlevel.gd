extends Node

var changelevel = 1
func _changelevel():
	if changelevel>=2:
		changelevel=1
	else:
  		changelevel += 1

