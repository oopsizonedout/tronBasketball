float _detail = 100;
int _ballRadius = 150;
float a =  .95;
float b =sqrt(2)/2;
PImage bg;
float xSpeed = 12.5;
float ySpeed = 30;
float zSpeed = 0;
float xPosition = -200;
float yPosition = -300;
float zPosition = -300;
color bluewhite=color(217,255,255);
color neonblue=color(0,255,255);
float alph = 5;
float impactCounter=0;

void setup() {
  size(1000, 800, P3D);
  bg=loadImage("The_NBA_Finals_logo2.jpg");
  smooth();
  strokeWeight(5); 
}

void draw() {
 
background(bg);
stroke(255);
noFill();
spotLight(0, 255, 255, xPosition, 1000, -300, 0, 1, 0, PI/2, 0);
  
  pushMatrix();
//Move the ball
  translate(xPosition, yPosition, zPosition);
//Give the ball some believable rotation, opposite the direction of movement
  rotateZ((-20*xSpeed)/(3*PI));
  rotateY((-2*abs(xSpeed))/(3*PI));

//equatorial line
  beginShape();
  stroke(0, 255, 0);
  float x, y, z;
  for (float r = 0; r < TWO_PI + 3*(TWO_PI / _detail); r += TWO_PI / _detail) {
    x = cos(r);
    y = 0;
    z = sin(r);
    curveVertex(x* _ballRadius, y* _ballRadius, z*_ballRadius);
  }
  endShape();

//2nd equatorial line
  beginShape();
  stroke(0, 255, 0);
  for (float r = 0; r < TWO_PI + 3*(TWO_PI / _detail); r += TWO_PI / _detail) {
    x = cos(r);
    y = sin(r);
    z = 0;
    curveVertex(x* _ballRadius, y* _ballRadius, z*_ballRadius);
  }
  endShape();

//Curvy basketball oval 
  beginShape();
  stroke(0, 255, 0);
  for (float r = 0; r < TWO_PI + 3*(TWO_PI / _detail); r += TWO_PI /_detail) {
    x = a*cos(r);
    y = b*sin(r);
    z=sqrt(1-sq(x)-sq(y));
    curveVertex(x* _ballRadius, y* _ballRadius, z*_ballRadius);
  }
  endShape();

//2nd Curvy basketball oval
  beginShape();
  stroke(0, 255, 0);
  //for (float zi = -_detail * PI / 2; zi < _detail * PI; zi++) {
  for (float r = 0; r < TWO_PI + 3*(TWO_PI / _detail); r += TWO_PI /_detail) {
    x = a*cos(r);
    y = b*sin(r);
    z=-sqrt(1-sq(x)-sq(y));
    //z = -.7*(((1+cos(2*r))/2)+.14);
    curveVertex(x* _ballRadius, y* _ballRadius, z*_ballRadius);
  }
  endShape();

//Pitch black Basketball to fill the otherwise empty lines for Tron like effect 
  noStroke();
  fill(50);
  translate(0, 0, 0);
  sphere(_ballRadius);
  noFill(); 
  endShape();
  popMatrix();

//Create Impact effect when ball strikes bottom, let it last for 10 frames
if (impactCounter>0){
spotLight(255, 255, 255, xPosition,750, -300, 0, 1, 0, PI/2, 0);
spotLight(255, 255, 255, xPosition,750, 0, 0, 1, 1, PI/2, 0);
pushMatrix();
    translate(0, height-zPosition,0);
    rotateX(-PI/2);
    drawEllipseGradient(xPosition, yPosition, _ballRadius*3*(impactCounter/10), neonblue, bluewhite, alph);
 popMatrix();

}


  ySpeed +=1;
  xSpeed *=.9975;
  xPosition += xSpeed;
  yPosition += ySpeed;
  impactCounter -=1;

  // changing directions after hitting the right wall
  if (xPosition > (width*1.15)-_ballRadius/2)
  {
    xPosition=(width*1.15)-_ballRadius/2;
    xSpeed=-xSpeed;
  }

  // changing directions after hitting the left wall
  if (xPosition<-(width*0.15)+_ballRadius/2)
  {
    xPosition=-(width*0.15)+_ballRadius/2;   
    xSpeed=-xSpeed;
  }

  // loosing height after each bounce
  if (yPosition > height-_ballRadius/2)
  {
    yPosition=height-_ballRadius/2;
    ySpeed = -ySpeed*.85;
    //Create Impact effect, let it last for 10 frames
    impactCounter=10;
   }

  // slow the ball down faster when it is rolling.
  if (yPosition > height-_ballRadius/2-1)
  {
    xSpeed *=.9975;
    //zSpeed *=.9975;
  }

//Remove comments to save frames 
//saveFrame("bball2/####.png");
 }


// re-throw the ball
void mouseDragged()
{
  xPosition = mouseX;
  yPosition = mouseY;
  //zPosition = -300;
  xSpeed = mouseX - pmouseX;
  ySpeed = mouseY - pmouseY;
  //zSpeed = 0;
}

//Function for the impact effect  
void drawEllipseGradient(float ex, float ey, float R, color c1, color c2, float alpha) {
  for (float r = R; r > 0; --r) {
   float inter = map(r,0,R, 0, 1);
   //float heightMap = map(r,0,R,0,h);
   color c = lerpColor(c1, c2, inter);
    fill(color(red(c),green(c),blue(c),alpha*inter));
    ellipse(ex + .35*(ex-500), ey, r, r);
    }}


 