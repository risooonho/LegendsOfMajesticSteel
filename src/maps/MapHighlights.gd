class_name MapHighlights
extends Node

enum Tiles {
	WALK,
	TARGET,
	AOE,
}

var moves_visible: bool setget set_moves_visible, get_moves_visible
var targets_visible: bool setget set_targets_visible, get_targets_visible

var target_cursor_visible: bool setget set_target_cursor_visible, \
		get_target_cursor_visible


var target_cursor_cell: Vector2 setget set_target_cursor_cell, \
		get_target_cursor_cell

onready var _moves: TileMap = $Moves
onready var _targets: TileMap = $Targets
onready var _aoe: TileMap = $AOE
onready var _target_cursor: Sprite = $TargetCursor


func set_moves_visible(value: bool) -> void:
	_moves.visible = value


func get_moves_visible() -> bool:
	return _moves.visible


func set_targets_visible(value: bool) -> void:
	_targets.visible = value
	_aoe.visible = value


func get_targets_visible() -> bool:
	return _targets.visible


func set_target_cursor_visible(value: bool) -> void:
	_target_cursor.visible = value


func get_target_cursor_visible() -> bool:
	return _target_cursor.visible


func set_target_cursor_cell(value: Vector2) -> void:
	_target_cursor.position = value * _moves.cell_size


func get_target_cursor_cell() -> Vector2:
	return _target_cursor.position / _moves.cell_size


func set_moves(cells: Array) -> void:
	_set_cells(_moves, Tiles.WALK, cells)


func set_targets(cells: Array) -> void:
	_set_cells(_targets, Tiles.TARGET, cells)


func set_aoe(cells: Array) -> void:
	_set_cells(_aoe, Tiles.AOE, cells)


func _set_cells(tilemap: TileMap, tile: int, cells: Array) -> void:
	tilemap.clear()
	for c in cells:
		var cell: Vector2 = c
		tilemap.set_cellv(cell, tile)
