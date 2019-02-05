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
float theta, hgt, start_pos; //variables for tree_fractal, https://processing.org/examples/tree.html
int d = day(); //getting the dates
String dd = "";
int m = month();
String mm = "";
int yr = year();
String the_date ="";
String my_name = "";
Shootingstars[] stars; //variables at the top
Herd herd;

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
  hgt = height/3;
  start_pos=width/2; //variable for the tree fractal
  stars = new Shootingstars[200]; //this goes inside of setup
  for(int i=0; i<200; i++){ //loop to make the new objects
  stars[i]= new Shootingstars();
  herd = new Herd();
  // Add an initial set of toids into the system
  for (int h = 0; h < 50; h++) {
    herd.addToid(new Toid(random(0,width),random(0,height)));
  }
  if(d<10){
    dd = "0"+str(d);
  }else {
    dd = str(d);
  }
  if(m<10){
    mm = "0"+str(m);
  }else {
    mm = str(m);
  }
  the_date = "sketch_"+str(yr)+"_"+mm+"_"+dd+"_";
  }
}

//loop to make drawings
void draw(){
  
  makeBackground(50);
  //drawMovingRectangle(100);
  //drawMovingLine(100);
  //randomShapeSelector();
  //movingParallelLines();
  //movingRandomFlower(75);
  moveStars();
  magicCircles(random(0,width), random(0,height), random(width/5));
  //magicRectangles(random(0,width), random(0,height), random(width/5));
  //herd.run();
  start_tree_fractal();
  
  
  if(frameCount<10){
    my_name=the_date+"frame_"+"000"+str(frameCount)+".jpg";
  } else if(frameCount<100){
    my_name=the_date+"frame_"+"00"+str(frameCount)+".jpg";
  } else if(frameCount<1000){
    my_name=the_date+"frame_"+"0"+str(frameCount)+".jpg";
  } else{
    my_name=the_date+"frame_"+str(frameCount)+".jpg";
  }
  
  saveFrame(my_name); //saves frame as a jpeg
  
  
  if(frameCount > 800){ 
    noLoop(); //this breaks us out of the drawing loop
  }
  
}

void mousePressed() {
  herd.addToid(new Toid(mouseX,mouseY));
}


//TODO, try creating new classes for other things

//creating classes functions that can be reused

//credit to https://processing.org/examples/flocking.html
// The Herd (a list of Toid objects)
class Herd {
  ArrayList<Toid> toids; // An ArrayList for all the toids

  Herd() {
    toids = new ArrayList<Toid>(); // Initialize the ArrayList
  }

  void run() {
    for (Toid b : toids) {
      b.run(toids);  // Passing the entire list of toids to each toid individually
    }
  }

  void addToid(Toid b) {
    toids.add(b);
  }

}

// The Toid class

class Toid {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  float RColor = random(255);
  float GColor = random(255);
  float BColor = random(255);
  int size = int(random(10,20));

    Toid(float x, float y) {
    acceleration = new PVector(0, 0);

    // This is a new PVector method not yet implemented in JS
    // velocity = PVector.random2D();

    // Leaving the code temporarily this way so that this example runs in JS
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));

    position = new PVector(x, y);
    r = 3.0;
    maxspeed = width/100;
    maxforce = width/1000;
  }

  void run(ArrayList<Toid> toids) {
    herd(toids);
    update();
    borders();
    render();
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void herd(ArrayList<Toid> toids) {
    PVector sep = separate(toids);   // Separation
    PVector ali = align(toids);      // Alignment
    PVector coh = cohesion(toids);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    
    fill(RColor, GColor, BColor);
    stroke(random(255),random(255),random(255));
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*size);
    vertex(-r*size*0.5, r*size);
    vertex(r*size*0.5, r*size);
    endShape();
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (position.x < -r) position.x = width+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    if (position.y > height+r) position.y = -r;
  }

  // Separation
  // Method checks for nearby toids and steers away
  PVector separate (ArrayList<Toid> toids) {
    float desiredseparation = 30.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every toid in the system, check if it's too close
    for (Toid other : toids) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby toid in the system, calculate the average velocity
  PVector align (ArrayList<Toid> toids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Toid other : toids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // sum.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby toids, calculate steering vector towards that position
  PVector cohesion (ArrayList<Toid> toids) {
    float neighbordist = 60;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Toid other : toids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } 
    else {
      return new PVector(0, 0);
    }
  }
}

//making a class of shootingstars
class Shootingstars { //when moving this over into the official script, you must have the class before the functions
 
