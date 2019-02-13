//TODO, find a way to make this into a class of its own, because taht would make it mroe modular
//you want the spirograph to be its own class that just gets called by a function to repeat, like Shooting stars

//so the functions work
var angle, speed, line_y,line_x; //variables necessary to control the movement of shapes
var r, g, b; //variables for control of color
var the_cc; //variable for color change
var el_center_x, el_center_y,el_sep_up, el_sep_x,el_sep_y, move_el_x,move_el_y; //movingRandomFlower variables
var colorR,colorG,colorB;
var old_m, new_m, old_s, new_s;
var NUMSINES = 20; // how many of these things can we do at once?
var sines = new Array(NUMSINES); // an array to hold all the current angles
var rad; // an initial radius value for the central sine
var i; // a counter variable
var fund = 0.005; // the speed of the central sine
var ratio = 1; // what multiplier for speed is each additional sine?
var alpha = 50; // how opaque is the tracing system
var spir_x = 0;
var spir_y = 0;
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

  ellipseMode(CENTER);
  rectMode(CENTER);
  angle=0;
  speed=0.04; //establishing how fast everythign will move in drawMovingRectangle
  r=255; //all three RGB to 255 so it all begins as white
  g=255; //used in drawMovingRectangle
  b=255; //used in drawMovingRectangle
  the_cc=0; //variable for color changes in drawMovingRectangle
  line_y=height/2; //used in drawMovingLine function
  line_x=width/2; //used in movingParallelLines function
  el_center_x=width/2; //movingRandomFlower variables
  el_center_y=height/2;
  el_sep_x=100;
  el_sep_y=100;
  move_el_x= -width/100;
  move_el_y= -height/110;

  for (var i = 0; i<sines.length; i++) {
    sines[i] = PI; // start EVERYBODY facing NORTH
  }

  for (let i = 0; i < 200; i++) {
    stars.push(new Shootingstars());
  }

  strokeWeight(random(width/width,width/100));
}

