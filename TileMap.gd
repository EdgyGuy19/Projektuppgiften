extends TileMap

#some variables for generating the map
var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
@export var width = 80
@export var height = 80
@onready var player = get_parent().get_child(0)

func _ready():
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()
	altitude.frequency = 0.005
	
func _process(_delta):
	generate_map(player.position)

#Generating the map depending on the player position
func generate_map(position):
	var tile_position = local_to_map(position)
	for x in range (width):
		for y in range (height):
			var moist = moisture.get_noise_2d(tile_position.x-width/2 + x, tile_position.y-height/2 + y)*10
			var temp = temperature.get_noise_2d(tile_position.x-width/2 + x, tile_position.y-height/2 + y)*10
			var alt = altitude.get_noise_2d(tile_position.x-width/2 + x, tile_position.y-height/2 + y)*10
			set_cell(0, Vector2i(tile_position.x-width/2 + x, tile_position.y-height/2 + y), 4, Vector2(round((moist+10)/5), round(temp+10)/5))
