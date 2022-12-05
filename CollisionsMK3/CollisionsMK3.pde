//CollisionsMK3 is based off CollisionsMK2.pde but important or new code will be commented.

//The grid draws when the w key is pressed as this was used to try and solve the issues I was having with my collisions.

/*
3 Errors that remain in this code. One is that the left point doesn't work for the collision detection in the squares.
I think this is being caused by the second iteration of the nested for loop overwritting the variables answers.
This results in the left top corner being able to pass through the blocks as the right corner has higher priority.
I am unable to fix this within the time limit but I have divided the (i == 1) part of the check further by (j == 0) and (j == 1).
I think if the right variable was placed with (j == 1) it could check if a previous collision has already occured and not run*/

/*The second is that I have used modulus in such a way that 2 extra invisible blocks have been created as two squares have the sqaure value of 0.
This makes where their x and y collision boundaries crossover count as squares.
A solution could be to check both correlating x and y boundraries in the one while loop as this removes the potential for boundary overlap*/

/*The final error is that overlapping squares produce problems for my collision detection logic such as getting caught or being unable to stop the robot.
Again checking both x and y could potentially solve this problem 
or make the randomiser reroll if the x or y values are to close to each other*/


float angle=0;
float OriginX = 100, OriginY = 100;
double horizontalValue;
double verticalValue;
boolean inWindowX = true, inWindowY = true, inWindow, inSquareX = false, inSquareY = false, inSquare;

/*Window variables needed 
as the size function only has scope in setup() and draw() 
but I want the square generation to produce global varibales*/
int windowWidth = 900, windowHeight = 880; //For size(x,y) Match windowWidth to x and windowheight to y.
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
//CHANGE THE 20S TO 50S TO MATCH THE SIZE OF THE ROBOT.
double[][] Pvals = {{-20, 20, 20, -20}, 
  {-20, -20, 20, 20}};  

Matrix P = new Matrix(Pvals);

double tx = 0, ty = 0; 
int speed = 5;

