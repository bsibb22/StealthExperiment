extends Node2D

# the maximum distance from which guards can communicate
# without walkie-talkies
@export_group("System Constants")
@export var MAX_PERCEPTION_RANGE: int = 800
@export var MAX_COMMUNICATION_DISTANCE: int = 400

# this script uses an adjacency matrix implementation due to
# the potential density of the graph
var graph = []
var num_guards: int = 0

func _ready() -> void:
	# how many guards are present?
	num_guards = get_child_count()
	
	# initialize the adjacency matrix, represented as
	# a 2D array
	for i in range(0, num_guards):
		var a = []
		a.resize(num_guards)
		a.fill(65535)
		graph.append(a)
	
	update_graph()
	connect_guards()

# allows guards to send a signal and update the graph;
# this happens when any guard detects the player
func connect_guards() -> void:
	for i in range(0, num_guards):
		get_child(i).player_detected.connect(propagate_awareness.bind(i))

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
			if guard_dist > MAX_PERCEPTION_RANGE:
				continue
			
			graph[i][j] = floor(guard_dist)
	print_rich(graph)

# propagates guard awareness of the player based on the values
# stored in the graph
func propagate_awareness(origin: int) -> void:
	update_graph()
	
	var guard_a = get_child(origin)
	for i in range(0, num_guards):
		if i == origin: continue
		
		var guard_b = get_child(i)
		
		if guard_b.alerted: continue
		if graph[origin][i] > MAX_COMMUNICATION_DISTANCE: continue
		
		guard_b.alert()

var timer: int = 0
func _process(_delta: float) -> void:
	get_child(0).position = Vector2(cos(timer * 0.01) * 150, sin(timer * 0.01) * 100)
	
	if timer % 100 == 0:
		update_graph()
		
	if timer == 499:
		get_child(0).alerted = true
		get_child(0).player_detected.emit()
	
	timer += 1
