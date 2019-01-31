/*
aids in figuring this out are as follows:
this was used to help me make the animation and save frames
https://funprogramming.org/114-How-to-create-movies-using-Processing.html
this discussion and code from user JR were used to figure out the fading
this method is not recommended b/c call to createGraphics inside draw() is hard on memory
https://processing.org/discourse/beta/num_1265045578.html, not recommended
maybe one of these methods from StackOverflow could be used
https://stackoverflow.com/questions/9215231/making-a-fading-trail-in-processing
and of course the documenttation for the language
https://www.processing.org/reference/
credit to https://p5js.org and https://github.com/processing/p5.js/wiki/Processing-transition
*/


//TODO, make more functions for patterned moving shapes, not just random

//establishing a few variables necessary for the functions
var angle, speed, line_y,line_x; //variables necessary to control the movement of shapes
var r, g, b; //variables for control of color
var the_cc; //variable for color change
var el_center_x, el_center_y,el_sep_up, el_sep_x,el_sep_y, move_el_x,move_el_y; //movingRandomFlower variables
var my_name; //variable to make namign files easier and more informative
let stars = []; // array of Shootingstars objects

//variables to make naming files easier, https://stackoverflow.com/questions/1531093/how-do-i-get-the-current-date-in-javascript
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



//setting up the drawing background and parameters
function setup(){
  createCanvas(2560, 1440); //changing the size and dimension so it displays better in YouTube
  background(0,0,0); //starting with a black background
  frameRate(30);
  noStroke();
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
  for (let i = 0; i < 200; i++) {
    stars.push(new Shootingstars());
  }
}


//loop to make drawings
function draw(){

  makeBackground(50);
  drawMovingRectangle(100);
  drawMovingLine(100);
  randomShapeSelector();
  movingParallelLines();
  movingRandomFlower();
  moveStars();

  if(frameCount<10){
    my_name=today+'_'+'frame_'+'000'+String(frameCount);
  } else if(frameCount<100){
    my_name=today+'_'+'frame_'+'00'+String(frameCount);
  } else if(frameCount<1000){
    my_name=today+'_'+'frame_'+'0'+String(frameCount);
  } else{
    my_name=today+'_'+'frame_'+String(frameCount);
  }

  saveCanvas(my_name,'jpg');

  if(frameCount > 800){
    noLoop(); //this breaks us out of the drawing loop
  }

}

//capturer.stop();
//capturer.save();

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
    this.starAlpha = random(50,100);
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

//creating functions that can be reused

//function for the background
function makeBackground(thea){
  rectMode(CENTER);
  noStroke();
  fill(random(255),random(255),random(255),thea); //the covering up the background, 255 all is white, 0 is black
  rect(width/2,height/2,width,height); //we just draw a rectangle over the screen
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
  var filler = int(random(50,100)); //filler alpha value
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

function movingParallelLines(){

  //line colors
  stroke(255,200,200);
  strokeWeight(5);

  line(line_x+10,0,line_x+10,height);
  line(line_x-10,0,line_x-10,height);

  line_x=line_x-10;

  if(line_x<10){
    line_x=width;
  }

}

function movingRandomFlower(){

  fill(random(255),random(255),random(255)); //center circle color
  ellipse(el_center_x,el_center_y,100,100); //center cirle
  fill(random(255),random(255),random(255));
  ellipse(el_center_x,el_center_y+el_sep_y,100,100); //up
  fill(random(255),random(255),random(255));
  ellipse(el_center_x,el_center_y-el_sep_y,100,100); //down
  fill(random(255),random(255),random(255));
  ellipse(el_center_x+el_sep_x,el_center_y,100,100); //left
  fill(random(255),random(255),random(255));
  ellipse(el_center_x-el_sep_x,el_center_y,100,100); //right

  el_center_x=el_center_x+move_el_x;
  el_center_y=el_center_y+move_el_y;

  el_sep_y-=10; //make the flower petals move inwards
  el_sep_x-=10;

  if(el_sep_x<10){ //reset the petals to outwards
    el_sep_x=200;
  }

  if(el_sep_y<10){
    el_sep_y=200;
  }

  //idea thanks to https://funprogramming.org/15-Ball-bouncing-at-the-window-borders.html
  if(el_center_x<0){
    move_el_x= -move_el_x;
  }
  if(el_center_x>width){
    move_el_x= -move_el_x;
  }
  if(el_center_y<0){
    move_el_y= -move_el_y;
  }
  if(el_center_y>height){
    move_el_y= -move_el_y;
  }
}

function moveStars(){
  for (let i = 0; i < stars.length; i++) {
    stars[i].move();
    stars[i].display();
  }
}

//TODO, make more functions for moving patterns, like flowers and trees
