extends Node2D

# this script uses an adjacency matrix implementation due to
# the potential density of the graph
var graph = []

func ready() -> void:
	# how many guards are present?
	var num_guards = get_child_count()
	
	# initialize the adjacency matrix, represented as
	# a 2D array
	for i in range(0, num_guards):
		var a = []
		a.resize(num_guards)
		a.fill(0)
		graph.append(a)
