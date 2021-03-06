/// @description Death

if (hitPoints <= 0) {
	
	// create the death object
	with (instance_create_layer(x, y, layer, obj_Stalker_Dead)) {
	
		direction = other.hitFrom;
		hsp = lengthdir_x(3, direction);
		vsp = lengthdir_y(3, direction) - 2;
		
		if (sign(hsp) != 0) {
			image_xscale = sign(hsp);
		}
	
	}
	// spawn coins
	var i;
	var dropRate;
	dropRate = random_range(1,20);
	for (i = 0; i < dropRate; i++) {
		with (instance_create_depth(random_range(x - 5, x + 5), random_range(y - 20, y - 40), layer, obj_Coin)) {
			hsp = random_range(-5, 5);
			vsp = -random_range(1, 5);
		}
	}
	instance_destroy();
}