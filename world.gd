extends Node2D


func _ready():
    RenderingServer.set_default_clear_color(Color.AQUA)


func _process(delta):
    if OS.is_debug_build() and Input.is_key_pressed(KEY_F1):
        get_tree().reload_current_scene()
