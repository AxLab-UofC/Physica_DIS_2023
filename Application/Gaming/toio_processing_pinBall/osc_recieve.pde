

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/position") == true) {
    int hostId = msg.get(0).intValue();
    int id = msg.get(1).intValue();
    //int matId = msg.get(1).intValue();
    int posx = msg.get(2).intValue();
    int posy = msg.get(3).intValue();

    int degrees = msg.get(4).intValue();
    //println("Host "+ hostId +" id " + id+" "+posx +" " +posy +" "+degrees);

    id = cubesPerHost*hostId + id;

    if (id < cubes.length) {
      cubes[id].count++;



      float elapsedTime = System.currentTimeMillis() -  cubes[id].lastUpdate ;




      cubes[id].prex = cubes[id].x;
      cubes[id].prey = cubes[id].y;



      cubes[id].x = posx;
      cubes[id].y = posy;


      cubes[id].speedX = 1000.0 * float(cubes[id].x - cubes[id].prex) / elapsedTime;
      cubes[id].speedY = 1000.0 * float(cubes[id].y - cubes[id].prey) / elapsedTime;

      cubes[id].preSpeedX = cubes[id].speedX;
      cubes[id].preSpeedY = cubes[id].speedY;


      cubes[id].pre_deg = cubes[id].deg;
      cubes[id].deg = degrees;

      cubes[id].lastUpdate = System.currentTimeMillis();

      float sumX = 0, sumY = 0;
      for (int j = 0; j < cubes[id].aveFrameNum - 1; j++) {
        cubes[id].pre_speedX[cubes[id].aveFrameNum -1 - j] = cubes[id].pre_speedX[cubes[id].aveFrameNum -j -2];
        cubes[id].pre_speedY[cubes[id].aveFrameNum -1 - j] = cubes[id].pre_speedY[cubes[id].aveFrameNum -j -2];
        sumX += cubes[id].pre_speedX[cubes[id].aveFrameNum -1 - j];
        sumY += cubes[id].pre_speedY[cubes[id].aveFrameNum -1 - j];
      }


      sumX +=  cubes[id].speedX;
      sumY +=  cubes[id].speedY;

      cubes[id].pre_speedX[0] = cubes[id].speedX;
      cubes[id].pre_speedY[0] = cubes[id].speedY;

      //println(cubes[id].speedX, cubes[id].speedY);

      cubes[id].ave_speedX = sumX / float(cubes[id].aveFrameNum);
      cubes[id].ave_speedY = sumY / float(cubes[id].aveFrameNum);

      //println(cubes[id].ave_speedX, cubes[id].ave_speedY);
      if (cubes[id].isLost == true) {
        cubes[id].isLost = false;
      }
    }
  } else if (msg.checkAddrPattern("/button") == true) {
    int hostId = msg.get(0).intValue();
    int relid = msg.get(1).intValue();
    int id = cubesPerHost*hostId + relid;
    int pressValue =msg.get(2).intValue();



    cubes[id].pre_press = cubes[id].press;
    cubes[id].press = pressValue;
    //println("Button pressed for id : "+id);
  } else if (msg.checkAddrPattern("/motion") == true) {
    int hostId = msg.get(0).intValue();
    int relid = msg.get(1).intValue();
    int id = cubesPerHost*hostId + relid;
    int flatness =msg.get(2).intValue();
    int hit =msg.get(3).intValue();
    int double_tap =msg.get(4).intValue();
    int face_up =msg.get(5).intValue();
    int shake_level =msg.get(6).intValue();



    //println("motion for id "+id +": " + flatness +", "+ hit+", "+ double_tap+", "+ face_up+", "+ shake_level);
  }
}
