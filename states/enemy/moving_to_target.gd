extends Node

var fsm: StateMachine
var e : Enemy

func enter():
	e.get_node("Spawn").play()


func process(delta):
	if e.area_entered:
		e.target.object.targeted = false
		e.emit_killed(e.POINTS)
		fsm.change_to("enemy_explode")
	else:
		move_to_target(delta)


func move_to_target(delta):
	e.move(delta)
	if e.body_entered == e.target.object:
		e.get_node("Action").play()
		e.payload = e.body_entered
		match e.body_entered.tag:
			"building":
				# Reparent the structure from terrain to enemy
				e.body_entered.reparent(e, Vector2(-8, 8))
				e.target.position = Vector2(e.position.x, -8000)
				fsm.change_to("lifting")
			"energy_source":
				fsm.change_to("draining_energy")
		e.body_entered = null
