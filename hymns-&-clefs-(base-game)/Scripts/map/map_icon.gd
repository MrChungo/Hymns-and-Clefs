extends Node2D
class_name MapIconNode

signal icon_hovered
signal icon_hovered_off
var enterable:bool
var icon_type: String
var icon_used: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect_icon_signals(self)

	
func _on_area_2d_mouse_entered() -> void:
	emit_signal("icon_hovered",self)




func _on_area_2d_mouse_exited() -> void:
	emit_signal("icon_hovered_off",self)
	


func setup_texture(used:bool):
	icon_used = used
	hide_all_icon_textures()
	if !icon_used:
		if enterable:
			if icon_type == "boss_battle":
				$BossIcon.visible = true
			elif icon_type == "normal_battle":
				$BattleIcon.visible = true
		else:
			if icon_type == "boss_battle":
				$BossIcon_NotNow.visible = true
			elif icon_type == "normal_battle":
				$BattleIcon_NotNow.visible = true
	else:
		$BrokenIcon.visible = true




func hide_all_icon_textures():
	$BattleIcon.visible = false
	$BattleIcon_NotNow.visible = false
	$BossIcon.visible = false
	$BossIcon_NotNow.visible = false
	$BrokenIcon.visible = false
	
		



func get_icon_lenght():
	var texture_used 
	if !icon_used:
		if enterable:
			if icon_type == "boss_battle":
				texture_used = $BossIcon
			elif icon_type == "normal_battle":
				texture_used = $BattleIcon
		else:
			if icon_type == "boss_battle":
				texture_used = $BossIcon_NotNow
			elif icon_type == "normal_battle":
				texture_used = $BattleIcon_NotNow
	else:
		texture_used = $BrokenIcon
	return (texture_used.texture.get_width() * self.scale.x)
	
	
