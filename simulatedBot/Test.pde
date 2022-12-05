class Test
{  
  float horizontalValue;
  float verticalValue;
  float test_rotate_bot()
  {
    {
      if (pressed)
      {
        if (wPressed)
        {
          horizontalValue = i - -speed*sin(radians(rotate));
          verticalValue = j - speed*cos(radians(rotate));

          if ((horizontalValue <= width - 50 && horizontalValue >= 50) && (verticalValue <= height - 50) && verticalValue >= 50)
          {
            i = horizontalValue;
            j = verticalValue;
            canRotate = true;
          } 
           
           else
           {
             canRotate = false;
           }
           
        }

        if (canRotate && aPressed)
        {
          rotate--;

          if (abs(rotate) == 360) rotate = 0;
        }

        if (sPressed)
        {
          horizontalValue = i + -speed*sin(radians(rotate));
          verticalValue = j + speed*cos(radians(rotate));
          if ((horizontalValue <= width - 50 && horizontalValue >= 50) && (verticalValue <= height - 50) && verticalValue >= 50)
          {
            i = horizontalValue;
            j = verticalValue;
            canRotate = true;
             println("horizontal value: "+horizontalValue);
          println("vertical value: "+verticalValue);
          } else
          {
            canRotate = false;
          }
        }

        if (canRotate && dPressed)
        {
          rotate++;

          if (abs(rotate) == 360) rotate = 0;
        }
      }
    }
    return rotate;
  }


  void test_draw_bot()
  {
    if (wPressed && canRotate)
    {
      rectMode(CENTER);
      translate(i, j);
      rotate(radians(rotate));
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

      fill(186, 140, 99);
      rect(-55, -130, 110, 80);
      rect(-55, 50, 110, 100);
      stroke(1);
      strokeWeight(5);
      line(0, 0, 0, -100);
    }
    
    else if (aPressed && canRotate)
    {
      rectMode(CENTER);
      translate(i, j);
      rotate(radians(rotate));
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
    }
    
    else if (sPressed && canRotate)
    {
      rectMode(CENTER);
      translate(i, j);
      rotate(radians(rotate));
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
    } 
    
    else if (dPressed && canRotate)
    {
      rectMode(CENTER);
      translate(i, j);
      rotate(radians(rotate));
      fill(0, 102, 0);
      noStroke();
      rect(0, 0, 50, 100);
      rectMode(CORNER);
      fill(0);
      rect(25, -50, 25, 100);
      rect(-50, -50, 25, 100);
      fill(128);

      //loop to create animation of tracks when 'w' or 'W' is pressed.
      fill(128);

      //loop to create animation of right track when 'a' or 'A' is pressed.
      fill(128);
      for (int i = -35; i <= 115; i+=30)
      {
        rect(-50, i-frameCount%90, 25, 10);
      }

      //loop to create animation of left track when 'a' or 'A' is pressed.
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
    
    else
    {
      //pushMatrix();
      rectMode(CENTER);
      translate(i, j);
      rotate(radians(rotate));
      fill(0, 102, 0);
      noStroke();
      rect(0, 0, 50, 100);
      rectMode(CORNER);
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
      line(0, 0, 0, -100);
      //popMatrix();
    } 
  }
}
