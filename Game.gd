extends Node2D

@onready var tilemap = $TileMap

var width = 400
var height = 400

const LAND_CAP = 0.03

var grass_vectors = [
	Vector2i(1, 0),
	Vector2i(2, 0),
	Vector2i(3, 0),
	Vector2i(4, 0),
	Vector2i(5, 0)
]

func get_random_atlas_vector() -> Vector2i:
	# Generate a random index within the range of atlas vectors array
	var random_index := randi() % grass_vectors.size()
	# Return the vector at the random index
	return grass_vectors[random_index]

func _ready():
	generate_world()

func generate_world():
	var noise = FastNoiseLite.new()
	noise.seed = randi()

	var cells = []
	for x in range(-width/2, width/2):
		for y in range(-height/2, height/2):
			var a = noise.get_noise_2d(x,y)
			if a < LAND_CAP:
				cells.append(Vector2(x,y))
			else:
				tilemap.set_cell(0, Vector2(x,y), 0, get_random_atlas_vector())
	tilemap.set_cells_terrain_connect(0, cells, 0, 0)
