class Planet {
  PVector pos = new PVector();
  PVector vel = new PVector();
  PVector acc = new PVector();
  
  float r = 1;
  float realR;
  float mass = 1 * pow(10, 20);
  float speedLim = 999999;
  float edgefalloff = 0.5;
  float[] c = {0, 0, 0, 255};
  
  Planet() {
    if(random(1) < 0.5) {
      pos.set(random(width*2/3, width - r), random(r, height - r));
    } else {
      pos.set(random(0, width/3), random(r, height - r));
    }
    for (int i = 0; i < 3; i++) {
      c[i] = random(255);
    }
  }
 
 void edges() {
   if (pos.x + r > width) {
     pos.x = width-r;
     vel.x *= -1;
     vel.mult(edgefalloff);
   }
   if (pos.y + r > height) {
     pos.y = height-r;
     vel.y *= -1;
     vel.mult(edgefalloff);
   }
    if (pos.x - r < 0) {
     pos.x = r;
     vel.x *= -1;
     vel.mult(edgefalloff);
   }
    if (pos.y - r < 0) {
     pos.y = r;
     vel.y *= -1;
     vel.mult(edgefalloff);
   }
 }
  
  void applyForce(PVector force) {
    force.div(mass);
    acc.add(force);
  }
  
  void update() {
    vel.add(acc);
    vel.limit(speedLim);
    pos.add(vel);
    edges();
    realR = map(mass, 1 * pow(10, 20), 1.4 * pow(10, 20), r, r+4);
  }
  
  void show() {
    noStroke();
    fill(c[0], c[1], c[2], 50);
    ellipse(pos.x, pos.y, realR*8, realR*8);    
    fill(c[0], c[1], c[2], 120);
    ellipse(pos.x, pos.y, realR*5, realR*4);
    fill(c[0], c[1], c[2], 255);
    ellipse(pos.x, pos.y, realR*2, realR*2);
    acc.mult(0);
  }
  
}