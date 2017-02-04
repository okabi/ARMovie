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

// AR Marker IDs
int[] markerIDs;

// Videos
Movie[] movies;


// Initialization
void setup() {
  // Set window size and to P3D render mode
  size(640, 480, P3D);
  colorMode(RGB, 100);
  
  // Initialization
  cam = new Capture(this, width, height);
  nya = new MultiMarker(this, width, height, "./data/camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  markerIDs = new int[2];
  movies = new Movie[markerIDs.length];
  
  // Add AR markers to detector
  markerIDs[0] = nya.addARMarker("./data/patt.hiro", 80);
  markerIDs[1] = nya.addARMarker("./data/patt.kanji", 80);
  
  // Load Movies
  for(int i = 0; i < markerIDs.length; i++) {
    movies[i] = new Movie(this, "video" + (i + 1) + ".mp4");
    movies[i].loop();
  }
  
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
  for(int i = 0; i < markerIDs.length; i++) {
    if(!nya.isExist(markerIDs[i])) {
      return;
    }
    PVector[] v = nya.getMarkerVertex2D(markerIDs[i]);
    movies[i].read();
    beginShape();
    texture(movies[i]);
    vertex(v[0].x, v[0].y, 0, 0);
    vertex(v[1].x, v[1].y, movies[i].width, 0);
    vertex(v[2].x, v[2].y, movies[i].width, movies[i].height);
    vertex(v[3].x, v[3].y, 0, movies[i].height);
    endShape();
  }
}