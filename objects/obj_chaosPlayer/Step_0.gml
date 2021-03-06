/// @description Control movement and actions for chaos
global.current_state = PlayerState.Chaos;
// get input
key_return = keyboard_check_pressed(ord("R")); // return back to Verdali

switch(state) {
	
	case "Move":
		// calculate direction
		hDir = input.key_right - input.key_left;
		vDir = input.key_down - input.key_up;

		// 8-direction movement
		if (hDir != 0 || vDir != 0){
			dir = point_direction(0, 0, hDir, vDir);
			moveX = lengthdir_x(moveSpeed, dir);
			moveY = lengthdir_y(moveSpeed, dir);

			x += moveX;
			y += moveY;
	
		}

		// magic projectile attack limit attack based on mp
		if (input.key_magic && global.chaos_mp > 0) {
			state = "Magic";	
		}

		// move back to verdali upon key_return press
		if (key_return) {
			move_towards_point(verdali_location.x, verdali_location.y, return_speed);
			returning = true;
		}

		// return if hp is depleted
		if (global.chaos_hp <= 0) {
			dir = point_direction(x, y, verdali_location.x, verdali_location.y);
			dir = roundDir(dir);
			move_towards_point(verdali_location.x, verdali_location.y, return_speed);
			returning = true;
		}

		// return if mp is depleted
		if (global.chaos_mp <= 0) {
			dir = point_direction(x, y, verdali_location.x, verdali_location.y);
			dir = roundDir(dir);
			move_towards_point(verdali_location.x, verdali_location.y, return_speed);
			returning = true;
		}

		// destroy instance once within range, also hide and deactivate corruption layer
		if (returning) {
			screenShake(1, 10);
			if (distance_to_object(obj_verdaliPlayer) < destroy_range) {
				screenShake(2, 10);
				global.current_state = PlayerState.Verdali;
				layer_set_visible(corruption_layer, false);
				instance_deactivate_layer(corruption_layer);
				instance_destroy();
			}
		}
		break;

}


// Update Animations
switch (state) {
	#region Move
	case "Move":
		image_xscale = 1;
		switch(dir) {
			case 0:
				changeSprite(0.5, spr_Chaos_Right);
				break;
			case 45:
				changeSprite(0.5, spr_Chaos_UpRight);
				break;
			case 90:
				changeSprite(0.5, spr_Chaos_Up);
				break;
			case 135:
				changeSprite(0.5, spr_Chaos_UpRight);
				image_xscale = -1;
				break;
			case 180:
				changeSprite(0.5, spr_Chaos_Right);
				image_xscale = -1;
				break;
			case 225:
				changeSprite(0.5, spr_Chaos_DownRight);
				image_xscale = -1;
				break;
			case 270:
				changeSprite(0.5, spr_Chaos_Down);
				break;
			case 315:
				changeSprite(0.5, spr_Chaos_DownRight);
				break;
		}

		if (hDir == 0 && vDir == 0 && !returning) {
			changeSprite(0.2, spr_Chaos_Idle);
		}
		break;
	#endregion
	#region Magic
	case "Magic":
		changeSprite(0.2, spr_Chaos_Cast);
		
		if (animationHitFrame(3)) {
			spawnProjectile(25, 0, obj_Magic_Blast, self);
		}
		
		if (animationEnd()) {
			state = "Move";
			image_index = 0;
		}
		break;
	#endregion
	#region Hurt
	case "Hurt":
		changeSprite(1, spr_Chaos_Hurt);
		
		// apply the speed and check for collisions
		knockback_speed = approach(knockback_speed, 0, 0.1);
		hDir = knockback_speed * image_xscale;
		vDir = knockback_speed;
		
		// 8-direction movement
		if (hDir != 0 || vDir != 0){
			dir = point_direction(0, 0, hDir, vDir);
			moveX = lengthdir_x(knockback_speed, dir);
			moveY = lengthdir_y(knockback_speed, dir);

			x += moveX;
			y += moveY;
	
		}
	
		// change the state
		if (knockback_speed == 0) {
			state = "Move";
		}
		break;
	#endregion
}

