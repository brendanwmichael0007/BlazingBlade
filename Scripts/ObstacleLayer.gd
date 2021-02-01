extends TileMap


var obstacleCosts ={0:1,1:1,2:1,3:10,4:10} 
var obstacleNames = {-1:"Snow",0:"Tree",1:"Tree",2:"Tree",3:"Sign",4:"Stone"}

func getObstacleName(tilePos):
	var tileCord = world_to_map(tilePos)
	var tileIndex = get_cellv(tileCord)
	return obstacleNames[tileIndex]

func getMovementCost(tilePosition):
	var tileIndex = get_cellv(tilePosition)
	if tileIndex == -1:
		#no obstacle in path
		return 0
	else:
		return obstacleCosts[tileIndex]
	

func _ready():
	pass # Replace with function body.



