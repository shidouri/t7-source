// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace zombie_vortex;

/*
	Name: __init__sytem__
	Namespace: zombie_vortex
	Checksum: 0x6EF02CC3
	Offset: 0x2A8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("vortex", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zombie_vortex
	Checksum: 0x4EB27C5F
	Offset: 0x2E8
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	visionset_mgr::register_visionset_info("zm_idgun_vortex" + "_visionset", 1, 30, undefined, "zm_idgun_vortex");
	visionset_mgr::register_overlay_info_style_speed_blur("zm_idgun_vortex" + "_blur", 1, 1, 0.08, 0.75, 0.9);
	clientfield::register("scriptmover", "vortex_start", 1, 2, "counter", &start_vortex, 0, 0);
	clientfield::register("allplayers", "vision_blur", 1, 1, "int", &vision_blur, 0, 0);
}

/*
	Name: start_vortex
	Namespace: zombie_vortex
	Checksum: 0xE77BF14D
	Offset: 0x408
	Size: 0x1F4
	Parameters: 7
	Flags: Linked
*/
function start_vortex(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon("entityshutdown");
	self endon("disconnect");
	if(!isdefined(newval) || newval == 0)
	{
		return;
	}
	e_player = getlocalplayer(localclientnum);
	vPosition = self.origin;
	newval = newval - oldval;
	if(newval == 2)
	{
		fx_vortex = "zombie/fx_idgun_vortex_ug_zod_zmb";
		fx_vortex_explosion = "zombie/fx_idgun_vortex_explo_ug_zod_zmb";
		n_vortex_time = 10;
	}
	else
	{
		fx_vortex = "zombie/fx_idgun_vortex_zod_zmb";
		fx_vortex_explosion = "zombie/fx_idgun_vortex_explo_zod_zmb";
		n_vortex_time = 5;
	}
	vortex_fx_handle = playfx(localclientnum, fx_vortex, vPosition);
	setfxignorepause(localclientnum, vortex_fx_handle, 1);
	playsound(0, "wpn_idgun_portal_start", vPosition);
	audio::playloopat("wpn_idgun_portal_loop", vPosition);
	self thread vortex_shake_and_rumble(localclientnum, vPosition);
	self thread function_69096485(localclientnum, vortex_fx_handle, vPosition, fx_vortex_explosion, n_vortex_time);
}

/*
	Name: vortex_shake_and_rumble
	Namespace: zombie_vortex
	Checksum: 0x41C7A406
	Offset: 0x608
	Size: 0x50
	Parameters: 2
	Flags: Linked
*/
function vortex_shake_and_rumble(localclientnum, v_vortex_origin)
{
	self endon("vortex_stop");
	while(true)
	{
		self playrumbleonentity(localclientnum, "zod_idgun_vortex_interior");
		wait(0.075);
	}
}

/*
	Name: vision_blur
	Namespace: zombie_vortex
	Checksum: 0x15CC4E49
	Offset: 0x660
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function vision_blur(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		enablespeedblur(localclientnum, 0.1, 0.5, 0.75);
	}
	else
	{
		disablespeedblur(localclientnum);
	}
}

/*
	Name: function_69096485
	Namespace: zombie_vortex
	Checksum: 0xC532640D
	Offset: 0x6F8
	Size: 0x244
	Parameters: 5
	Flags: Linked
*/
function function_69096485(localclientnum, vortex_fx_handle, vPosition, fx_vortex_explosion, n_vortex_time)
{
	e_player = getlocalplayer(localclientnum);
	n_starttime = e_player getclienttime();
	n_currtime = e_player getclienttime() - n_starttime;
	n_vortex_time = n_vortex_time * 1000;
	while(isdefined(e_player) && n_currtime < n_vortex_time)
	{
		wait(0.05);
		if(isdefined(e_player))
		{
			n_currtime = e_player getclienttime() - n_starttime;
		}
	}
	stopfx(localclientnum, vortex_fx_handle);
	audio::stoploopat("wpn_idgun_portal_loop", vPosition);
	playsound(0, "wpn_idgun_portal_stop", vPosition);
	wait(0.15);
	self notify("vortex_stop");
	var_7d342267 = playfx(localclientnum, fx_vortex_explosion, vPosition);
	setfxignorepause(localclientnum, var_7d342267, 1);
	playsound(0, "wpn_idgun_portal_explode", vPosition);
	wait(0.05);
	if(isdefined(self))
	{
		self playrumbleonentity(localclientnum, "zod_idgun_vortex_shockwave");
	}
	vision_blur(localclientnum, undefined, 1);
	wait(0.1);
	vision_blur(localclientnum, undefined, 0);
}

