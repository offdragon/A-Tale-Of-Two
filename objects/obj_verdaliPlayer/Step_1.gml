/// @description Death
if (global.verdali_hp <= 0) {
	state = "Respawn";
	global.verdali_hp = global.verdali_maxHp;
}