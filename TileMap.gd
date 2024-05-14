extends TileMap

var grass_vectors = [
	Vector2(1, 0),
	Vector2(2, 0),
	Vector2(3, 0),
	Vector2(4, 0),
	Vector2(5, 0)
]

func get_random_atlas_vector() -> Vector2i:
	# Generate a random index within the range of atlas vectors array
	var random_index := randi() % grass_vectors.size()
	# Return the vector at the random index
	return grass_vectors[random_index]

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
			set_cell(0, Vector2i(tile_position.x-width/2 + x, tile_position.y-height/2 + y), 0, Vector2(round(9* (moist + 10)/20),0))
