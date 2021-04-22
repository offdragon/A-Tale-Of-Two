// Creates a hit box for melee attacks
function makeHitBox(startIndex, endIndex, spriteToUse, identifier, knockbackNum, lifespan, damageNum, xDir){
	if ((image_index >= startIndex) && (image_index <= endIndex)) {
		hitbox = instance_create_layer(x, y, "Hitbox", obj_hitBoxes);
		with (hitbox) {
			sprite_index = spriteToUse;
			image_xscale = xDir;
			creator = identifier;
			alarm[0] = lifespan;
			damage = damageNum;
			knockback = knockbackNum
		}
	}
}