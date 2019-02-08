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
var alpha = 100; // how opaque is the tracing system
let wave_t = 0; //variable for waves
let stars = []; // array of Shootingstars objects

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
  background(255); // clear the screen

  for (var i = 0; i<sines.length; i++) {
    sines[i] = PI; // start EVERYBODY facing NORTH
  }
  for (let i = 0; i < 200; i++) {
    stars.push(new Shootingstars());
  }
}

function draw() {
  new_s = second();
  spirograph();
  magicCircles(random(0,width), random(0,height), random(width/5));
  moveStars();
  //waves();
  new_m = minute();
  //how we are changing the display
  if(new_m!=old_m){
    changeSpiro();
    old_m=new_m;
  }
  if(new_s%10==0){
    savingFrames();
  }
  if(canvasCount > 800){
    noLoop(); //this breaks us out of the drawing loop
  }
}

// Shootingstars class //inspired by https://p5js.org/examples/objects-array-of-objects.html and
//https://funprogramming.org/58-Travel-through-space-use-an-array-to-move-stars.html
class Shootingstars { //when moving this over into the official script, you must have the class before the functions
  constructor() {
    this.x = random(width);
    this.y = random(height);
    this.diameterx = random(width/width, width/100);
    this.diametery = random(height/height, height/100);
    this.speedx = random(5,15);
    this.speedy = random(5,15);
    this.colorR = random(255);
    this.colorG = random(255);
    this.colorB = random(255);
    this.starAlpha = random(0,10);
  }

  move() {
    this.x += this.speedx;
    this.y += this.speedy;
    if(this.x<0){
      this.speedx= -this.speedx;
    }
    if(this.x>width){
      this.speedx= -this.speedx;
    }
    if(this.y<0){
      this.speedy= -this.speedy;
    }
    if(this.y>height){
      this.speedy= -this.speedy;
    }
  }

  display() {
    noStroke();
    fill(this.colorR,this.colorG,this.colorB,this.starAlpha);
    ellipse(this.x, this.y, this.diameterx, this.diametery);
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
      fill(colorR, colorG, colorB, alpha/1); // also, um, blue
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

function magicCircles(mx, my, msz){
  var innera, innerx, innery;
  var loopsie = int(random(1,4));
  noStroke();
  fill(random(255),random(255),random(255),random(0,10));
  ellipseMode(CENTER);
  ellipse(mx,my,random(msz/2,msz),random(msz/2,msz));
  if(msz>1){
    for(let i=0; i<loopsie; i++){
      innera = random(TWO_PI);
      innerx = mx + msz/2 * sin(innera);
      innery = my + msz/2 * cos(innera);
      magicCircles(innerx,innery,msz/2);
    }
  }
}

function moveStars(){
  for (let i = 0; i < stars.length; i++) {
    stars[i].move();
    stars[i].display();
  }
}

//credit: https://p5js.org/examples/interaction-wavemaker.html
function waves(){
  // make a x and y grid of ellipses
  for (let x = 0; x <= width; x = x + 30) {
    for (let y = 0; y <= height; y = y + 30) {
      // starting point of each circle depends on mouse position
      let xAngle = map(mouseX, 0, width, -4 * PI, 4 * PI, true);
      let yAngle = map(mouseY, 0, height, -4 * PI, 4 * PI, true);
      // and also varies based on the particle's location
      let angle = xAngle * (x / width) + yAngle * (y / height);

      // each particle moves in a circle
      let myX = x + 20 * cos(2 * PI * wave_t + angle);
      let myY = y + 20 * sin(2 * PI * wave_t + angle);

      ellipse(myX, myY, 10); // draw particle
    }
  }
    wave_t = wave_t + 0.01; // update time
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
