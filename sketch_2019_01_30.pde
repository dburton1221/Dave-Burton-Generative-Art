//aids in figuring this out are as follows:
//this was used to help me make the animation and save frames
//https://funprogramming.org/114-How-to-create-movies-using-Processing.html
//this discussion and code from user JR were used to figure out the fading
//this method is not recommended b/c call to createGraphics inside draw() is hard on memory
//https://processing.org/discourse/beta/num_1265045578.html, not recommended
//maybe one of these methods from StackOverflow could be used
//https://stackoverflow.com/questions/9215231/making-a-fading-trail-in-processing
//and of course the documenttation for the language
//https://www.processing.org/reference/

//TODO, make more functions for patterned moving shapes, not just random

//establishing a few variables necessary for the functions
float angle, speed, line_y,line_x; //variables necessary to control the movement of shapes
float R, G, B; //variables for control of color
int the_cc; //variable for color change
float el_center_x, el_center_y,el_sep_up, el_sep_x,el_sep_y,move_el_x,move_el_y; //movingRandomFlower variables
Shootingstars[] stars; //variables at the top

//setting up the drawing background and parameters
void setup(){
  size(2560, 1440); //changing the size and dimension so it displays better in YouTube
  background(0,0,0); //starting with a black background
  frameRate(30);
  noStroke();
  ellipseMode(CENTER);
  rectMode(CENTER);
  speed=0.04; //establishing how fast everythign will move in drawMovingRectangle
  R=255; //all three RGB to 255 so it all begins as white
  G=255; //used in drawMovingRectangle
  B=255; //used in drawMovingRectangle
  the_cc=0; //variable for color changes in drawMovingRectangle
  line_y=height/2; //used in drawMovingLine function
  line_x=width/2; //used in movingParallelLines function
  el_center_x=width/2; //movingRandomFlower variables
  el_center_y=height/2;
  el_sep_x=100;
  el_sep_y=100;
  move_el_x= -width/100;
  move_el_y= -height/110;
  stars = new Shootingstars[200]; //this goes inside of setup
  for(int i=0; i<200; i++){ //loop to make the new objects
  stars[i]= new Shootingstars();
  }
}

//loop to make drawings
void draw(){
  
  //makeBackground(50);
  drawMovingRectangle();
  drawMovingLine();
  randomShapeSelector();
  movingParallelLines();
  movingRandomFlower();
  moveStars();

  
  saveFrame("frame-####.jpg"); //saves frame as a jpeg
  
  
  if(frameCount > 600){ 
    noLoop(); //this breaks us out of the drawing loop
  }
  
}


//TODO, try creating a new class for flocking behavior

//creating classes functions that can be reused

//making a class of shootingstars
class Shootingstars { //when moving this over into the official script, you must have the class before the functions
 
 //variables
 float x,y,diameterx,diametery,speedx,speedy,colorR,colorG,colorB;
 
 //constructor
 Shootingstars(){
    x = random(width);
    y = random(height);
    diameterx = random(width/width, width/100);
    diametery = random(height/height,height/100);
    speedx = random(5,15);
    speedy = random(5,15);
    colorR = random(255);
    colorG = random(255);
    colorB = random(255);
 }
  
  //methods
  void move_now() {
    x += speedx;
    y += speedy;
    if(x<0){
      speedx= -speedx;
    }
    if(x>width){
      speedx= -speedx;
    }
    if(y<0){
      speedy= -speedy;
    }
    if(y>height){
      speedy= -speedy;
    }
  }

  void display_now() {
    noStroke();
    fill(colorR,colorG,colorB);
    ellipseMode(CENTER);
    ellipse(x, y, diameterx, diametery);
  }
}

//function for the background
void makeBackground(int thea){
  noStroke();
  fill(random(255),random(255),random(255),thea); //the covering up the background, 255 all is white, 0 is black
  rect(width/2,height/2,width,height); //we just draw a rectangle over the screen
}

//function for a swirlign rectangle
void drawMovingRectangle(){
  angle+=speed;

  float X=width/2+sin(angle)*width/3;
  float Y=height/2+cos(angle)*height/4;
  
  //making a rectangle
  fill(R,G,B);
  noStroke();
  rect(X,Y,width/8,height/8);
  
    //changing colors
  the_cc=int(random(0,6));
  
  if(the_cc==0){
    R-=5;
  } else if(the_cc==1){
    R+=5;
  } else if(the_cc==2){
    G-=5;
  } else if(the_cc==3){
    G+=5;
  } else if(the_cc==4){
    B-=5;
  } else if(the_cc==5){
    B+=5;
  }
  
  //resetting colors
  if(B<10){
    B=255;
  }
  if(R<10){
    R=255;
  }
  if(G<10){
    G=255;
  }
}

