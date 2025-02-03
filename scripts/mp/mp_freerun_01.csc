// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_load;
#using scripts\mp\_util;
#using scripts\mp\mp_freerun_01_fx;
#using scripts\mp\mp_freerun_01_sound;
#using scripts\shared\util_shared;

#namespace mp_freerun_01;

/*
	Name: main
	Namespace: mp_freerun_01
	Checksum: 0xF21B9A
	Offset: 0x140
	Size: 0x8C
	Parameters: 0
	Flags: None
*/
function main()
{
	mp_freerun_01_fx::main();
	mp_freerun_01_sound::main();
	setdvar("phys_buoyancy", 1);
	setdvar("phys_ragdoll_buoyancy", 1);
	load::main();
	util::waitforclient(0);
}

