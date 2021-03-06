class_name DiamondRange
extends SkillRange


export var min_dist := 1
export var max_dist := 1


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func get_range(source_cell: Vector2, source_actor: Actor, map: Map) -> Array:
	return TileGeometry.cells_in_range(
			source_actor.get_cell_rect_at_cell(source_cell),
			min_dist, max_dist)
