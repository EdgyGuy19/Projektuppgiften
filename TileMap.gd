extends TileMap

#some variables for generating the map
var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
@export var width = 50
@export var height = 50
#@onready var player = get_parent().get_childe(1)

func _ready():
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()
	altitude.frequency = 0.005
	
func _process(delta):
	generate_map(position)

#Generating the map depending on the player position
func generate_map(position):
	var tile_position = local_to_map(position)
	for x in range (width):
		for y in range (height):
			var moist = moisture.get_noise_2d(tile_position.x + x, tile_position.y + y)
			var temp = temperature.get_noise_2d(tile_position.x + x, tile_position.y + y)
			var alt = altitude.get_noise_2d(tile_position.x + x, tile_position.y + y)
			#decide how to set/spawn cells
