//TODO, find a way to make this into a class of its own, because taht would make it mroe modular
//you want the spirograph to be its own class that just gets called by a function to repeat, like Shooting stars

//so the function works
var colorR,colorG,colorB;
var old_m, new_m, old_s, new_s;
var NUMSINES = 20; // how many of these things can we do at once?
var sines = new Array(NUMSINES); // an array to hold all the current angles
var rad; // an initial radius value for the central sine
var i; // a counter variable
var fund = 0.005; // the speed of the central sine
var ratio = 1; // what multiplier for speed is each additional sine?
var alpha = 50; // how opaque is the tracing system

// play with these to get a sense of what's going on:
var trace = true; // are we tracing?

var my_name;
var canvasCount;
var today = new Date();
var dd = today.getDate();
var mm = today.getMonth() + 1; //January is 0!
var yyyy = today.getFullYear();

if (dd < 10) {
  dd = '0' + dd;
}

if (mm < 10) {
  mm = '0' + mm;
}

today = yyyy + '_' + mm + '_' + dd;

//find a wa to save the canvas after each spirograph w/o having to save every frame


function setup() {
  let my_canvas = createCanvas(2560, 1440);
  canvasCount=0;
  old_m = minute();
  colorR=random(255);
  colorG=random(255);
  colorB=random(255);
  //frameRate(1);
  rad = height/4; // compute radius for central circle
  background(204); // clear the screen

  for (var i = 0; i<sines.length; i++) {
    sines[i] = PI; // start EVERYBODY facing NORTH
  }
}

function draw() {
  new_s = second();
  spirograph();
  new_m = minute();
  //how we are changing the display
  if(new_m!=old_m){
    changeSpiro();
    old_m=new_m;
  }
  if(new_s%10==0){
    savingFrames();
  }
}

function spirograph(){
  if (!trace) {
    background(204); // clear screen if showing geometry
    stroke(0, 255); // black pen
    noFill(); // don't fill
  }

  // MAIN ACTION
  push(); // start a transformation matrix
  translate(width/2, height/2); // move to middle of screen

  for (var i = 0; i<sines.length; i++) {
    var erad = 0; // radius for small "point" within circle... this is the 'pen' when tracing
    // setup for tracing
    if (trace) {
      stroke(colorR, colorG, colorB*(float(i)/sines.length), alpha); // blue
      fill(colorR, colorG, colorB, alpha/2); // also, um, blue
      erad = 5.0*(1.0-float(i)/sines.length); // pen width will be related to which sine
    }
    var radius = rad/(i+1); // radius for circle itself
    rotate(sines[i]); // rotate circle
    if (!trace) ellipse(0, 0, radius*2, radius*2); // if we're simulating, draw the sine
    push(); // go up one level
    translate(0, radius); // move to sine edge
    if (!trace) ellipse(0, 0, 5, 5); // draw a little circle
    if (trace) stroke(colorR, colorG, colorB*(float(i)/sines.length), alpha);
    if (trace) ellipse(0, 0, erad, erad); // draw with erad if tracing
    pop(); // go down one level
    translate(0, radius); // move into position for next sine
    sines[i] = (sines[i]+(fund+(fund*i*ratio)))%TWO_PI; // update angle based on fundamental
  }

  pop(); // pop down final transformation
}


function changeSpiro(){
  trace = !trace;
  background(255);
  rad = random(height/8,height/4);
  var the_options = random(0,2);
  if(the_options<1) fund = random (0.0005,0.005);
  if(the_options>1) fund = random (0.05,0.5);
  ratio - random(0.01,2);
  colorR=random(255);
  colorG=random(255);
  colorB=random(255);
  trace = !trace;
}

function savingFrames(){
  if(canvasCount<10){
    my_name=today+'_'+'canvas_'+'000'+String(canvasCount);
  } else if(canvasCount<100){
    my_name=today+'_'+'canvas_'+'00'+String(canvasCount);
  } else if(canvasCount<1000){
    my_name=today+'_'+'canvas_'+'0'+String(canvasCount);
  } else{
    my_name=today+'_'+'canvas_'+String(canvasCount);
  }
  saveCanvas(my_name,'jpg');
  canvasCount+=1;
}


//manually save canvas
function mouseClicked() {
  if(canvasCount<10){
    my_name=today+'_'+'canvas_'+'000'+String(canvasCount);
  } else if(canvasCount<100){
    my_name=today+'_'+'canvas_'+'00'+String(canvasCount);
  } else if(canvasCount<1000){
    my_name=today+'_'+'canvas_'+'0'+String(canvasCount);
  } else{
    my_name=today+'_'+'canvas_'+String(canvasCount);
  }
  saveCanvas(my_name,'jpg');
  canvasCount+=1;
}

//manually change spirographs
function keyReleased() {
  if (key==' ') {
    trace = !trace;
    background(255);
    rad = random(height/8,height/4);
    var the_options = random(0,2);
    if(the_options<1) fund = random (0.0005,0.005);
    if(the_options>1) fund = random (0.05,0.5);
    ratio - random(0.01,2);
    colorR=random(255);
    colorG=random(255);
    colorB=random(255);
  }
}