 //variables
 float x,y,diameterx,diametery,speedx,speedy,colorR,colorG,colorB,starAlpha;
 
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
    starAlpha = random(50,100);
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
    fill(colorR,colorG,colorB,starAlpha);
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
void drawMovingRectangle(int thea){
  angle+=speed;

  float X=width/2+sin(angle)*width/3;
  float Y=height/2+cos(angle)*height/4;
  
  //making a rectangle
  fill(R,G,B,thea);
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
void drawMovingLine(int thea){
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
void randomBezierShape(int thea){
    stroke(random(255), random(255), random(255),thea); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    fill(random(255), random(255), random(255),thea);
    
    beginShape(); 
    vertex(random(width),random(height));
    randomBezierVertices(int(random(4,25))); //curves must have at least 4 points
    endShape(CLOSE);
}

void randomCurvyShape(int thea){
    //make a random curvy shape
    stroke(random(255), random(255), random(255),thea); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    fill(random(255), random(255), random(255),thea);
    
    beginShape(); 
    randomCurveVertices(int(random(4,25))); //curves must have at least 4 points
    endShape(CLOSE);
}

void randomShape(int thea){
    //make a random shape
    
    stroke(random(255), random(255), random(255),thea); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    fill(random(255), random(255), random(255),thea);
    
    beginShape(); 
    randomVertices(int(random(3,25)));
    endShape(CLOSE);
}

void randomCurveLine(int thea){
    //make a random curvy line
    stroke(random(255), random(255), random(255),thea); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    curve(random(width), random(height), random(width), random(height), random(width), random(height),random(width), random(height));
}

void randomBezierLine(int thea){
   //make a random bezier line
    stroke(random(255), random(255), random(255),thea); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    bezier(random(width), random(height), random(width), random(height), random(width), random(height),random(width), random(height));
}

void randomStraightLine(int thea){
    //make a random straight line
    stroke(random(255), random(255), random(255),thea); //this accidentally changed the parameters in the other shapes, but it is kind of cool
    strokeWeight(random(width/width,width/100));
    line(random(width), random(height), random(width), random(height));
}

void randomArc(int thea){
    fill(random(255), random(255), random(255),thea); //makes a random RGB color
    
    //random dimensions for the arc
    float x_1 = random(width);
    float y_1 = random(height);
    float w_1 = random(width);
    float h_1 = random(height);

    //making a random arc
    arc(x_1, y_1, x_1, h_1, random(6.283185), random(6.283185), PIE);
}

void randomQuad(int thea){
  noStroke();
  fill(random(255), random(255), random(255),thea); //makes a random RGB color
    
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

void randomEllipse(int thea){
    //making and placing a random ellipse
    fill(random(255), random(255), random(255),thea); //makes a random RGB color
    float sz_1 = random(width); //making a variable for the rectangle size
    float sz_2 = random(height); //another variable for rectangle dimensions
    
    //width and height are system variables, and we can use them to randomly place an ellipse
    ellipse(random(width), random(height), sz_1, sz_2);
}

void randomRectangle(int thea){
    //making and placing a random rectangle
    fill(random(255), random(255), random(255),thea); //makes a random RGB color
    float sz_1 = random(width); //making a variable for the rectangle size
    float sz_2 = random(height); //another variable for rectangle dimensions
    
    //width and height are system variables, and we can use them to randomly place a rect
    rect(random(width), random(height), sz_1, sz_2);
}

void randomShapeSelector(){
  //a function that randomly generates a shape
  int choice = int(random(1,10)); //we have three options
  int filler = int(random(50,100)); //random filler of alpha
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

void movingRandomFlower(int thea){
  
  fill(random(255),random(255),random(255),thea); //center circle color
  ellipse(el_center_x,el_center_y,100,100); //center cirle
  fill(random(255),random(255),random(255),thea);
  ellipse(el_center_x,el_center_y+el_sep_y,100,100); //up
  fill(random(255),random(255),random(255),thea);
  ellipse(el_center_x,el_center_y-el_sep_y,100,100); //down
  fill(random(255),random(255),random(255),thea);
  ellipse(el_center_x+el_sep_x,el_center_y,100,100); //left
  fill(random(255),random(255),random(255),thea);
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

//inspired by https://funprogramming.org/140-Recursive-graphics.html
void magicCircles(float mx, float my, float msz){
  float innera, innerx, innery;
  int loopsie = int(random(1,4));
  fill(random(255),random(255),random(255),random(99,100));
  ellipseMode(CENTER);
  ellipse(mx,my,random(msz/2,msz),random(msz/2,msz));
  if(msz>1){
    for(int i=0; i<loopsie; i++){
      innera = random(TWO_PI);
      innerx = mx + msz/2 * sin(innera);
      innery = my + msz/2 * cos(innera);
      magicCircles(innerx,innery,msz/2);
    }
  }
}

void magicRectangles(float mx, float my, float msz){
  float innera, innerx, innery;
  int loopsie = int(random(1,4));
  fill(random(255),random(255),random(255),random(99,100));
  rectMode(CENTER);
  rect(mx,my,random(msz/2,msz),random(msz/2,msz));
  if(msz>1){
    for(int i=0; i<loopsie; i++){
      innera = random(TWO_PI);
      innerx = mx + msz/2 * sin(innera);
      innery = my + msz/2 * cos(innera);
      magicRectangles(innerx,innery,msz/2);
    }
  }
}

//credit to https://processing.org/examples/tree.html
void start_tree_fractal(){
  stroke(random(255),random(255),random(255));
  strokeWeight(random(1,25));
  // Let's pick an angle 0 to 90 degrees based on the mouse position
  float a = ( start_pos / (float) width) * 90f;
  // Convert it to radians
  theta = radians(a);
  // Start the tree from the bottom of the screen
  translate(width/2,height);
  // Draw a line 120 pixels
  line(0,0,0,-hgt);
  // Move to the end of that line
  translate(0,-hgt);
  // Start the recursive branching!
  tree_fractal(hgt);
  start_pos-=25;
  if(start_pos<width/width){
    start_pos=width;
  }
}

void tree_fractal(float h) {
  // Each branch will be 2/3rds the size of the previous one
  h *= 0.66;
  
  // All recursive functions must have an exit condition!!!!
  // Here, ours is when the length of the branch is 2 pixels or less
  if (h > 2) {
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    rotate(theta);   // Rotate by theta
    line(0, 0, 0, -h);  // Draw the branch
    translate(0, -h); // Move to the end of the branch
    fill(random(255),random(255),random(255));
    ellipse(0,-h,2,2);
    tree_fractal(h);       // Ok, now call myself to draw two new branches!!
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
    
    // Repeat the same thing, only branch off to the "left" this time!
    pushMatrix();
    rotate(-theta);
    line(0, 0, 0, -h);
    translate(0, -h);
    fill(random(255),random(255),random(255));
    ellipse(0,-h,2,2);
    tree_fractal(h);
    popMatrix();
  }
  
}

//TODO, make more classes and functiosn for patterned behaviors
