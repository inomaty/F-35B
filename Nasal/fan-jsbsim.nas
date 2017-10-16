var ffan = func{
eng = props.globals.getNode("/controls/engines/engine[0]");
var throttle   = getprop("/controls/engines/engine[0]/throttle");

if((getprop("/controls/engines/vto-switch") == 1)){
#var noz_pos = getprop("/controls/engines/vto/position-norm");
setprop("/controls/engines/engine[0]/mixture",getprop("/controls/engines/vto/position-norm"));
	if((getprop("/controls/engines/vto/position-norm")>= 0.026) and (getprop("/controls/engines/vto/position-norm")<= 0.0265 )){
	setprop("/controls/engines/vto-switch",0);
	}
}
var pitch    = 1-getprop("/controls/engines/engine[0]/mixture");
var thrust = 2*pitch-1; if (thrust<0) {thrust=0;}
var thrust1 = 95*(thrust)*D2R;
var thrust2 = math.sin(thrust1);
var rudder = getprop("/fdm/jsbsim/fcs/rudder-cmd-norm-filtered");
var elevator = 1-getprop("/controls/flight/elevator")/50;
var fan_target = throttle*thrust2*elevator;
var jetL = throttle*thrust2*(getprop("/controls/flight/aileron")/20+1); if (jetL < 0) {jetL=0;} if (jetL > 1) {jetL=1;}
var jetR = throttle*thrust2*(1-getprop("/controls/flight/aileron")/20); if (jetR < 0) {jetR=0;} if (jetR > 1) {jetR=1;}
if ((throttle > 0.99) and (pitch < 0.1))
{eng.getChild("augmentation").setBoolValue(1);}
else
{eng.getChild("augmentation").setBoolValue(0);}
if ((getprop("/fdm/jsbsim/fcs/fbw-override")==0) and (pitch > 0.1))
{
setprop("/fdm/jsbsim/fcs/fbw-override",1);
screen.log.write("FBW override ON",1,1,1);
}
if(pitch>0.5)
{
	if (getprop("/engines/engine[1]/n2") < 25) {
	setprop("/fdm/jsbsim/propulsion/engine[1]/n1",30);
	setprop("/fdm/jsbsim/propulsion/engine[2]/n1",30);
	setprop("/fdm/jsbsim/propulsion/engine[3]/n1",30);
	setprop("/fdm/jsbsim/propulsion/engine[1]/n2",60);
	setprop("/fdm/jsbsim/propulsion/engine[2]/n2",60);
	setprop("/fdm/jsbsim/propulsion/engine[3]/n2",60);
	setprop("controls/engines/engine[1]/cutoff",0);
	setprop("controls/engines/engine[2]/cutoff",0);
	setprop("controls/engines/engine[3]/cutoff",0);
	setprop("/controls/engines/engine[1]/starter",1);
	setprop("/controls/engines/engine[2]/starter",1);
	setprop("/controls/engines/engine[3]/starter",1);
	}
	else{
		setprop("/controls/engines/engine[1]/cutoff",0);
		setprop("/controls/engines/engine[2]/cutoff",0);
		setprop("/controls/engines/engine[3]/cutoff",0);
		}
}
else{
setprop("controls/engines/engine[1]/cutoff",1);
setprop("controls/engines/engine[2]/cutoff",1);
setprop("controls/engines/engine[3]/cutoff",1);
}


setprop("/fdm/jsbsim/propulsion/engine[0]/yaw-angle-rad", rudder*thrust*(-0.21));
setprop("/surface-positions/nozzle-yaw", rudder*thrust);
setprop("/fdm/jsbsim/propulsion/engine[0]/pitch-angle-rad", thrust1);
setprop("/fdm/jsbsim/fcs/throttle1", fan_target);
setprop("/fdm/jsbsim/fcs/throttle2", jetR);
setprop("/fdm/jsbsim/fcs/throttle3", jetL);
}

setlistener("/surface-positions/elevator-pos-norm", ffan);