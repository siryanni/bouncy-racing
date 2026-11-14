extends CharacterBody2D


func _physics_process(delta: float) -> void:
	print("Processing tick:\n global_position:"+str(global_position)+"\n velocity:"+str(velocity)+"\n rotation:"+str(rotation_degrees))
	
	# process friction 
	if(velocity.x>0):velocity.x-=1;
	if(velocity.y>0):velocity.y-=1;
	
	if(velocity.x<0):velocity.x+=1;
	if(velocity.y<0):velocity.y+=1;
	
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	
	#process rotation changes
	if(direction[0]<0):rotation_degrees=rotation_degrees-1;
	if(direction[0]>0):rotation_degrees=rotation_degrees+1;
	
	#process velocity changes
	var totalAdditionalVelocity=1;
	if(direction[1]>0): totalAdditionalVelocity=10;#forward
	if(direction[1]<0):totalAdditionalVelocity=-10#backward

	velocity.x += cos(rotation) * totalAdditionalVelocity
	velocity.y += sin(rotation) * totalAdditionalVelocity
	move_and_slide()

func _on_boundaries_area_entered(area: Area2D) -> void:
	print("collided")
	velocity.x=-velocity.x
	velocity.y=-velocity.y
	return;	
