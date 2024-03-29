
void setupProjectileEventDetector() {
  mPhysics = new Physics();
  /* create a gravitational force */

  /* the direction of the gravity is defined by the 'force' vector */
  mGravity.force().set(0, 30);
  /* forces, like gravity or any other force, can be added to the system. they will be automatically applied to
   all particles */
  mPhysics.add(mGravity);
  /* create a particle and add it to the system */
  mParticle = mPhysics.makeParticle();

  //setup projectile parameters
  print("feature added");
  //
}




void projectile() {


  final float mDeltaTime = 1.0f / frameRate;
  mPhysics.step(mDeltaTime);

  stroke(255, 255, 0);
  fill(255, 0, 0);





  stroke(204, 102, 0);


  for (int i = 0; i< nCubes; ++i) {
    if (cubes[i].isLost == true) {

      cubes[i].state = 1;
    }

    if (cubes[i].isLost==false) {

      if (cubes[i].state == 1) {
        cubes[i].origin_x = cubes[i].x;
        cubes[i].origin_y = cubes[i].y;
        cubes[i].state += 1;
      }



      //println(dist(cubes[i].origin_x, cubes[i].origin_y, cubes[i].x, cubes[i].prey) > 60 && dist(cubes[i].origin_x, cubes[i].origin_y, cubes[i].x, cubes[i].y) > 60);
      //println(cubes[i].state);
      boolean condition = dist(cubes[i].origin_x, cubes[i].origin_y, cubes[i].x, cubes[i].prey) > 60 && dist(cubes[i].origin_x, cubes[i].origin_y, cubes[i].x, cubes[i].y) > 60;
      if ((condition == true && cubes[i].state == 2)) {
        cubes[i].state += 1;
        mParticle.position().set(cubes[i].x, cubes[i].y);
        mParticle.velocity().set(cubes[i].speedX/4, cubes[i].speedY/4);
      }


      if (cubes[i].state > 2 ) {
         
         
        aimCubePosVel(cubes[i].id, mParticle.position().x, mParticle.position().y, mParticle.velocity().y, mParticle.velocity().x);
        //print("state 3 triggered!");
      }
    }
  }
}
