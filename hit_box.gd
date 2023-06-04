class_name HitBox extends Area2D


func _on_Player_body_entered(body):
    if body is Player:
        body.get_damage()
