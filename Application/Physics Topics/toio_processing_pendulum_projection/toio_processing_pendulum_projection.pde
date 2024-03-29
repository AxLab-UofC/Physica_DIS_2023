import oscP5.*;
import netP5.*;
import teilchen.*;
import teilchen.behavior.*;
import teilchen.constraint.*;
import teilchen.cubicle.*;
import teilchen.force.*;
import teilchen.integration.*;
import teilchen.util.*;
import controlP5.*;
import deadpixel.keystone.*;

// teilchen
Physics mPhysics;
Particle mPendulumRoot;
Particle mPendulumTip;
Spring mConnection;

// controlP5
ControlP5 cp5;
CheckBox checkbox;
CheckBox checkbox2;
CheckBox checkbox3;
Accordion accordion;


//Keystone
Keystone ks;
CornerPinSurface surface;
PGraphics offscreen;


//for OSC
OscP5 oscP5;
//where to send the commands to
NetAddress[] server;


//we'll keep the cubes here
Cube[] cubes;

int projection_correction = 45;
boolean mouseDrive = false;
boolean chase = false;
boolean spin = false;
boolean drop = false;
Gravity mGravity = new Gravity();


void settings() {
  size(1000, 1000, P3D);
  fullScreen();
}



void setup() {


  // for OSC
  // receive messages on port 3333
  oscP5 = new OscP5(this, 3333);

  //send back to the BLE interface
  //we can actually have multiple BLE bridges
  server = new NetAddress[1]; //only one for now
  //send on port 3334
  server[0] = new NetAddress("127.0.0.1", 3334);
  //server[1] = new NetAddress("192.168.0.103", 3334);
  //server[2] = new NetAddress("192.168.200.12", 3334);


  //create cubes
  cubes = new Cube[nCubes];
  for (int i = 0; i< cubes.length; ++i) {
    cubes[i] = new Cube(i, true);
  }

  //do not send TOO MANY PACKETS
  //we'll be updating the cubes every frame, so don't try to go too high
  frameRate(30);

  mPhysics = new Physics();
  /* the direction of the gravity is defined by the 'force' vector */
  mGravity.force().set(0, 30);
  /* forces, like gravity or any other force, can be added to the system. they will be automatically applied to
   all particles */
  mPhysics.add(mGravity);
  mPendulumRoot = mPhysics.makeParticle(0, 0, 0, 0.05f);
  mPendulumRoot.position().set(width / 7f, 100);
  mPendulumRoot.fixed(true);
  mPendulumTip = mPhysics.makeParticle(0, 0, 0, 0.05f);
  float mSegmentLength = height / 5.0f;
  mConnection = new Spring(mPendulumRoot, mPendulumTip, mSegmentLength);
  mConnection.damping(0.0f);
  mConnection.strength(10);
  mPhysics.add(mConnection);


  //for projections
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(600, 410, 20);

  // We need an offscreen buffer to draw the surface we
  // want projected
  // note that we're matching the resolution of the
  // CornerPinSurface.
  // (The offscreen buffer can be P2D or P3D)
  offscreen = createGraphics(600, 410, P3D);


  parameter_gui();
}