function draw() {
  new_s = second();
  //background(random(255),random(255),random(255),random(5,10));
  spirograph();
  magicCircles(random(0,width), random(0,height), random(width/5));
  //moveStars();
  //randomShapeSelector();
  //waves();
  new_m = minute();
  //how we are changing the display
  if(new_m!=old_m){
    changeSpiro();
    strokeWeight(random(width/width,width/100));
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
    if (trace) ellipse(spir_x, spir_y, erad, erad); // draw with erad if tracing
    pop(); // go down one level
    translate(spir_x, radius); // move into position for next sine
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
  background(random(255),random(255),random(255),random(50,75));
  rad = random(height/8,height/4);
  var the_options = random(0,2);
  if(the_options<1) fund = random (0.0005,0.005);
  if(the_options>1) fund = random (0.05,0.5);
  ratio - random(0.01,2);
  colorR=random(255);
  colorG=random(255);
  colorB=random(255);
  spir_x=random(-width/2,width/2)
  spir_y=random(-height/2,height/2)
  trace = !trace;
}

//function for a swirlign rectangle
function drawMovingRectangle(thea){
  angle+=speed;

  var x=width/2+sin(angle)*width/3;
  var y=height/2+cos(angle)*height/4;

  //making a rectangle
  fill(r,g,b,thea);
  noStroke();
  rect(x,y,width/8,height/8);

    //changing colors
  the_cc=int(random(0,6));

  if(the_cc==0){
    r-=5;
  } else if(the_cc==1){
    r+=5;
  } else if(the_cc==2){
    g-=5;
  } else if(the_cc==3){
    g+=5;
  } else if(the_cc==4){
    b-=5;
  } else if(the_cc==5){
    b+=5;
  }

  //resetting colors
  if(b<10){
    b=255;
  }
  if(r<10){
    r=255;
  }
  if(g<10){
    g=255;
  }
}

//function to create a line that moves up and down
function drawMovingLine(thea){
    //drawing a line
  stroke(255,255,255,thea);
  strokeWeight(4);
  line(0,line_y,width,line_y);
  line_y=line_y-2;
  if(line_y<0){
    line_y=height;
  }
}

//first function necessary to make complex random shapes
function randomVertices(level){ //making a function to generate random vertices to be used in makign random shapes
  vertex(random(width), random(height));
  if (level>1){
    level = level -1;
    randomVertices(level);
  }
}

//second function necessary to make complex random shapes
function randomCurveVertices(level){ //making a function to generate random curve vertices to be used in makign random shapes
  curveVertex(random(width), random(height));
  if (level>1){
    level = level -1;
    randomCurveVertices(level);
  }
}

//third function necessary to make complex random shapes
function randomBezierVertices(level){ //making a function to generate random curve vertices to be used in makign random shapes
  bezierVertex(random(width), random(height),random(width),random(height),random(width),random(height));
  if (level>1){
    level = level -1;
    randomBezierVertices(level);
  }
}

//a whole bunch of shape functions
function randomBezierShape(thea){
    stroke(random(255), random(255), random(255),thea); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    fill(random(255), random(255), random(255),thea);

    beginShape();
    vertex(random(width),random(height));
    randomBezierVertices(int(random(4,25))); //curves must have at least 4 points
    endShape(CLOSE);
}

function randomCurvyShape(thea){
    //make a random curvy shape
    stroke(random(255), random(255), random(255),thea); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    fill(random(255), random(255), random(255),thea);

    beginShape();
    randomCurveVertices(int(random(4,25))); //curves must have at least 4 points
    endShape(CLOSE);
}

function randomShape(thea){
    //make a random shape

    stroke(random(255), random(255), random(255),thea); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    fill(random(255), random(255), random(255),thea);

    beginShape();
    randomVertices(int(random(3,25)));
    endShape(CLOSE);
}

function randomCurveLine(thea){
    //make a random curvy line
    stroke(random(255), random(255), random(255)),thea; //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    curve(random(width), random(height), random(width), random(height), random(width), random(height),random(width), random(height));
}

function randomBezierLine(thea){
   //make a random bezier line
    stroke(random(255), random(255), random(255),thea); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    bezier(random(width), random(height), random(width), random(height), random(width), random(height),random(width), random(height));
}

function randomStraightLine(thea){
    //make a random straight line
    stroke(random(255), random(255), random(255),thea); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    line(random(width), random(height), random(width), random(height));
}

function randomArc(thea){
    fill(random(255), random(255), random(255), thea); //makes a random RGB color

    //random dimensions for the arc
    var x_1 = random(width);
    var y_1 = random(height);
    var w_1 = random(width);
    var h_1 = random(height);

    //making a random arc
    arc(x_1, y_1, x_1, h_1, random(6.283185), random(6.283185), PIE);
}

function randomQuad(thea){
  noStroke();
  fill(random(255), random(255), random(255), thea); //makes a random RGB color

  //random dimensions for the quad
  var x_1 = random(width);
  var y_1 = random(height);
  var x_2 = random(width);
  var y_2 = random(height);
  var x_3 = random(width);
  var y_3 = random(height);
  var x_4 = random(width);
  var y_4 = random(height);

  //making a random quad
  quad(x_1, y_1, x_2, y_2, x_3, y_3, x_4, y_4);
}

function randomEllipse(thea){
    //making and placing a random ellipse
    fill(random(255), random(255), random(255),thea); //makes a random RGB color
    var sz_1 = random(width); //making a variable for the rectangle size
    var sz_2 = random(height); //another variable for rectangle dimensions

    //width and height are system variables, and we can use them to randomly place an ellipse
    ellipse(random(width), random(height), sz_1, sz_2);
}

function randomRectangle(thea){
    //making and placing a random rectangle
    fill(random(255), random(255), random(255), thea); //makes a random RGB color
    var sz_1 = random(width); //making a variable for the rectangle size
    var sz_2 = random(height); //another variable for rectangle dimensions

    //width and height are system variables, and we can use them to randomly place a rect
    rect(random(width), random(height), sz_1, sz_2);
}

function randomShapeSelector(){
  //a function that randomly generates a shape
  var choice = int(random(1,10)); //we have three options
  var filler = int(random(2,15)); //filler alpha value
  if(choice==0){
    randomRectangle(filler);
  } else if(choice==1){
    randomEllipse(filler);
  } else if(choice==2){
    randomQuad(filler);
  } else if(choice==3){
    randomArc(filler);
  } else if(choice==4){
    randomStraightLine(filler);
  } else if(choice==5){
    randomBezierLine(filler);
  } else if(choice==6){
    randomCurveLine(filler);
  } else if(choice==7){
    randomShape(filler);
  } else if(choice==8){
    randomCurvyShape(filler);
  } else if(choice==9){
    randomBezierShape(filler);
  }
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
