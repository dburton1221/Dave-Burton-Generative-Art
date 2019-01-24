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
float angle, speed; //variables necessary to control the movement of shape
float R, G, B; //variables for control of color

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
}

//loop to make drawings
void draw(){
  
  fill(0,0,0,100); //the covering up the background, 255 all is white, 0 is black
  rect(width/2,height/2,width,height); //we just draw a rectangle over the screen
  
  angle+=speed;

  float X=width/2+sin(angle)*width/2;
  float Y=height/2+cos(angle)*width/3;
  
  //making the shape
  fill(R,G,B);
  rect(X/2,Y/2,width/8,height/8);
  
  saveFrame("frame-####.jpg"); //saves frame as a jpeg
  
  //end of loop changes
  
  //changing colors
  R-=1; //lowering red down
  if(R<1){
    G-=1; //lowering green
    if(G<1){
      if(B>1){ //we only lower blue if green down and blue greater
      B-=1;
      }
    }
  }
  
  if(B==0){ //everything resets once we get down to blue zero
    R=255;
    G=255;
    B=255;
  }
  
  if(frameCount > 600){ 
    noLoop(); //this breaks us out of the drawing loop
  }
  
}
