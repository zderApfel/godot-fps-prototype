extends Area3D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.monitoring = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for x in get_overlapping_bodies():
		if Input.is_action_just_pressed("loot") and x is RigidBody3D and x.SELF.TRAITS.IS_LOOTABLE:
			Inventory.INVENTORY.append(x.SELF)
			x.queue_free()