extends Node

# calculates the 2D distance between two nodes
func dist_2d(a: Node2D, b: Node2D) -> float:
	var x_dist: float = a.global_position.x - b.global_position.x
	var y_dist: float = a.global_position.y - b.global_position.y
	return sqrt(x_dist * x_dist + y_dist * y_dist)
