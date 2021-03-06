class_name SkillAction
extends Action

var skill: Skill
var target: Vector2


func _init(new_actor: Actor, new_map: Map, new_skill: Skill, \
		new_target: Vector2).(new_actor, new_map) -> void:
	skill = new_skill
	target = new_target


func run() -> void:
	yield(skill.run(actor, map, target), "completed")
	actor.take_turn()
