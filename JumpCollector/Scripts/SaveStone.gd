extends Area2D

signal saveFinished(Anim_Finished)
signal saveEnter

export var saveNum = 0

var anim_Finished = false

func _ready():
	emit_signal("saveFinished(True)")

func _on_AnimationPlayer_animation_finished(anim_name = "Save"):
	anim_Finished = true


func _on_SaveStone_area_entered(area):
	emit_signal("saveEnter",saveNum)
	$E.visible = true


func _on_SaveStone_area_exited(area):
	emit_signal("saveEnter",saveNum)
	$E.visible = false
