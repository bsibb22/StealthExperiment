extends Node2D

# the maximum distance from which guards can communicate
# without walkie-talkies
@export var MAX_PERCEPTION_RANGE = 500

# this script uses an adjacency matrix implementation due to
# the potential density of the graph
var graph = []
var num_guards : int = 0

func _ready() -> void:
	# how many guards are present?
	num_guards = get_child_count()
	print(num_guards)
	
	# initialize the adjacency matrix, represented as
	# a 2D array
	for i in range(0, num_guards):
		var a = []
		a.resize(num_guards)
		a.fill(0)
		graph.append(a)
	
	update_graph()

# O(n^2) time complexity, with n being the number of guards
# present in the scene; this method should only be called
# when necessary due to its high complexity

# updates the adjacency matrix so that each edge represented
# has a weight equal to the distance between the two guards;
# this allows easier implementation of graph algorithms so
# "information" naturally spreads between guards that are
# closer together
func update_graph() -> void:
	for i in range(0, num_guards):
		var guard_a = get_child(i)
		for j in range(0, num_guards):
			if i == j: continue
			
			var guard_b = get_child(j)
			var guard_dist = global.dist_2d(guard_a, guard_b)
			if guard_dist > MAX_PERCEPTION_RANGE: continue
			
			graph[i][j] = floor(guard_dist)
	
	print_rich(graph)

var timer: int = 0
func _process(_delta: float) -> void:
	get_child(0).position = Vector2(cos(timer * 0.01) * 150, sin(timer * 0.01) * 100)
	
	if timer % 100 == 0:
		update_graph()
	
	timer += 1
