/**
 * Spotright to AR Marker
 * !!!!! DO NOT PRESS "STOP BUTTON" WHEN YOU FINISH THIS PROGRAM !!!!!
 */

import processing.video.*;
import jp.nyatla.nyar4psg.*;


// web Camera for capture
Capture cam;

// AR Marker detector
MultiMarker nya;

// AR Marker ID
int markerID;

// Video
Movie mov;


// Initialization
void setup() {
  // Set window size and to P3D render mode
  size(640, 480, P3D);
  colorMode(RGB, 100);
  
  // Initialization
  cam = new Capture(this, width, height);
  nya = new MultiMarker(this, width, height, "./data/camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);

  // Add AR markers to detector
  markerID = nya.addARMarker("./data/patt.hiro", 80);
  
  // Load Movie
  mov = new Movie(this, "video.mp4");
  mov.loop();
  
  // Start Camera
  cam.start();
}


void draw() {
  // Check exception
  if(!cam.available()) {
    return;
  }
  
  // Detect AR markers
  cam.read();
  nya.detect(cam);
  
  // Draw camera capture
  nya.drawBackground(cam);

  // Draw movie on AR marker
  if(!nya.isExist(markerID)) {
    return;
  }
  PVector[] v = nya.getMarkerVertex2D(markerID);
  mov.read();
  beginShape();
  texture(mov);
  vertex(v[0].x, v[0].y, 0, 0);
  vertex(v[1].x, v[1].y, mov.width, 0);
  vertex(v[2].x, v[2].y, mov.width, mov.height);
  vertex(v[3].x, v[3].y, 0, mov.height);
  endShape();
}