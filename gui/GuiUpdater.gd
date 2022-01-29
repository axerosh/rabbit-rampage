extends Control

func _ready():
	pass

func _on_Rabbit_carrot_count_changed(new_carrot_count):
	$Counters/CarrotCount/Label.text = "%d" % new_carrot_count


func _on_Rabbit_flesh_count_changed(new_flesh_count):
	$Counters/FleshCounter/Label.text = "%d" % new_flesh_count
