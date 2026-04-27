extends Node2D

const MUSIC_NOTE_EXPLOSION_PATH = preload("uid://bm7e5uq18w0vl") #"res://Scenes/Particles/MusicNoteExplosion.tscn"



# Called every frame. 'delta' is the elapsed time since the previous frame.
func play_particle_MusicNoteExplosion(location:Vector2):
	var particle = MUSIC_NOTE_EXPLOSION_PATH.instantiate()
	particle.position = location
	particle.scale = Vector2(16,16)
	$".".add_child(particle)
	particle.get_node("CPUParticles2D").emitting = true
	await particle.get_node("CPUParticles2D").finished
	particle.queue_free()