//function to create a line that moves up and down
void drawMovingLine(){
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
void randomVertices(int level){ //making a function to generate random vertices to be used in makign random shapes
  vertex(random(width), random(height));
  if (level>1){
    level = level -1;
    randomVertices(level);
  }
}

//second function necessary to make complex random shapes
void randomCurveVertices(int level){ //making a function to generate random curve vertices to be used in makign random shapes
  curveVertex(random(width), random(height));
  if (level>1){
    level = level -1;
    randomCurveVertices(level);
  }
}

//third function necessary to make complex random shapes
void randomBezierVertices(int level){ //making a function to generate random curve vertices to be used in makign random shapes
  bezierVertex(random(width), random(height),random(width),random(height),random(width),random(height));
  if (level>1){
    level = level -1;
    randomBezierVertices(level);
  }
}

//a whole bunch of shape functions
void randomBezierShape(){
    stroke(random(255), random(255), random(255)); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    fill(random(255), random(255), random(255));
    
    beginShape(); 
    vertex(random(width),random(height));
    randomBezierVertices(int(random(4,25))); //curves must have at least 4 points
    endShape(CLOSE);
}

void randomCurvyShape(){
    //make a random curvy shape
    stroke(random(255), random(255), random(255)); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    fill(random(255), random(255), random(255));
    
    beginShape(); 
    randomCurveVertices(int(random(4,25))); //curves must have at least 4 points
    endShape(CLOSE);
}

void randomShape(){
    //make a random shape
    
    stroke(random(255), random(255), random(255)); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    fill(random(255), random(255), random(255));
    
    beginShape(); 
    randomVertices(int(random(3,25)));
    endShape(CLOSE);
}

void randomCurveLine(){
    //make a random curvy line
    stroke(random(255), random(255), random(255)); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    curve(random(width), random(height), random(width), random(height), random(width), random(height),random(width), random(height));
}

void randomBezierLine(){
   //make a random bezier line
    stroke(random(255), random(255), random(255)); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    bezier(random(width), random(height), random(width), random(height), random(width), random(height),random(width), random(height));
}

void randomStraightLine(){
    //make a random straight line
    stroke(random(255), random(255), random(255)); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    line(random(width), random(height), random(width), random(height));
}

void randomArc(){
    fill(random(255), random(255), random(255)); //makes a random RGB color
    
    //random dimensions for the arc
    float x_1 = random(width);
    float y_1 = random(height);
    float w_1 = random(width);
    float h_1 = random(height);

    //making a random arc
    arc(x_1, y_1, x_1, h_1, random(6.283185), random(6.283185), PIE);
}

void randomQuad(){
  noStroke();
  fill(random(255), random(255), random(255)); //makes a random RGB color
    
  //random dimensions for the quad
  float x_1 = random(width);
  float y_1 = random(height);
  float x_2 = random(width);
  float y_2 = random(height);
  float x_3 = random(width);
  float y_3 = random(height);
  float x_4 = random(width);
  float y_4 = random(height);
  
  //making a random quad
  quad(x_1, y_1, x_2, y_2, x_3, y_3, x_4, y_4);
}

void randomEllipse(){
    //making and placing a random ellipse
    fill(random(255), random(255), random(255)); //makes a random RGB color
    float sz_1 = random(width); //making a variable for the rectangle size
    float sz_2 = random(height); //another variable for rectangle dimensions
    
    //width and height are system variables, and we can use them to randomly place an ellipse
    ellipse(random(width), random(height), sz_1, sz_2);
}

void randomRectangle(){
    //making and placing a random rectangle
    fill(random(255), random(255), random(255)); //makes a random RGB color
    float sz_1 = random(width); //making a variable for the rectangle size
    float sz_2 = random(height); //another variable for rectangle dimensions
    
    //width and height are system variables, and we can use them to randomly place a rect
    rect(random(width), random(height), sz_1, sz_2);
}

void randomShapeSelector(){
  //a function that randomly generates a shape
  int choice = int(random(1,10)); //we have three options
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

void movingParallelLines(){

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

void movingRandomFlower(){
  
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

void moveStars() {
  for (Shootingstars star : stars) {
    star.move_now();
    star.display_now();
  }
}


//TODO, make more functions for moving patterns, like flowers and trees
