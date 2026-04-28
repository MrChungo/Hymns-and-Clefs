extends Node2D

const MUSIC_NOTE_EXPLOSION_PATH = preload("uid://bm7e5uq18w0vl") #"res://Scenes/Particles/MusicNoteExplosion.tscn"
const HEAL_UP_PATH = preload("uid://cr3q3b0g8uig6")#"res://Scenes/Particles/HealthUpParticles.tscn"
const SHIELD_UP_PATH = preload("uid://h1h4bbramp3e")#"res://Scenes/Particles/ShieldAddParticle.tscn"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func play_particle_MusicNoteExplosion(location:Vector2) -> void:
	var particle = MUSIC_NOTE_EXPLOSION_PATH.instantiate()
	particle.position = location
	$".".add_child(particle)
	particle.get_node("CPUParticles2D").emitting = true
	await particle.get_node("CPUParticles2D").finished
	particle.queue_free()

func play_particle_healUp(location:Vector2) -> void:
	var particle = HEAL_UP_PATH.instantiate()
	particle.position = location
	$".".add_child(particle)
	particle.get_node("CPUParticles2D").emitting = true
	await particle.get_node("CPUParticles2D").finished
	particle.queue_free()
	
	

func play_particle_shieldUp(location:Vector2) -> void:
	var particle = SHIELD_UP_PATH.instantiate()
	particle.position = location
	$".".add_child(particle)
	particle.get_node("CPUParticles2D").emitting = true
	await particle.get_node("CPUParticles2D").finished
	particle.queue_free()
