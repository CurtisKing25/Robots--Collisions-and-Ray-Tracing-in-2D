/*This code is based off CollisionsMK2 but I have attempted to implement the ray tracing.
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
boolean canRotate = true, inWindowX = true, inWindowY = true, inWindow, inSquareX = false, inSquareY = false, inSquare;

/*Window variables needed 
as the size function only has scope in setup() and draw() 
but I want the square generation to produce global varibales*/
int windowWidth = 400, windowHeight = 400; //For size(x,y) Match windowWidth to x and windowheight to y.
double [][] squareArray = generateSquares();
Matrix S = new Matrix(squareArray);

boolean pressed = false;
boolean wPressed = false;
boolean aPressed = false;
boolean sPressed = false;
boolean dPressed = false;
double T = 0;
// Create points for a 40x40 square centered on (x,y) 0,0
double[][] Pvals = {{-20, 20, 20, -20}, 
  {-20, -20, 20, 20}};  

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
  else if (key == 'p')
  {
    //ZX = ZX - -speed*sin(angle);
    ZX++;
  }
  else if (key == 'l')
  {
    //ZY = ZY + -speed*sin(angle);
    ZX--;
  }
    else if (key == 'q')
  {
    //ZY = ZY - -speed*sin(angle);
    ZY++;
  }
  else if (key == 'z')
  {
    //ZX = ZX + -speed*sin(angle);
    ZY--;
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
  drawBlocks(S);
  //println(ZX);
  //println(ZY);

  double[][] Rvals = {{cos(angle), -sin(angle)}, {sin(angle), cos(angle)}};
  Matrix R = new Matrix(Rvals);

  // Apply rotation matrix to the points
  Matrix P1=R.times(P);
  
  //double array subtracting the top right and top left corner of the robot to calculate the displacement.
  double[][] frontVector = {{(P1.get(0,1)-P1.get(0,0))},
                            {(P1.get(1,1)-P1.get(1,0))}};
                            
  //Vector stored in matrix form of the displacement.
  Matrix F =new Matrix(frontVector);
  
  if (pressed)
  {
    if (wPressed)
    {
      horizontalValue = tx - -speed*sin(angle);
      verticalValue = ty - speed*cos(angle);
      
      //Nested loop checks if the robot is in the x and y boundaries
      for (int i = 0; i < Pvals.length; i++)
      {
        for (int j = 0; j < 2; j++)
        {
          if(i == 0)
          {
              if ((P1.get(i,j)+tx <= width-102 && P1.get(i,j)+tx >= -98))
              {
                inWindowX = true;
              }
            
              else
              {
                inWindowX = false;
                break;
              }
          }
          if(i == 1)
          {
            if (inWindowX == true)
            {
              if (P1.get(i,j)+ty <= height-102 && P1.get(i,j)+ty >= -98)
              {
               inWindowY = true;
              }
            
              else
              {
                inWindowY = false;
                break;
              }
            }
          }
        }
      }
      
      //This nested loop generates numbers between 0 and 1
      for (int i = 0; i < Pvals.length; i++)
      {
        //Iterates between 0 and 1 in steps of 0.01
        for (float j = 0; j <= 1; j+=0.01)
        {
          //The nubers are multiplied by the vector F to generate a new vector I. Each iteration moves along the distance and checks the points for collision
          Matrix I = F.times(j);
          //Matrix I = F;
          int Q = 100;
          //int ZX = 100;
          //int ZY = 100;
          if(i == 0)
          {         
              if(I.get(i,0)+tx <= (S.get(0,3)-ZX) && I.get(i,0)+tx >= (S.get(0,0)-ZX))
              
                 /*||
                (P1.get(i,j)+tx <= S.get(0,5) && P1.get(i,j)+tx >= S.get(0,7))  ||
                (P1.get(i,j)+tx <= S.get(0,9) && P1.get(i,j)+tx >= S.get(0,11)) ||
                (P1.get(i,j)+tx <= S.get(0,13) && P1.get(i,j)+tx >= S.get(0,15))||
                (P1.get(i,j)+tx <= S.get(0,17) && P1.get(i,j)+tx >= S.get(0,15))*/
              {
               inSquareX = true;
               
               //Draws circles to represent the collision ray
               ellipse((float)(I.get(0,0)+tx+ZX),(float)(I.get(1,0)+ty+Q),10,10);
               break;
              }
            
              else
              {
                inSquareX = false;
                
                //Draws circles to represent the collision ray
                ellipse((float)(I.get(0,0)+tx+ZX),(float)(I.get(1,0)+ty+Q),10,10);
              }
          }
          
          //Does the same for the y axis but I am unable to determine if it is required or it's effect.
          if(i == 1)
          {
            if(inSquareX == true)
            {
              if((I.get(i,0)+ty <= (S.get(1,3)-ZY) && I.get(i,0)+ty >= (S.get(1,0)-ZY)))
              
                 /*||
                (P1.get(i,j)+tx <= S.get(0,5) && P1.get(i,j)+tx >= S.get(0,7))  ||
                (P1.get(i,j)+tx <= S.get(0,9) && P1.get(i,j)+tx >= S.get(0,11)) ||
                (P1.get(i,j)+tx <= S.get(0,13) && P1.get(i,j)+tx >= S.get(0,15))||
                (P1.get(i,j)+tx <= S.get(0,17) && P1.get(i,j)+tx >= S.get(0,15))*/
              {
               inSquareY = true;
               //println(inSquareY);
               break;
              }
            
              else
              {
                inSquareY = false;
                //println(inSquareY);
              }
            }
          }
        }
      }
      
      println();
      
      if (inWindowX && inWindowY)
      {
        inWindow = true;
      }
      else
      {
        inWindow = false;
      }
      
      if (inSquareX && inSquareY)
      {
        inSquare = true;
      }
      else
      {
        inSquare = false;
      }
      
      if (inWindow == true && inSquare == false)
      {
        tx = horizontalValue;
        ty = verticalValue;
      }
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
      
      for (int i = 0; i < Pvals.length; i++)
      {
        for (int j = 2; j < 4; j++)
        {
          if(i == 0)
          {
            if (inWindowY == true)
            {
              if (P1.get(i,j)+tx <= width-102 && P1.get(i,j)+tx >= -98)
              {
                inWindowX = true;
              }
            
              else
              {
                inWindowX = false;
                break;
              }
            }
            
            if((P1.get(i,j)+tx <= (S.get(0,3)-100) && P1.get(i,j)+tx >= (S.get(0,0)-100)))
              
               /*||
              (P1.get(i,j)+tx <= S.get(0,5) && P1.get(i,j)+tx >= S.get(0,7))  ||
              (P1.get(i,j)+tx <= S.get(0,9) && P1.get(i,j)+tx >= S.get(0,11)) ||
              (P1.get(i,j)+tx <= S.get(0,13) && P1.get(i,j)+tx >= S.get(0,15))||
              (P1.get(i,j)+tx <= S.get(0,17) && P1.get(i,j)+tx >= S.get(0,15))*/
            {
             inSquareX = true;
            // println(inSquareX);
             //println("PX = "+(P1.get(i,j)+tx)+"<= SX1 = "+(S.get(0,3)-100));
             //println("PX = "+(P1.get(i,j)+tx)+">= SX1 = "+(S.get(0,0)-100));
             break;
            }
            
            else
            {
              inSquareX = false;
              //println(inSquareX);
             // println("PX = "+(P1.get(i,j)+tx)+"<= SX1 = "+(S.get(0,3)-100));
              //println("PX = "+(P1.get(i,j)+tx)+">= SX1 = "+(S.get(0,0)-100));
            }
            
          }
          if(i == 1)
          {
            if (inWindowX == true)
            {
              if (P1.get(i,j)+ty <= height-102 && P1.get(i,j)+ty >= -98)
              {
                inWindowY = true;
              }
              
              else
              {
                inWindowY = false;
                break;
              }
            }
            
            if (inSquareX == true)
            {
              if((P1.get(i,j)+ty <= (S.get(1,3)-100) && P1.get(i,j)+ty >= (S.get(1,0)-100)))
                
                 /*||
                (P1.get(i,j)+tx <= S.get(0,5) && P1.get(i,j)+tx >= S.get(0,7))  ||
                (P1.get(i,j)+tx <= S.get(0,9) && P1.get(i,j)+tx >= S.get(0,11)) ||
                (P1.get(i,j)+tx <= S.get(0,13) && P1.get(i,j)+tx >= S.get(0,15))||
                (P1.get(i,j)+tx <= S.get(0,17) && P1.get(i,j)+tx >= S.get(0,15))*/
              {
               inSquareY = true;
               //println(inSquareY);
               //println("PY = "+(P1.get(i,j)+ty));
               //println("SY = "+(S.get(1,3)-100));
               break;
              }
              
              else
              {
                inSquareY = false;
                //println(inSquareY);
                //println("PY = "+(P1.get(i,j)+ty));
                //println("SY = "+(S.get(1,3)-100));
              }
            }
            
          }
        }
      }
      println();

       if (inWindowX && inWindowY)
      {
        inWindow = true;
      }
      else
      {
        inWindow = false;
      }
      
      if (inSquareX && inSquareY)
      {
        inSquare = true;
      }
      else
      {
        inSquare = false;
      }
      
      if (inWindow == true && inSquare == false)
      {
        tx = horizontalValue;
        ty = verticalValue;
      }
      
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

  double[][] Tvals = {{tx, tx, tx, tx}, {ty, ty, ty, ty}};
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


double [][] generateSquares()
{
  int rl = 2;
  int cl = 5;
  int cl2 = cl*4;
  
  double[][] points = new double[rl][cl];
  for (int r = 0; r < 1; r++)
  {
    for (int c = 0; c < points[0].length; c++)
    {
      points[r][c] = (double)(int)(random(0, windowWidth-50));
    }
  }
  
  for (int r = 0; r < 2; r++)
  {
    for (int c = 0; c < points[0].length; c++)
    {
      points[r][c] = (double)(int)(random(0, windowHeight-50));
    }
  }
  
  double[][] Objectpoints = new double[rl][cl2];
  for (int r = 0; r < Objectpoints.length; r++)
  {
    int p = 0;
    for (int c = 0; c < Objectpoints[0].length; c++)
    {
      //if in the 1st row (x row is row 0)
      if (r == 0)
      {
        // if the collumn is 0 (1st entry)
        if (c == 0)
        {
          //It is the same as the the randomly generated x (both indexes are 0 therefore no index error can occur)
          Objectpoints[r][c] = points[r][c];
        }
        //otherwise if the collum is divisable by 4 (Start of new square)
        else if (c % 4 == 0)
        {
          //Add 3 to p
          p+=3;
          /*The new point equals the next point from the randomly generated points (extracts randomly generated points without index error)
          This skips the 3 new points that will be needed in the new array to make a square*/
          Objectpoints[r][c] = points[r][c-p];
        }
        
        //else if you are the 2nd collumn in the x row (collumn before you is the first one)
        else if(c-1 == 0) //|| c-1 % 4 == 0
        {
          // Copies the 1st x value to then 2nd x
          Objectpoints[r][c] = points[r][c-1];
          // adds 50 (translation 50 pixels right)
          Objectpoints[r][c] +=50;
        }
        
        //else if in front of a randomly generated x value
        else if((c-1) % 4 == 0)
        {
          //Copies randomly generated x value
          Objectpoints[r][c] = Objectpoints[r][c-1];
          // adds 50 (translation 50 pixels right)
          Objectpoints[r][c] +=50;
        }
        
        //else if 2 in front of a randomly generated x value
        else if((c-2) % 4 == 0)
        {
          //Copies randomly generated x value (no translation in x axis)
          Objectpoints[r][c] = Objectpoints[r][c-2];
        }
        
        //else if 3 in front of a randomly generated x value
        else if((c-3) % 4 == 0)
        {
          //Copies randomly generated x value after translation
          Objectpoints[r][c] = Objectpoints[r][c-2];
        }
      }
      
      //if in the 2nd row (y row is row 1)
      else if (r == 1)
      {
        // if the collumn is 0 (1st entry)
        if (c == 0)
        {
          //It is the same as the the randomly generated y (both indexes are 0 therefore no index error can occur)
          Objectpoints[r][c] = points[r][c];
        }

        //otherwise if the collum is divisable by 4 (Start of new square)
        else if (c % 4 == 0)
        {
          //Add 3 p
          p+=3;
          /*The new point equals the next point from the randomly generated points (extracts randomly generated points without index error)
          This skips the 3 new points that will be needed in the new array to make a square*/
          Objectpoints[r][c] = points[r][c-p];
        }
        
        //if on the 2nd collumn (currently in y row)
        else if (c-1 == 0)
        {
          //2nd y value equals 1st y value (no vertical pixel translation)
          Objectpoints[r][c] = points[r][0];
        }
        
        //else if the current point is one in front of a randomly generated point
        else if ((c-1) % 4 == 0)
        {
          //current y value equals previous y value (no vertical pixel translation)
          Objectpoints[r][c] = Objectpoints[r][c-1];
        }
        
        //else if 2 in front of a randomly generated y value
        else if((c-2) % 4 == 0)
        {
          //Copies randomly generated y value
          Objectpoints[r][c] = Objectpoints[r][c-2];
          //translates it by 50 pixels in the y axis
          Objectpoints[r][c] +=50;
        }
        
        //else if 3 in front of a randomly generated x value
        else if((c-3) % 4 == 0)
        {
          //Copies randomly generated y value after translation
          Objectpoints[r][c] = Objectpoints[r][c-1];
        }
      }
      
    }
    
    /*
    for (int i = 0; i < 2; i++)
    {
      for (int j = 0; j < 4; j++)
      {
        print(Objectpoints[i][j]+" ");
      }
      println();
    }
    */
  }
  return Objectpoints;
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
  //println(X1);
  //println(Y1);

  // Draw rectangle
  stroke(0);
  line(X1, Y1, X2, Y2);
  line(X2, Y2, X3, Y3);
  line(X3, Y3, X4, Y4);
  line(X1, Y1, X4, Y4);
}
