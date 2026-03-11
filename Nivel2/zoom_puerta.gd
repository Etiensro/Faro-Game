extends ColorRect


# Called when the node enters the scene tree for the first time.
#e with function body.


# Called every frame. 'delta' is the elapsed time since the previous fram

func _on_Button_Puerta_pressed() -> void:
	$VideoPuerta.visible = true
	$VideoPuerta.play()
