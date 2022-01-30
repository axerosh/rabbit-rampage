extends Control

func _on_Rabbit_leveled_up(level: int, speed: float, damage: int, carrot_cost: int, next_flesh_cost: int, next_level: int, next_speed: float, next_damage: int, next_carrot_cost: int):
	$Leveling/Current/Level/Value.text = "%d" % level
	$Leveling/Current/GridContainer/SpeedValue.text = "%.2f" % speed
	$Leveling/Current/GridContainer/DamageValue.text = "%d" % damage
	$Leveling/Current/CarrotCount/CostValue.text = "%d" % carrot_cost
	$Leveling/LevelUp/FleshCounter/CostValue.text = "%d" % next_flesh_cost
	$Leveling/Next/Level/Value.text = "%d" % next_level
	$Leveling/Next/GridContainer/SpeedValue.text = "%.2f" % next_speed
	$Leveling/Next/GridContainer/DamageValue.text = "%d" % next_damage
	$Leveling/Next/GridContainer/Cost/Value.text = "%d" % next_carrot_cost

func _on_Rabbit_final_leveled_up(level: int, speed: float, damage: int, carrot_cost: int):
	$Leveling/Current/Level/Value.text = "%d" % level
	$Leveling/Current/GridContainer/SpeedValue.text = "%.2f" % speed
	$Leveling/Current/GridContainer/DamageValue.text = "%d" % damage
	$Leveling/Current/CarrotCount/CostValue.text = "%d" % carrot_cost
	$Leveling/LevelUp.visible = false
	$Leveling/Next.visible = false

func _on_Rabbit_carrot_count_changed(new_carrot_count: int):
	$Leveling/Current/CarrotCount/CountValue.text = "%d" % new_carrot_count

func _on_Rabbit_flesh_count_changed(new_flesh_count: int):
	$Leveling/LevelUp/FleshCounter/CountValue.text = "%d" % new_flesh_count
