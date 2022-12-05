//CollisionsMK4 is based off CollisionsMK3.pde but important or new code will be commented.

/*This code is the same as CollisionsMK3 but the collisions now apply to the S key
and the graphics have been overlayerd as well as the lines removed to better demonstrate the end goal I had in mind.
Again unfortunately only the top left and bottom right corners work for the collisions due to the while loop overwriting the other points function*/


float angle=0;
float OriginX = 100, OriginY = 100;
double horizontalValue;
double verticalValue;
boolean canRotate = true, inWindowX = true, inWindowY = true, inWindow, inSquareX = false, inSquareY = false, inSquare;

/*Window variables needed 
as the size function only has scope in setup() and draw() 
but I want the square generation to produce global varibales*/
int windowWidth = 1800, windowHeight = 880; //For size(x,y) Match windowWidth to x and windowheight to y.
//int windowWidth = 400, windowHeight = 400;
int xCollisionBlock;
int yCollisionBlock;
double [][] squareArray = generateSquares();
Matrix S = new Matrix(squareArray);

boolean pressed = false;
boolean wPressed = false;
boolean aPressed = false;
boolean sPressed = false;
boolean dPressed = false;
double T = 0;
// Create points for a 40x40 square centered on (x,y) 0,0
double[][] Pvals = {{-50, 50, 50, -50,0}, 
  {-50, -50, 50, 50,0}};  

Matrix P = new Matrix(Pvals);

double tx = 0, ty = 0; 
int speed = 4;
float rotationRate = 2;

