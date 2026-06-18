extends Area2D
signal hit

@export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	# hide() # Player is hidden when game starts.

func _on_body_entered(body: Node2D) -> void:
	hide() # Player disappears after being hit.
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = _calculate_velocity()
	_move_sprite(velocity, delta)
	_play_animation(velocity)

# _process functions

# Sets the velocity based on arrow key pressed.
func _calculate_velocity() -> Vector2:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	return velocity

# Positions the player based on the velocity.
func _move_sprite(velocity: Vector2, delta: float) -> void:
	if velocity.length() > 0: 
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else: 
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

# Sets the sprite animation based on velocity vector.
func _play_animation(velocity: Vector2) -> void:
	if velocity.x != 0: # horizontal
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0  		# face left
	elif velocity.y != 0: # vertical
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0 # face down 
