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

//TODO, make patterned effects and animations, not just solely random

//establishing a few variables
float angle, speed, line_y; //variables necessary to control the movement of shapes
float R, G, B; //variables for control of color
int the_cc; //variable for color change

//setting up the drawing background and parameters
void setup(){
  size(2560, 1440); //changing the size and dimension so it displays better in YouTube
  background(0,0,0); //starting with a black background
  frameRate(30);
  noStroke();
  ellipseMode(CENTER);
  rectMode(CENTER);
  speed=0.04; //establishing how fast everythign will move
  R=255; //all three RGB to 255 so it all begins as white
  G=255;
  B=255;
  the_cc=0; 
  line_y=height/2;
}

//loop to make drawings
void draw(){
  
  fill(0,0,0,100); //the covering up the background, 255 all is white, 0 is black
  rect(width/2,height/2,width,height); //we just draw a rectangle over the screen
  
  angle+=speed;

  float X=width/2+sin(angle)*width/3;
  float Y=height/2+cos(angle)*height/4;
  
  //making a rectangle
  fill(R,G,B);
  noStroke();
  rect(X,Y,width/8,height/8);
  
  saveFrame("frame-####.jpg"); //saves frame as a jpeg
  
  //end of loop changes
  
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
  
  //drawing a line
  stroke(R,G,B);
  strokeWeight(4);
  line(0,line_y,width,line_y);
  line_y=line_y-2;
  if(line_y<0){
    line_y=height;
  }
  
  if(frameCount > 600){ 
    noLoop(); //this breaks us out of the drawing loop
  }
  
}