void setup() 
{
  // Create a window 400x400
  //size(400, 400);
  //frameRate(1);
  fullScreen();
  //size(1800, 880);
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
  background(186, 140, 99);

  //// Create rotation matrix through 135 degrees
  double[][] Rvals = {{cos(angle), -sin(angle)}, {sin(angle), cos(angle)}};
  Matrix R = new Matrix(Rvals);

  // Apply rotation matrix to the points
  Matrix P1=R.times(P);
  
  if (pressed)
  {
    if (wPressed)
    {
      //strokeWeight(5);
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
              }
            
              else
              {
                inWindowX = false;
                break;
              }
              int SX1 = 3;
              int SX2 = 0;
              int SXN = 0;
              while (SX1 < 23)
              {
                if((P1.get(i,j)+tx <= (S.get(0,SX1)-100) && P1.get(i,j)+tx >= (S.get(0,SX2)-100)))
                /*
                || 
                  (P1.get(i,j)+tx <= (S.get(0,7)-100) && P1.get(i,j)+tx >= (S.get(0,4)-100)) || 
                  (P1.get(i,j)+tx <= S.get(0,11) && P1.get(i,j)+tx >= S.get(0,8)) ||
                  (P1.get(i,j)+tx <= S.get(0,15) && P1.get(i,j)+tx >= S.get(0,12))||
                  (P1.get(i,j)+tx <= S.get(0,19) && P1.get(i,j)+tx >= S.get(0,16)))
                */
                {
                 inSquareX = true;
                 SX1 = 23;
                 xCollisionBlock = (SXN % 4);
                 break;
                }
              
                else
                {
                  inSquareX = false;
                  SX1+=4;
                  SX2+=4;
                  SXN++;
                  xCollisionBlock = -100;
                }
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
            
              int SX1 = 3;
              int SX2 = 0;
              int SXN = 0;
              while (SX1 < 23)
              {
                if((P1.get(i,j)+ty <= (S.get(1,SX1)-100) && P1.get(i,j)+ty >= (S.get(1,SX2)-100)))
                /*
              (P1.get(i,j)+tx <= (S.get(1,7)-100) && P1.get(i,j)+tx >= (S.get(1,4)-100)) ||
              (P1.get(i,j)+tx <= S.get(1,11) && P1.get(i,j)+tx >= S.get(1,8))  ||
                (P1.get(i,j)+tx <= S.get(1,15) && P1.get(i,j)+tx >= S.get(1,12)) ||
                (P1.get(i,j)+tx <= S.get(1,19) && P1.get(i,j)+tx >= S.get(1,16)))
                */
                {
                 inSquareY = true;
                 SX1 = 23;
                 yCollisionBlock = (SXN % 4);
                 break;
               }
              
                else
                {
                  inSquareY = false;
                  SX1 +=4;
                  SX2 +=4;
                  SXN ++;
                  yCollisionBlock = -50;
                }
              }
          }
          if (inSquareX && inSquareY)
          {
            println("x = "+xCollisionBlock+" == y ="+yCollisionBlock);
            if (xCollisionBlock == yCollisionBlock)
            {
              inSquare = true;
            }
            
            else
            {
              inSquare = false;
            }
          }
          else
          {
            inSquare = false;
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
      
      if (inWindow == true && inSquare == false)
      {
        tx = horizontalValue;
        ty = verticalValue;
      }
    }
    
    if (aPressed)
    {
      angle -= radians(rotationRate);
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
            
              int SX1 = 3;
              int SX2 = 0;
              int SXN = 0;
              while (SX1 < 23)
              {
                if((P1.get(i,j)+tx <= (S.get(0,SX1)-100) && P1.get(i,j)+tx >= (S.get(0,SX2)-100)))
                {
                 inSquareX = true;
                 SX1 = 23;
                 xCollisionBlock = (SXN % 4);
                 break;
                }
                
                else
                {
                  inSquareX = false;
                  //stroke((int)random(255),(int)random(255),(int)random(255));
                  SX1+=4;
                  SX2+=4;
                  SXN++;
                  xCollisionBlock = -100;
                }
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
            
            int SX1 = 3;
            int SX2 = 0;
            int SXN = 0;
            while (SX1 < 23)
            {
              if((P1.get(i,j)+ty <= (S.get(1,SX1)-100) && P1.get(i,j)+ty >= (S.get(1,SX2)-100)))
              {
               inSquareY = true;
               SX1 = 23;
               yCollisionBlock = (SXN % 4);
               break;
              }
              
              else
              {
                inSquareY = false;
                SX1 +=4;
                SX2 +=4;
                SXN ++;
                yCollisionBlock = -50;
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
            println("x = "+xCollisionBlock+" == y ="+yCollisionBlock);
            if (xCollisionBlock == yCollisionBlock)
            {
              inSquare = true;
            }
            
            else
            {
              inSquare = false;
            }
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
      angle += radians(rotationRate);
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
  
  float xBot=(float)P1.get(0, 4)+OriginX;
  float yBot=(float)P1.get(1, 4)+OriginY;
  draw_bot(xBot,yBot);
  drawBlocks(S);
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
  
  for (int r = 1; r < 2; r++)
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

void draw_bot(float a,float b)
  {
    //allows changes to be made to structure of the sketch (rectMode,translate origin, etc.) without permanant change
    pushMatrix();
    
    //if not key is pressed
    if (!pressed)
    {
      //Rectangles are drawn from the centre instead of the top left corner 
      rectMode(CENTER);
      
      //translates the origin from top left corner to the robot centre
      translate(a, b);
      
      //Rotates the sketch by the amount specified by the angle variable
      rotate((angle));
      fill(0, 102, 0);
      noStroke();
      
      //Draws centre of robot
      rect(0, 0, 50, 100);
      
      //Rectangles are drawn from the top left corner
      rectMode(CORNER);
      
      //Draws rest of robot
      fill(0);
      rect(25, -50, 25, 100);
      fill(128);
      rect(25, -35, 25, 10);
      rect(25, -5, 25, 10);
      rect(25, 25, 25, 10);
      fill(0);
      rect(-50, -50, 25, 100);
      fill(128);
      rect(-50, -5, 25, 10);
      rect(-50, 25, 25, 10);
      rect(-50, -35, 25, 10);
      stroke(0);
      strokeWeight(5);
      
      //Draws line for ray tracing to be implemented 
      line(0, 0, 0, -100);
      //popMatrix();
    } 
    else if (wPressed)
    {
      rectMode(CENTER);
      translate(a, b);
      rotate((angle));
      fill(0, 102, 0);
      noStroke();
      rect(0, 0, 50, 100);
      rectMode(CORNER);
      fill(0);
      rect(25, -50, 25, 100);

      fill(0);
      rect(-50, -50, 25, 100);

      //loop to create animation of tracks when 'w' or 'W' is pressed.
      fill(128);
      for (int i = -35; i <= 115; i+=30)
      {
        rect(-50, i-frameCount%90, 25, 10);
        rect(25, i-frameCount%90, 25, 10);
      }
      
      //rectangles are drawn the same colour as the background to hide the tracks moving. If you comment them out you can see the tracks moving
      fill(186, 140, 99);
      rect(-55, -130, 110, 80);
      rect(-55, 50, 110, 100);
      stroke(1);
      strokeWeight(5);
      line(0, 0, 0, -100);
    } else if (aPressed)
    {
      rectMode(CENTER);
      translate(a, b);
      rotate((angle));
      fill(0, 102, 0);
      noStroke();
      rect(0, 0, 50, 100);
      rectMode(CORNER);
      fill(0);
      rect(25, -50, 25, 100);
      fill(0);
      rect(-50, -50, 25, 100);

      //loop to create animation of right track when 'a' or 'A' is pressed.
      fill(128);
      for (int i = -35; i <= 115; i+=30)
      {
        rect(25, i-frameCount%90, 25, 10);
      }

      //loop to create animation of left track when 'a' or 'A' is pressed.
      for (int i = -125; i <= 25; i+=30)
      {
        rect(-50, i+frameCount%90, 25, 10);
      }

      fill(186, 140, 99);
      rect(-55, 50, 110, 110);
      rect(-55, -125, 110, 75);
      stroke(0);
      strokeWeight(5);
      line(0, 0, 0, -100);
    } else if (sPressed)
    {
      rectMode(CENTER);
      translate(a, b);
      rotate((angle));
      fill(0, 102, 0);
      noStroke();
      rect(0, 0, 50, 100);
      rectMode(CORNER);
      fill(0);
      rect(25, -50, 25, 100);
      rect(-50, -50, 25, 100);
      fill(128);

      //loop to create animation of tracks when 's' or 'S' is pressed.
      fill(128);
      for (int i = -125; i <= 25; i+=30)
      {
        rect(-50, i+frameCount%90, 25, 10);
        rect(25, i+frameCount%90, 25, 10);
      }

      fill(186, 140, 99);
      rect(-55, 50, 110, 100);
      rect(-55, -140, 110, 90);
      stroke(1);
      strokeWeight(5);
      line(0, 0, 0, -100);
    } else if (dPressed)
    {
      rectMode(CENTER);
      translate(a, b);
      rotate((angle));
      fill(0, 102, 0);
      noStroke();
      rect(0, 0, 50, 100);
      rectMode(CORNER);
      fill(0);
      rect(25, -50, 25, 100);
      rect(-50, -50, 25, 100);
      fill(128);

      //loop to create animation of left track when 'd' or 'D' is pressed.
      fill(128);
      for (int i = -35; i <= 115; i+=30)
      {
        rect(-50, i-frameCount%90, 25, 10);
      }

      //loop to create animation of right track when 'd' or 'D' is pressed.
      for (int i = -125; i <= 25; i+=30)
      {
        rect(25, i+frameCount%90, 25, 10);
      }
      fill(186, 140, 99);
      rect(-55, 50, 110, 110);
      rect(-55, -130, 110, 80);
      stroke(0);
      strokeWeight(5);
      line(0, 0, 0, -100);
    }
    
    /*Ends the matrix so that the original rules on the sketch are untampered with. 
    Without this the whole sketch would be translated in the window.
    The whole sketch would also rotate together when rotate is the a or d key is pressed
    The way the rectangles are drawn by the rect() function would also change*/
    popMatrix();
  }