void setup() 
{
  // Create a window 400x400
  //size(400, 400);
  //frameRate(1);
  size(900, 880);
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
      //strokeWeight(5);
      horizontalValue = tx - -speed*sin(angle);
      verticalValue = ty - speed*cos(angle);
      
      //Nested loop for the front points of the robot
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
              
              //SX tracks the boundraries for the squares in the x axis
              
              //SX1 is the bigger value and SX2 is the smaller value
              int SX1 = 3;
              int SX2 = 0;
              
              //SXN will keep track of which square the collision has occured in
              int SXN = 0;
              
              //while loop that loops through all the points on all the squares
              while (SX1 < 23)
              {
                //if a the current corner plus the translation is within a square's x boundaries
                if((P1.get(i,j)+tx <= (S.get(0,SX1)-100) && P1.get(i,j)+tx >= (S.get(0,SX2)-100)))
                /*
                
                //Original plan of using or statements did not work for some reason
                || 
                  (P1.get(i,j)+tx <= (S.get(0,7)-100) && P1.get(i,j)+tx >= (S.get(0,4)-100)) || 
                  (P1.get(i,j)+tx <= S.get(0,11) && P1.get(i,j)+tx >= S.get(0,8)) ||
                  (P1.get(i,j)+tx <= S.get(0,15) && P1.get(i,j)+tx >= S.get(0,12))||
                  (P1.get(i,j)+tx <= S.get(0,19) && P1.get(i,j)+tx >= S.get(0,16)))
                */
                {
                  
                  //Sets draw colour to red
                 stroke(255,0,0);
                 
                 //Extracts the x boundaries 
                 float Sline1 = (float)(S.get(0,SX1));
                 float Sline2 = (float)(S.get(0,SX2));
                 
                 //Draws red lines to indicate all x boundaries
                 line(Sline1,0,Sline1,height);
                 line(Sline2,0,Sline2,height);
                 
                 //Sets draw colour to black again for robot
                 stroke(0);
                 
                 //Collision occurs in the x axis
                 inSquareX = true;
                 
                 //Go to the end of the loop 
                 SX1 = 23;
                 
                 //xCollisionBlock is set to the modulus of the points (which square the collision in the x axis occured)
                 xCollisionBlock = (SXN % 4);
                 //xCollisionBlock = SXN;
                 //breaks out of the loop
                 break;
                }
              
                else
                {
                  //No collision occured in the x axis
                  inSquareX = false;
                  
                  //X boundaries are drawn
                  //stroke((int)random(255),(int)random(255),(int)random(255));
                  stroke(255,0,0);
                 float Sline1 = (float)(S.get(0,SX1));
                 float Sline2 = (float)(S.get(0,SX2));
                 line(Sline1,0, Sline1,height);
                 line(Sline2,0, Sline2,height);
                 stroke(0);
                 
                 //SX1 and SX" are increased by 4 so they can go to the next square
                  SX1+=4;
                  SX2+=4;
                  
                  //SXN is incremented to track which square is being checked for collisions
                  SXN++;
                  xCollisionBlock = -100;
                }
              }
              
          }
          
          //The same as the previous part if(i == 0) but for y values instead of x
          if(i == 1)
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
              
              //SY used instead of SX as the y co-ordinates are being found
              int SY1 = 3;
              int SY2 = 0;
              int SYN = 0;
              while (SY1 < 23)
              {
                if (j == 0)
                {
                  if((P1.get(i,j)+ty <= (S.get(1,SY1)-100) && P1.get(i,j)+ty >= (S.get(1,SY2)-100)))
                  /*
                (P1.get(i,j)+tx <= (S.get(1,7)-100) && P1.get(i,j)+tx >= (S.get(1,4)-100)) ||
                (P1.get(i,j)+tx <= S.get(1,11) && P1.get(i,j)+tx >= S.get(1,8))  ||
                  (P1.get(i,j)+tx <= S.get(1,15) && P1.get(i,j)+tx >= S.get(1,12)) ||
                  (P1.get(i,j)+tx <= S.get(1,19) && P1.get(i,j)+tx >= S.get(1,16)))
                  */
                  {
                   inSquareY = true;
                   stroke(0,255,0);
                   float Sline1 = (float)(S.get(1,SY1));
                   float Sline2 = (float)(S.get(1,SY2));
                   line(0,Sline1,width,Sline1);
                   line(0,Sline2,width,Sline2);
                   stroke(0);
                   SY1 = 23;
                   yCollisionBlock = (SYN % 4);
                   //yCollisionBlock = SYN;
                   break;
                 }
                
                  else
                  {
                    inSquareY = false;
                    stroke(0,255,0);
                    float Sline1 = (float)(S.get(1,SY1));
                    float Sline2 = (float)(S.get(1,SY2));
                    line(0,Sline1,width,Sline1);
                    line(0,Sline2,width,Sline2);
                    stroke(0);
                    SY1 +=4;
                    SY2 +=4;
                    SYN ++;
                    yCollisionBlock = -50;
                  }
                }
                
                if (j == 1)
                {
                  if((P1.get(i,j)+ty <= (S.get(1,SY1)-100) && P1.get(i,j)+ty >= (S.get(1,SY2)-100)))
                  /*
                (P1.get(i,j)+tx <= (S.get(1,7)-100) && P1.get(i,j)+tx >= (S.get(1,4)-100)) ||
                (P1.get(i,j)+tx <= S.get(1,11) && P1.get(i,j)+tx >= S.get(1,8))  ||
                  (P1.get(i,j)+tx <= S.get(1,15) && P1.get(i,j)+tx >= S.get(1,12)) ||
                  (P1.get(i,j)+tx <= S.get(1,19) && P1.get(i,j)+tx >= S.get(1,16)))
                  */
                  {
                   inSquareY = true;
                   stroke(0,255,0);
                   float Sline1 = (float)(S.get(1,SY1));
                   float Sline2 = (float)(S.get(1,SY2));
                   line(0,Sline1,width,Sline1);
                   line(0,Sline2,width,Sline2);
                   stroke(0);
                   SY1 = 23;
                   yCollisionBlock = (SYN % 4);
                   //yCollisionBlock = SYN;
                   break;
                 }
                
                  else
                  {
                    inSquareY = false;
                    stroke(0,255,0);
                    float Sline1 = (float)(S.get(1,SY1));
                    float Sline2 = (float)(S.get(1,SY2));
                    line(0,Sline1,width,Sline1);
                    line(0,Sline2,width,Sline2);
                    stroke(0);
                    SY1 +=4;
                    SY2 +=4;
                    SYN ++;
                    yCollisionBlock = -50;
                  }
                }
                
                
                
                
                
              }
          }
          
          //if a collision occurs in the x axis and y axis
          if (inSquareX && inSquareY)
          {
            println("x = "+xCollisionBlock+" == y ="+yCollisionBlock);
            
            //if they are on the same square
            if (xCollisionBlock == yCollisionBlock)
            {
              //It is colliding with the block
              inSquare = true;
            }
            
            else
            {
              //It is not
              inSquare = false;
            }
          }
          else
          {
            //The collision in no longer occuring
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
      
      //if it is in the window and not in the square
      if (inWindow == true && inSquare == false)
      {
        //The translation can be applied
        tx = horizontalValue;
        ty = verticalValue;
      }
    }
    
    if (aPressed)
    {
      angle -= radians(5);
      if (abs(round(degrees(angle))) == 360) angle = 0;
    }
    
    //Use previous collision sytem that only works for the first block to aid with testing
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
             println(inSquareX);
             println("PX = "+(P1.get(i,j)+tx)+"<= SX1 = "+(S.get(0,3)-100));
             println("PX = "+(P1.get(i,j)+tx)+">= SX1 = "+(S.get(0,0)-100));
             break;
            }
            
            else
            {
              inSquareX = false;
              println(inSquareX);
              println("PX = "+(P1.get(i,j)+tx)+"<= SX1 = "+(S.get(0,3)-100));
              println("PX = "+(P1.get(i,j)+tx)+">= SX1 = "+(S.get(0,0)-100));
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
               println(inSquareY);
               println("PY = "+(P1.get(i,j)+ty));
               println("SY = "+(S.get(1,3)-100));
               break;
              }
              
              else
              {
                inSquareY = false;
                println(inSquareY);
                println("PY = "+(P1.get(i,j)+ty));
                println("SY = "+(S.get(1,3)-100));
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
