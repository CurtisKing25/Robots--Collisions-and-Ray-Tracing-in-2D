/*Window variables needed 
as the size function only has scope in setup() and draw() 
but I want the window generation to produce global varibales
so I can alter the random points of generation as needed per monitor*/
int windowWidth = 800, windowHeight = 800;

//Double array function that generates squares
double [][] generateSquares()
{
  //abbreviation of row length. Will store x and y in individual rows
  int rl = 2;
  //abbreviation of column length. Will store randomly generated numbers for each column
  int cl = 5;
  /*abbreviation of column length 2. 
  Equals the first column length times 4.
  This will represent the 4 corners of a square based off of the 5 randomly generated points*/
  int cl2 = cl*4;
  
  //double array with dimmensions 2 x 5. 5 X values and 5 Y values
  double[][] points = new double[rl][cl];
  //Nested loop. r loops through the rows
  for (int r = 0; r < points.length; r++)
  {
    //c loops through the columns
    for (int c = 0; c < points[0].length; c++)
    {
      /*Each point in the double array will be a random value between 0 and the window width-50.
      It will be cast to an integer as to ensure there will be no problems with the pixel measurements.
      It will then be cast to a double so it can interact with the Jama Matrix library
      */
      points[r][c] = (double)(int)(random(0, windowWidth-50));
    }
  }
  
  //double array with dimmensions 2 x 20. 5 X values and 20 Y values
  double[][] Objectpoints = new double[rl][cl2];
  for (int r = 0; r < Objectpoints.length; r++)
  {
    //p represents the position of the new points that are made from the randomly generated points.
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
        
        //else if you are the 2nd collumn in the x row (collumn before is the first one)
        else if(c-1 == 0)
        {
          // Copies the 1st randomly generated x value to then 2nd x value
          Objectpoints[r][c] = points[r][c-1];
          // adds 50 (translation 50 pixels right)
          Objectpoints[r][c] +=50;
        }
        
        //else if in front of another randomly generated x value
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
          //It is set to the randomly generated y (both indexes are [1][0] therefore no index error can occur)
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

  }
  //returns the double array as an output from the function
  return Objectpoints;
}

//Double array called square array is set to the output returned by the generateSquares() function
double [][] squareArray = generateSquares();

// Matrix S is set to the square array. Array is now in matrix form
Matrix S = new Matrix(squareArray);

//Runs at the start of the program once
void setup()
{
  //sets size to be 800x800. The size() function cannot accept variables so 800 must be manually input. 
  size(800,800);
}

//Runs 60 times a second to mimic animation
void draw()
{
  //Sets a grey background
  background(128);
  
  //strokeWeight added to ensure it could be seen on the screencast.
  strokeWeight(5);
  
  //Calls the drawBlocks() function which draws the squares that have been generated 
  drawBlocks(S);
}

//This defines the drawBlocks function. It is void as drawBlocks does an action but returns no variable
void drawBlocks(Matrix P)
{
  /*Extracts points from a matrix and will be used to get the points 
  for the randomly generated squares
  made by modifying the draw_quad(Matrix P) function given in the lab by John McDonald*/
  for (int i = 0; i < 5; i++)
  {
    //*4 is used below as it looks at each square as the iterations go through
    //Top left point of each square
    float X1=(float)P.get(0, (0+i*4));
    float Y1=(float)P.get(1, (0+i*4));
    
    //Top right point of each square
    float X2=(float)P.get(0, (1+i*4));
    float Y2=(float)P.get(1, (1+i*4));
    
    //Bottom right point of each square
    float X3=(float)P.get(0, (3+i*4));
    float Y3=(float)P.get(1, (3+i*4));
    
    //Bottom left point of each square
    float X4=(float)P.get(0, (2+i*4));
    float Y4=(float)P.get(1, (2+i*4));
    
  // Draws Blocks using corners. Colours lines white
    stroke(255);
    //draws from top left to top right
    line(X1, Y1, X2, Y2);
    //draws from top right to bottom right
    line(X2, Y2, X3, Y3);
    //draws from bottom right to bottom left
    line(X3, Y3, X4, Y4);
    //draws from top left to bottom left
    line(X1, Y1, X4, Y4);
  }
}
