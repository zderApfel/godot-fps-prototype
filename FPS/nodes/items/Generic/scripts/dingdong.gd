extends Item

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	type = "Generic"

func _process(_delta):
	pass

func primary_action():
	if Input.is_action_just_pressed("primary_action"):
		print("Primary Action")

func secondary_action():
	if Input.is_action_just_pressed("secondary_action"):
		print("Secondary Action")