void draw() {
  background(255);
  stroke(0);
  long now = System.currentTimeMillis();

  // change gravity using control p5 slider
  float s1 = cp5.getController("gravity").getValue();
  mGravity.force().set(0, s1);
  // change grope length using control p5 slider
  float s2 = cp5.getController("Rope length").getValue();
  mConnection.restlength(s2);

  //draw the "mat"
  fill(255);
  rect(45, 45, 410, 410);







  int time = 0;


  // toio drop code start
  if (drop) {



    mPhysics.step(1.0f / frameRate, 5);

    Particle p1 = mPendulumRoot;
    Particle p2 = mPendulumTip;

    stroke(0, 191);
    noFill();


    int backgroundCol = 0;
    int strokeCol = 255;


    offscreen.beginDraw();
    offscreen.background(backgroundCol);

    // draw spring
    if (checkbox2.getArrayValue()[0] == 1) {
      offscreen.stroke(strokeCol);
      offscreen.line(p1.position().x - projection_correction, p1.position().y - projection_correction, p2.position().x - projection_correction, p2.position().y - projection_correction);
    }
    // draw particle
    if (checkbox2.getArrayValue()[1] == 1) {
      offscreen.fill(strokeCol);
      offscreen.stroke(strokeCol);
      offscreen.ellipse(p1.position().x - projection_correction, p1.position().y - projection_correction, 10, 10);
      offscreen.ellipse(p2.position().x - projection_correction, p2.position().y - projection_correction, 20, 20);
    }
    // draw path
    if (checkbox2.getArrayValue()[2] == 1) {
      offscreen.fill(50, 82, 200);
      offscreen.stroke(50, 82, 200);
      for (int j = 0; j < cubes[0].aveFrameNumPosition; j++) {

        offscreen.ellipse(cubes[0].cube_position_x[j] - projection_correction, cubes[0].cube_position_y[j] - projection_correction, 2, 2);
      }
    }
    //draw the cubes
    if (checkbox2.getArrayValue()[3] == 1 ) {

      for (int i = 0; i < cubes.length; ++i) {
        if (cubes[i].isLost==false) {
          offscreen.pushMatrix();
          offscreen.fill(backgroundCol);
          offscreen.stroke(strokeCol);
          offscreen.translate(cubes[i].x - projection_correction, cubes[i].y - projection_correction);
          offscreen.rotate(cubes[i].deg * PI/180);
          offscreen.rect(-10, -10, 20, 20);
          offscreen.rect(0, -5, 20, 10);
          offscreen.popMatrix();
        }
      }
    }

    if (checkbox3.getArrayValue()[0] == 1) {
      // draw velocity vector
      offscreen.pushMatrix();
      offscreen.translate(cubes[0].x, cubes[0].y);
      offscreen.stroke(195, 155, 211);
      drawArrow(0, 0, cubes[0].ave_speedX, cubes[0].ave_speedY, 0);
      offscreen.popMatrix();
    }

    if (checkbox3.getArrayValue()[1] == 1) {
      // draw mParticle vector
      offscreen.pushMatrix();
      offscreen.translate(cubes[0].x, cubes[0].y);
      offscreen.stroke(248, 196, 113);
      drawArrow(0, 0, p2.velocity().x, p2.velocity().y, 0);
      offscreen.popMatrix();
    }



    if (checkbox.getArrayValue()[0] == 1) {





      if (cubes[0].isLost==false && cubes[0].p_isLost == true) {
        p2.position().set(cubes[0].x, cubes[0].y);
        p2.velocity().set(0, 0);
        p2.velocity().mult(10);
      }
      if (cubes[0].isLost==false) {

        aimCubePosVel(cubes[0].id, p2.position().x, p2.position().y, p2.velocity().y, p2.velocity().x);
        if ( dist(cubes[0].x, cubes[0].y, p2.position().x, p2.position().y) > 40) {
          p2.position().set(cubes[0].x, cubes[0].y);
        }
      }
    }

    offscreen.endDraw();

    background(0);
    // render the scene, transformed using the corner pin surface
    surface.render(offscreen);
  }

  // toio drop code end




  if (chase) {
    cubes[0].targetx = cubes[0].x;
    cubes[0].targety = cubes[0].y;
    cubes[1].targetx = cubes[0].x;
    cubes[1].targety = cubes[0].y;
  }
  //makes a circle with n cubes
  if (mouseDrive) {
    float mx = (mouseX);
    float my = (mouseY);
    float cx = 45+410/2;
    float cy = 45+410/2;

    float mulr = 180.0;

    float aMouse = atan2( my-cy, mx-cx);
    float r = sqrt ( (mx - cx)*(mx-cx) + (my-cy)*(my-cy));
    r = min(mulr, r);
    for (int i = 0; i< nCubes; ++i) {
      if (cubes[i].isLost==false) {
        float angle = TWO_PI*i/nCubes;
        float na = aMouse+angle;
        float tax = cx + r*cos(na);
        float tay = cy + r*sin(na);
        fill(255, 0, 0);
        ellipse(tax, tay, 10, 10);
        cubes[i].targetx = tax;
        cubes[i].targety = tay;
      }
    }
  }

  if (spin) {
    motorControl(0, -100, 100, 30);
  }

  if (chase || mouseDrive) {
    //do the actual aim
    for (int i = 0; i< nCubes; ++i) {
      if (cubes[i].isLost==false) {
        fill(0, 255, 0);
        stroke(0, 0, 0);
        ellipse(cubes[i].targetx, cubes[i].targety, 10, 10);
        aimCubeSpeed(i, cubes[i].targetx, cubes[i].targety);
      }
    }
  }


  //did we lost some cubes?
  for (int i=0; i<nCubes; ++i) {
    // 500ms since last update
    cubes[i].p_isLost = cubes[i].isLost;
    if (cubes[i].lastUpdate < now - 800 && cubes[i].isLost==false) {
      cubes[i].isLost= true;
    }
  }
}



void keyPressed() {
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped
    // and moved
    ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    break;
  case 'd':
    drop = true;
    chase = false;
    spin = false;
    mouseDrive = false;
    break;

  case 'a':
    for (int i=0; i < nCubes; ++i) {
      aimMotorControl(i, 380, 260);
    }
    break;
  case 'k':
    light(0, 100, 255, 0, 0);
    break;
  default:
    break;
  }
}






void drawArrow(float x1, float y1, float x2, float y2, int i) {
  if (cubes[i].isLost==false) {
    float a = dist(x1, y1, x2, y2) / 50;
    offscreen.pushMatrix();
    offscreen.translate(x2 - projection_correction, y2- projection_correction);
    offscreen.rotate(atan2(y2 - y1, x2 - x1));
    offscreen.triangle(- a * 2, - a, 0, 0, - a * 2, a);
    offscreen.popMatrix();
    offscreen.line(x1- projection_correction, y1- projection_correction, x2- projection_correction, y2- projection_correction);
  }
}
