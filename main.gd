extends Node

@export var mob_scene: PackedScene;

var score = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass;

func game_over():
	$ScoreTimer.stop();
	$MobTimer.stop();
	$HUD.show_game_over();
	$Music.stop();
	$DeathSound.play();

func new_game():
	$HUD.update_score(score);
	$HUD.show_message("Get Ready")
	score = 0;
	$Player.start($StartPosition.position);
	$StartTimer.start();
	get_tree().call_group("mobs", "queue_free");
	$Music.play();

func _on_score_timer_timeout():
	score += 1;
	$HUD.update_score(score);

func _on_start_timer_timeout():
	$MobTimer.start();
	$ScoreTimer.start();

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate();
	
	var mob_spawn_location = $MobPath/MobSpawnLocation;
	mob_spawn_location.progress_ratio = randf();
	
	mob.position = mob_spawn_location.position;
	
	var direction = mob_spawn_location.rotation + PI / 2;
	
	direction += randf_range(-PI / 4, PI / 4);
	mob.rotation = direction;
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0);
	mob.linear_velocity = velocity.rotated(direction);
	
	add_child(mob);
