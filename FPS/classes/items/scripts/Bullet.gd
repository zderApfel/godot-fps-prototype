class_name Bullet extends Item

@export var description: String

## If the bullet is flying
@export var is_flying: bool = false

## Bullets with this trait make heads explode with a headshot
@export var melonpopper: bool = false

@onready var muzzle_velocity: float
@onready var velocity: Vector3

func _ready():
	pass

func _physics_process(delta):
	if $RayCast3D.is_colliding():
		impact($RayCast3D.get_collider())
	
	muzzle_velocity -= muzzle_velocity*0.015
	muzzle_velocity = clamp(muzzle_velocity, 0, 9999999)
	damage[0] = clamp(damage[0]*1.015, 0, 999999)
	damage[1] = clamp(damage[1]*1.015, 0, 999999)

	fly(delta)

func fly(triangle):

	velocity = -transform.basis.z * muzzle_velocity
	transform.origin += velocity * triangle

	await get_tree().create_timer(5).timeout
	self.queue_free()
	
func impact(body):
	print(body.name)
	self.queue_free()
	if "accepting_pain" in body and body.accepting_pain == true:
		body.struck(damage, damage_type)

func _on_body_entered(body):
	impact(body)
