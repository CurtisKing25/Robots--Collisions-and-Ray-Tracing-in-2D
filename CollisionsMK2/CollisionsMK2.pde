//CollisionsMK2 is uses my initial moving robot attempt but important or new code will be commented

//Using the w a s d keys you can move the corners of the robot into the squares and one of them will have collisions.

float angle=0;
float OriginX = 100, OriginY = 100;
double horizontalValue;
double verticalValue;

/*inWindow and inSquare variables replace the canMove variables as there is two types of collision checks happening,
one for the window and one for one of the randomly generated blocks*/
boolean inWindowX = true, inWindowY = true, inWindow, inSquareX = false, inSquareY = false, inSquare;

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

void setup() 
{
  // Create a window 400x400
  size(400, 400);
  
  //strokeWeight added to ensure it could be seen on the screencast.
  strokeWeight(5);
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
  
  //Square blocks are drawn using the  matrix of randomly generated points
  drawBlocks(S);

  //// Create rotation matrix through 135 degrees
  double[][] Rvals = {{cos(angle), -sin(angle)}, {sin(angle), cos(angle)}};
  Matrix R = new Matrix(Rvals);

  // Apply rotation matrix to the points
  Matrix P1=R.times(P);
  
  if (pressed)
  {
    if (wPressed)
    {
      horizontalValue = tx - -speed*sin(angle);
      verticalValue = ty - speed*cos(angle);
      for (int i = 0; i < Pvals.length; i++)
      {
        for (int j = 0; j < 2; j++)
        {
          if(i == 0)
          {
              if ((P1.get(i,j)+tx <= width-102 && P1.get(i,j)+tx >= -98))
              {
                inWindowX = true;
                
                //Prints boolean answer
               println("inWindowX = "+inWindowX);
              }
            
              else
              {
                inWindowX = false;
                
                //Prints boolean answer
               println("inWindowX = "+inWindowX);
               
               /*Only one point needs to be outside the window for this to be returned false.
               Without this only the second point that is checked would disable movement*/
               break;
              }
              
              //if the point on the robot (front corners) is within the x boundaries of the first randomly generated square
              if((P1.get(i,j)+tx <= (S.get(0,3)-100) && P1.get(i,j)+tx >= (S.get(0,0)-100)))
              
                 /*||
                (P1.get(i,j)+tx <= S.get(0,5) && P1.get(i,j)+tx >= S.get(0,7))  ||
                (P1.get(i,j)+tx <= S.get(0,9) && P1.get(i,j)+tx >= S.get(0,11)) ||
                (P1.get(i,j)+tx <= S.get(0,13) && P1.get(i,j)+tx >= S.get(0,15))||
                (P1.get(i,j)+tx <= S.get(0,17) && P1.get(i,j)+tx >= S.get(0,15))*/
              {
               
               // inside it is set to true
               inSquareX = true;
               
               //Prints boolean answer
               println("inSquareX = "+inSquareX);
               
               /*Breaks as only 1 point needs to be in the square for a collision to occur.
               Otherwise the first point of the robot would be able to go inside the square once the second was outside*/
               break;
              }
            
              else
              {
                inSquareX = false;
                
                //Prints boolean answer
                println("inSquareX = "+inSquareX);
              }
          }
          if(i == 1)
          {
              if (P1.get(i,j)+ty <= height-102 && P1.get(i,j)+ty >= -98)
              {
               inWindowY = true;
               
               //Prints boolean answer
                println("inWindowY = "+inWindowY);
                
              }
            
              else
              {
                inWindowY = false;
                
                //Prints boolean answer
                println("inWindowY = "+inWindowY);
                
                //breaks as only 1 point needs to be out of the window for a collision to occur
                break;
              }
            
              if((P1.get(i,j)+ty <= (S.get(1,3)-100) && P1.get(i,j)+ty >= (S.get(1,0)-100)))
              
                 /*||
                (P1.get(i,j)+tx <= S.get(0,5) && P1.get(i,j)+tx >= S.get(0,7))  ||
                (P1.get(i,j)+tx <= S.get(0,9) && P1.get(i,j)+tx >= S.get(0,11)) ||
                (P1.get(i,j)+tx <= S.get(0,13) && P1.get(i,j)+tx >= S.get(0,15))||
                (P1.get(i,j)+tx <= S.get(0,17) && P1.get(i,j)+tx >= S.get(0,15))*/
              {
               inSquareY = true;
               
               //Prints boolean answer
               println("inSquareY = "+inSquareY);
               
               //breaks as only 1 point needs to be in the square for a collision to occur.
               break;
              }
            
              else
              {
                inSquareY = false;
                
                //Prints boolean answer
                println("inSquareY = "+inSquareY);
              }
          }
        }
      }
      
      //Shows nested loop has ran fully.
      println();
      
      //if inside the window in the x and y axis
      if (inWindowX && inWindowY)
      {
        //The points are inside the window
        inWindow = true;
      }
      else
      {
        //They are not
        inWindow = false;
      }
      
      //if inside the square in the x and y axis
      if (inSquareX && inSquareY)
      {
        //The point is inside the square
        inSquare = true;
      }
      else
      {
        //It is not
        inSquare = false;
      }
      
      // if inside the window and not inside the square obstacle
      if (inWindow == true && inSquare == false)
      {
        //The translations can occur
        tx = horizontalValue;
        ty = verticalValue;
      }
    }
    
    if (aPressed)
    {
      angle -= radians(5);
      if (abs(round(degrees(angle))) == 360) angle = 0;
    }
    
    //The same as wPressed but the direction of movement is inverted
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
              if (P1.get(i,j)+tx <= width-102 && P1.get(i,j)+tx >= -98)
              {
                inWindowX = true;
                println("inWindowX = "+inWindowX);
              }
            
              else
              {
                inWindowX = false;
                println("inWindowX = "+inWindowX);
                break;
              }
            
            if((P1.get(i,j)+tx <= (S.get(0,3)-100) && P1.get(i,j)+tx >= (S.get(0,0)-100)))
               /*||
              (P1.get(i,j)+tx <= S.get(0,5) && P1.get(i,j)+tx >= S.get(0,7))  ||
              (P1.get(i,j)+tx <= S.get(0,9) && P1.get(i,j)+tx >= S.get(0,11)) ||
              (P1.get(i,j)+tx <= S.get(0,13) && P1.get(i,j)+tx >= S.get(0,15))||
              (P1.get(i,j)+tx <= S.get(0,17) && P1.get(i,j)+tx >= S.get(0,15))*/
            {
             inSquareX = true;
             println("inSquareX = "+inSquareX);
             break;
            }
            
            else
            {
              inSquareX = false;
              println("inSquareX = "+inSquareX);
            }
            
          }
          if(i == 1)
          {
              if (P1.get(i,j)+ty <= height-102 && P1.get(i,j)+ty >= -98)
              {
                inWindowY = true;
                println("inWindowY = "+inWindowY);
              }
              
              else
              {
                inWindowY = false;
                println("inWindowY = "+inWindowY);
                break;
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
               println("inSquareY = "+inSquareY);
               break;
              }
              
              else
              {
                inSquareY = false;
                println("inSquareY = "+inSquareY);
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

  double[][] Tvals = {{tx, tx, tx, tx}, {ty, ty, ty, ty}};
  Matrix T = new Matrix(Tvals);

  // Apply translation to the points
  P1=P1.plus(T);

   //Comes from Lab5a.pde and draws the robot
  draw_quad(P1);
}

/*Randomly generates points and preforms translations to the x and y values 
to make 5 points into 5 squares*/
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

//Modifies the draw_quad() function to draw the Square that were randomly generated
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
