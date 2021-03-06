
var
  WIDTH   = 800,
  HEIGHT  = 800,
  MAX_AGE = 100,
  STEPS = 900,
  FILL = #FFFFFF,
  STROKE = -1,
  ALFA = 75,
  BACKGROUND = #000000
  SMOOTHNESS = .0005;

PVector[] DIRECTIONS;
int[][] INDICES;
ArrayList<Particle> particles;

PImage base; // animation
PImage top;



void setup() {
    size(800, 800);
    fill(FILL, ALFA);
    noStroke();
    background(BACKGROUND);
    
    //storing the indices associated with the vector field
    INDICES = new int[WIDTH][HEIGHT];
    for (int y = 0; y < HEIGHT; y++) for (int x = 0; x < WIDTH; x++) INDICES[x][y] = int(noise(x*SMOOTHNESS, y*SMOOTHNESS)*STEPS); 

    //storing the directions associated with the vector field
    DIRECTIONS = new PVector[STEPS];
    for (int i = 0; i < STEPS; i++) DIRECTIONS[i] = new PVector(cos(i*.5)*.05, sin(i*.5)*.1);  
    
    //Particles
    particles = new ArrayList<Particle>();
    
    //Base picture
    base= loadImage("austin.jpg");

    
    
}

void draw() {
    //Draw when dragging
    if (mousePressed) particles.add(new Particle(mouseX, mouseY));       
    
    //Update the particles
    for(int i = 0; i < particles.size(); i++) 
    {
        Particle p = particles.get(i);
        if (p.isDead() == false) {
            p.update();
            p.draw();
        }
        
        
        else particles.remove(i);
    }
   
} 

//Clean canvas
void keyPressed() {
    background(BACKGROUND);  
}



class Particle
{   
    PVector pos, vel;
    int x, y, s, age;
    
  Particle(int _x_, int _y_)
  {
    x = _x_;
    y = _y_;
    pos = new PVector(x, y);
    vel = new PVector();
    age = MAX_AGE;
  }
   
  boolean isDead() { return age==0; } 
    
  void draw() { ellipse(pos.x, pos.y, s, s); 

}  
    
  void update() 
  { 
    vel.add(DIRECTIONS[INDICES[(x+WIDTH)%WIDTH][(y+HEIGHT)%HEIGHT]]);
    pos.add(vel);
    x = int(pos.x);
    y = int(pos.y);
    s = brightness(base.get(x, y)) >> 6;
    age--;
  }   
  
  //I don't like processing's brightness method. This one is simpler and more efficient
  int brightness(int c) { 
    int r = c >> 16 & 0xFF, g = c >> 8 & 0xFF, b = c & 0xFF; 
    return c = (c = r > g ? r : g) < b ? b : c; 

 
  } 

  
}



