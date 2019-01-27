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
var el_center_x, el_center_y,el_sep_up, el_sep_x,el_sep_y; //movingRandomFlower variables
//var capturer = new CCapture( { format: 'jpg' , frameRate: 30} ); // a capture object to save frames

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
}

//start saving
//capturer.start();

//loop to make drawings
function draw(){

  makeBackground();
  drawMovingRectangle();
  drawMovingLine();
  randomShapeSelector();
  movingParallelLines();
  movingRandomFlower();

  saveCanvas(String(frameCount),'jpg');

  if(frameCount > 600){
    noLoop(); //this breaks us out of the drawing loop
  }

}

//capturer.stop();
//capturer.save();

//creating functions that can be reused

//function for the background
function makeBackground(){
  noStroke();
  fill(0,0,0,100); //the covering up the background, 255 all is white, 0 is black
  rect(width/2,height/2,width,height); //we just draw a rectangle over the screen
}

//function for a swirlign rectangle
function drawMovingRectangle(){
  angle+=speed;

  var x=width/2+sin(angle)*width/3;
  var y=height/2+cos(angle)*height/4;

  //making a rectangle
  fill(r,g,b);
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
function drawMovingLine(){
    //drawing a line
  stroke(255,255,255);
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
function randomBezierShape(){
    stroke(random(255), random(255), random(255)); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    fill(random(255), random(255), random(255));

    beginShape();
    vertex(random(width),random(height));
    randomBezierVertices(int(random(4,25))); //curves must have at least 4 points
    endShape(CLOSE);
}

function randomCurvyShape(){
    //make a random curvy shape
    stroke(random(255), random(255), random(255)); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    fill(random(255), random(255), random(255));

    beginShape();
    randomCurveVertices(int(random(4,25))); //curves must have at least 4 points
    endShape(CLOSE);
}

function randomShape(){
    //make a random shape

    stroke(random(255), random(255), random(255)); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    fill(random(255), random(255), random(255));

    beginShape();
    randomVertices(int(random(3,25)));
    endShape(CLOSE);
}

function randomCurveLine(){
    //make a random curvy line
    stroke(random(255), random(255), random(255)); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    curve(random(width), random(height), random(width), random(height), random(width), random(height),random(width), random(height));
}

function randomBezierLine(){
   //make a random bezier line
    stroke(random(255), random(255), random(255)); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    bezier(random(width), random(height), random(width), random(height), random(width), random(height),random(width), random(height));
}

function randomStraightLine(){
    //make a random straight line
    stroke(random(255), random(255), random(255)); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    line(random(width), random(height), random(width), random(height));
}

function randomArc(){
    fill(random(255), random(255), random(255)); //makes a random RGB color

    //random dimensions for the arc
    var x_1 = random(width);
    var y_1 = random(height);
    var w_1 = random(width);
    var h_1 = random(height);

    //making a random arc
    arc(x_1, y_1, x_1, h_1, random(6.283185), random(6.283185), PIE);
}

function randomQuad(){
  noStroke();
  fill(random(255), random(255), random(255)); //makes a random RGB color

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

function randomEllipse(){
    //making and placing a random ellipse
    fill(random(255), random(255), random(255)); //makes a random RGB color
    var sz_1 = random(width); //making a variable for the rectangle size
    var sz_2 = random(height); //another variable for rectangle dimensions

    //width and height are system variables, and we can use them to randomly place an ellipse
    ellipse(random(width), random(height), sz_1, sz_2);
}

function randomRectangle(){
    //making and placing a random rectangle
    fill(random(255), random(255), random(255)); //makes a random RGB color
    var sz_1 = random(width); //making a variable for the rectangle size
    var sz_2 = random(height); //another variable for rectangle dimensions

    //width and height are system variables, and we can use them to randomly place a rect
    rect(random(width), random(height), sz_1, sz_2);
}

function randomShapeSelector(){
  //a function that randomly generates a shape
  var choice = int(random(1,10)); //we have three options
  if(choice==0){
    randomRectangle();
  } else if(choice==1){
    randomEllipse();
  } else if(choice==2){
    randomQuad();
  } else if(choice==3){
    randomArc();
  } else if(choice==4){
    randomStraightLine();
  } else if(choice==5){
    randomBezierLine();
  } else if(choice==6){
    randomCurveLine();
  } else if(choice==7){
    randomShape();
  } else if(choice==8){
    randomCurvyShape();
  } else if(choice==9){
    randomBezierShape();
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

  el_center_x=el_center_x-width/100;
  el_center_y=el_center_y-height/100;

  if(el_center_x<1){
    el_center_x=width;
    el_center_y=height;
  }

  if(el_center_y<1){
    el_center_x=width;
    el_center_y=height;
  }
}

//TODO, make more functions for moving patterns, like flowers and trees
