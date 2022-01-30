extends Control

func _ready():
	var _error1 = DayNightManager.connect("day_night_changed", self, "_on_DayNightManager_day_night_changed")
	var _error2 = GameManager.connect("night_count_changed", self, "_on_GameManager_night_count_changed")
	var _error3 = GameManager.connect("villager_count_changed", self, "_on_GameManager_villager_count_changed")

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

func _on_DayNightManager_day_night_changed(is_night: bool):
	$Time/Imminent.visible = !is_night

func _on_GameManager_night_count_changed(night_count: int):
	$Time/Night/Value.text = "%d" % night_count

func _on_GameManager_villager_count_changed(villager_count: int, birth_count: int):
	$Village/VillagersValue.text = "%d" % villager_count
	$Village/BirthsValue.text = "+%d" % birth_count
