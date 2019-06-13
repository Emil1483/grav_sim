Planet[] planet;

float G = 6.67408 * pow(10, -11);
float forceMultMouse = 500;
float mingravR = 5;
float mingravRMouse = 10;
float minTouchR = 1;
float distPPixel = 60710;
PVector mousePos = new PVector();
float mouseMass = 1 * pow(10, 20);
float touchesVelMult = 0.9;
float chanceToSlowDown = 10;
float minTouchesVel = 5;
float chanceToSplitMass = 5;
float unfairMaxSplit = 0.02;

void setup() {
  ellipseMode(CENTER);
  fullScreen(P2D, 2);
  frameRate(144);
  planet = new Planet[1200];
  for(int i = 0; i < planet.length; i++) {
    planet[i] = new Planet();
  }
}

void applyGrav(int i, int j) {
  if (!ellipseTouches(planet[i].pos,  mingravR,  planet[j].pos,  mingravR)) {
    float forceMag = G * planet[i].mass * planet[j].mass / pow(dist(planet[i].pos.x, planet[i].pos.y, planet[j].pos.x, planet[j].pos.y) * distPPixel, 2);
    PVector force = new PVector();
    force.set(planet[j].pos);
    force.sub(planet[i].pos);
    force.normalize();
    force.mult(forceMag);
    
    planet[i].applyForce(force);
  }
}

void applyMouseGrav(int i) {
  if (!ellipseTouches(planet[i].pos,  mingravRMouse,  mousePos,  mingravRMouse) && mousePressed) {
    float forceMag = G * planet[i].mass * mouseMass / pow(dist(planet[i].pos.x, planet[i].pos.y, mousePos.x, mousePos.y) * distPPixel, 2);
    PVector force = new PVector();
    force.set(mousePos);
    force.sub(planet[i].pos);
    force.normalize();
    force.mult(forceMultMouse);
    force.mult(forceMag);
    
    planet[i].applyForce(force);
  }
}

boolean ellipseTouches(PVector pos1, float r1, PVector pos2, float r2) {
  if (dist(pos1.x, pos1.y, pos2.x, pos2.y) < r1 + r2) {
    return true;
  } else {
    return false;
  }
}

void draw() {
  println(frameRate);
  background(0);
  mousePos.x = mouseX;
  mousePos.y = mouseY;
    
  for(int i = 0; i < planet.length; i++) {
    applyMouseGrav(i);
    for(int j = 0; j < planet.length; j++) {
      if (i != j) {
        applyGrav(i, j);
        if (ellipseTouches(planet[i].pos,  minTouchR,  planet[j].pos,  minTouchR)) {
          PVector iVel = new PVector(planet[i].vel.x, planet[i].vel.y);
          planet[i].vel.set(planet[j].vel);
          planet[i].vel.mult(planet[j].mass);
          planet[i].vel.div(planet[i].mass);
          planet[j].vel.set(iVel);
          planet[j].vel.mult(planet[i].mass);
          planet[j].vel.div(planet[j].mass);
          if(random(100) < chanceToSplitMass) {
            float iMass = planet[i].mass;
            planet[i].mass += random(unfairMaxSplit)*planet[j].mass;
            float diff = planet[i].mass - iMass;
            planet[j].mass -= diff;
          }
          if (dist(0, 0, planet[j].vel.x, planet[j].vel.y) > minTouchesVel && random(100) < chanceToSlowDown) {
            planet[j].vel.mult(touchesVelMult);
          }
          if (dist(0, 0, planet[i].vel.x, planet[i].vel.y) > minTouchesVel && random(100) < chanceToSlowDown) {
            planet[i].vel.mult(touchesVelMult);
          }
        }
      }
    }
    planet[i].update();
    planet[i].show();
    
  }
}