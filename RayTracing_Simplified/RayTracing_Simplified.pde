/*This code is based off CollisionsMK2 but I have attempted to implement the ray tracing. //<>//
I implemented it with partial success as I have a line that I have converted into a collection of points.
However I am unable to get it to stay in the correct position. 
I am unsure whether the rotation is causing the issue, the robot having a different plane or a combination of the two.
I am also unsure if the ray tracing should only occur in the x or y axis as opposed to both since x and y is needed to track rotation.
When pressing s the collisions are based off the corners for the squares 
but there is a line drawn when w is pressed and the ray is drawn.
It is on the right and is like an arm that has perfect collision detection*/
float angle=0;
float OriginX = 100, OriginY = 100;
double horizontalValue;
double verticalValue;

/*Window variables needed 
as the size function only has scope in setup() and draw() 
but I want the square generation to produce global varibales*/
int windowWidth = 400, windowHeight = 400; //For size(x,y) Match windowWidth to x and windowheight to y.

boolean pressed = false;
boolean wPressed = false;
boolean aPressed = false;
boolean sPressed = false;
boolean dPressed = false;
//double T = 0;
// Create points for a 40x40 square centered on (x,y) 0,0
double[][] Pvals = {{-20, 20, 20, -20, 0}, 
  {-20, -20, 20, 20, 0}};  

Matrix P = new Matrix(Pvals);

double tx = 0, ty = 0; 
int speed = 5;

//x and y co-ordinates made in an attempt to move the ray traced line to the correct position uses p, l, q and z to try to move.
float ZX = 100;
float ZY = 100;

void setup() 
{
  // Create a window 400x400
  size(400, 400);
  //frameRate(1);
  //size(1800, 880);
}

void keyPressed()
{
  if (key == 'w' || key == 'W')
  {
    pressed = true;
    wPressed = true;
    aPressed = false;
    sPressed = false;
    dPressed = false;
  } else if (key == 'a' || key == 'A')
  {
    pressed = true;
    aPressed = true;
    wPressed = false;
    sPressed = false;
    dPressed = false;
  } else if (key == 's' || key == 'S')
  {
    pressed = true;
    sPressed = true;
    wPressed = false;
    aPressed = false;
    dPressed = false;
  } else if (key == 'd' || key == 'D')
  {
    pressed = true;
    dPressed = true;
    wPressed = false;
    aPressed = false;
    sPressed = false;
  }
}


void keyReleased()
{
  pressed = false;
  wPressed = false;
  aPressed = false;
  sPressed = false;
  dPressed = false;
}

void draw() {
  background(128);

  double[][] Rvals = {{cos(angle), -sin(angle)}, {sin(angle), cos(angle)}};
  Matrix R = new Matrix(Rvals);

  // Apply rotation matrix to the points
  Matrix P1=R.times(P);
  
  //double array subtracting the top right and top left corner of the robot to calculate the displacement.
  double[][] frontVector = {{(P1.get(0,1)-P1.get(0,0))},
                            {(P1.get(1,1)-P1.get(1,0))}};
                            
  //Vector stored in matrix form of the displacement.
  //Matrix F =new Matrix(frontVector);
  
  if (pressed)
  {
    if (wPressed)
    {
      horizontalValue = tx - -speed*sin(angle);
      verticalValue = ty - speed*cos(angle);
      tx = horizontalValue;
      ty = verticalValue;
    }
    
    if (aPressed)
    {
      angle -= radians(5);
      if (abs(round(degrees(angle))) == 360) angle = 0;
    }
    
    if (sPressed)
    {
      horizontalValue = tx + -speed*sin(angle);
      verticalValue = ty + speed*cos(angle);
      tx = horizontalValue;
      ty = verticalValue;
    }
    
    if (dPressed)
    {
      angle += radians(5);
      if (round(degrees(angle)) == 360) angle = 0;
    }
  }

  // Draw the original square
  //draw_quad(P);

  //// Create a 2D translation matrix to move 50,100
  //double tx = 0, ty = 0;

  double[][] Tvals = {{tx, tx, tx, tx, tx}, {ty, ty, ty, ty, ty}};
  Matrix T = new Matrix(Tvals);

  // Apply translation to the points
  P1=P1.plus(T);
  //println(tx);
  //println(ty);


  //double tx2 = 50, ty2 = -100;
  //double[][] T2vals = {{tx2, tx2, tx2, tx2}, {ty2, ty2, ty2, ty2}};
  //Matrix T2 = new Matrix(T2vals);

  //P2 = P2.plus(T2);


  draw_quad(P1);
  //draw_quad(P2);

  // Print points (column width, number of digits) to console
  //P.print(5, 2);
  //println("angle: "+round(degrees(angle)));
}

void drawBlocks(Matrix P)
{
  /*Extracts points from a matrix and will be used to get the points 
  for the randomly generated squares*/
  for (int i = 0; i < 5; i++)
  {
    //Top left point
    float X1=(float)P.get(0, (0+i*4));
    float Y1=(float)P.get(1, (0+i*4));
    //Top right point
    float X2=(float)P.get(0, (1+i*4));
    float Y2=(float)P.get(1, (1+i*4));
    //Bottom right point
    float X3=(float)P.get(0, (3+i*4));
    float Y3=(float)P.get(1, (3+i*4));
    //Bottom left point
    float X4=(float)P.get(0, (2+i*4));
    float Y4=(float)P.get(1, (2+i*4));
    
  // Draw Blocks using corners
    stroke(255);
    line(X1, Y1, X2, Y2);
    line(X2, Y2, X3, Y3);
    line(X3, Y3, X4, Y4);
    line(X1, Y1, X4, Y4);
  }
}

// This function draws a quadrilateral on the screen defined
// by the four points in the columns of P


void draw_quad(Matrix P) {
  // Extract point infromation from matrix

  float X1=(float)P.get(0, 0)+OriginX;
  float Y1=(float)P.get(1, 0)+OriginY;
  float X2=(float)P.get(0, 1)+OriginX;
  float Y2=(float)P.get(1, 1)+OriginY; 
  float X3=(float)P.get(0, 2)+OriginX;
  float Y3=(float)P.get(1, 2)+OriginY;
  float X4=(float)P.get(0, 3)+OriginX;
  float Y4=(float)P.get(1, 3)+OriginY;
  float X5=(float)P.get(0, 4)+OriginX;
  float Y5=(float)P.get(1, 4)+OriginY;
  
  //Averages X1 and X2 to find the centre point
  float X6=(((float)P.get(0, 0)+(float)P.get(0, 1))/2)+OriginX;
  float Y6=(((float)P.get(1, 0)+(float)P.get(1, 1))/2)+OriginY;
  
  //println(X1);
  //println(Y1);

  // Draw rectangle
  strokeWeight(10);
  stroke(255,0,0);
  //pushMatrix();
  point(X1,Y1);
  stroke(0,255,0);
  point(X2,Y2);
  stroke(0,0,255);
  point(X3,Y3);
  stroke(255);
  point(X4,Y4);
  stroke(0);
  strokeWeight(5);
  line(X5,Y5,X6,Y6);
  strokeWeight(1);
  //popMatrix();
  //line(X1, Y1, X2, Y2);
  //line(X2, Y2, X3, Y3);
  //line(X3, Y3, X4, Y4);
  //line(X1, Y1, X4, Y4);
}
