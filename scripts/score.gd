extends Label


func _process(delta):
	self.text = str(Globalvar.score)  + " / 20 houses built"
	
