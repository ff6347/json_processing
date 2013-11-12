/*
 * openpaths_simple_json.pde
 * @author Fabian Moron Zirfas
 * simple json reading with processingjs
 * check out https://openpaths.cc
 * to get your data
 *
 * Copyright (c) 2013 Fabian Moron Zirfas
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */

import processing.pdf.*; // this is just for export purpose
Boolean writepdf = false; // if true the sketch will create a PDF

/*
 * create a bounding box
 * upper left and lower right
 * check out http://dbsgeo.com/latlon/
 * for getting geolocations
 */
 float WORLD_westlon = 180; // the most left point
 float WORLD_northlat = 90; // the most top point
 float WORLD_southlat = -90; // the most bottom point
 float WORLD_eastlon = -180; // the most right point

/**
 * This is Berlin and Potsdam bounding box
 */
 float BPM_westlon = 12.9638671875; // the most left point
 float BPM_northlat = 52.70468296296834; // the most top point
 float BPM_southlat = 52.338695481504814; // the most bottom point
 float BPM_eastlon = 13.8153076171875; // the most right point

/**
 * This is Potsdam bounding box
 *
 */
 float PM_westlon = 12.935028076171875; // the most left point
 float PM_northlat = 52.43299020014247; // the most top point
 float PM_southlat = 52.338695481504814; // the most bottom point
 float PM_eastlon = 13.16436767578125; // the most right point

/**
 * This is campus FHP bounding box
 */
 float FHP_northlat = 52.41493264663135; // the most top point
 float FHP_westlon = 13.045835494995117; // the most left point
 float FHP_southlat = 52.40954011714691; // the most bottom point
 float FHP_eastlon = 13.054676055908203; // the most right point

ArrayList <Location> locs; // create a list that holds our locations

/**
 * The setup everything happens in here
 * dont need a draw for this one
 */
void setup(){

  locs = new ArrayList<Location>(); // initiate the ArrayList
    /**
   * IMPORTANT make the sketch size 2:1
   * this is equirectangular
   * see --> http://en.wikipedia.org/wiki/Equirectangular_projection
   */
  size(600, 300);
  background(255); // white bg


  String filename = "openpaths-simple.json"; // the file name

  String lines[] = loadStrings(filename); // load the file from the data folder

  /**
   * This is pretty dirty coding but it works.
   *
   * processingjs allows to mix Processing language with JavaScript
   * so we use the Processing join(Array , delimiter) method
   * and eval() the resulting String with JS
   *
   * Actually bad practice. :P
   */
  var data = eval(join(lines," "));

  /**
   * This is also mixed Processing and JS
   * data is an JS Object of Objects
   * but we loop Processing style
   *Hint: Objects should be looped like that
   * for(var key in object){
   *   if(obj.hasOwnProprty(key)){
   *     // do something
   *     }
   *   }
   *
   *
   * but still. It works. ;)
   */
  for(int j = 0; j < data.length;j++){
    var loc = data[j];
    locs.add(
      new Location(
        parseFloat(loc.lat),
        parseFloat(loc.lon)
     )
   );
}

  if(writepdf == true){
    // this is for output
    beginRecord(PDF, "openpaths_track_01.pdf");
  }

  noFill();
  beginShape();// begin to draw
  // loop the ArrayList of Locations
  for(int l = 0; l < locs.size();l++){
    Location loc = locs.get(l);// isolate a location

    /**
     * now get the locations into our bounding box
     */
    float x = width * ((BPM_westlon - loc.lon) / (BPM_westlon - BPM_eastlon));
    float y = ( height * ((BPM_northlat - loc.lat)/(BPM_northlat - BPM_southlat)));

    vertex(x, y); // draw the vertex

  }
  endShape();// end the sape is done
  if(writepdf == true){
  endRecord();
  exit();// and end the sketch
  }
}

void draw(){
// nothing do see here. move along
}

/**
 * This is the location class
 * it is just here for better handling of the locations
 *
 */
class Location {
float lat,  lon,  alt;
String date,  device,  os,  version;
  /**
   * Simple Constructor
   */
  Location(float lat_,float  lon_){
    lat =     lat_;
    lon =     lon_;
    alt =     0f;
    date =     "";
    device =     "";
    os =     "";
    version = "";
  }
  /**
   * Complex Constructor
   */
  Location(float lat_,float  lon_,float  alt_, String date_, String  device_,String  os_,String  version_){
    lat =     lat_;
    lon =     lon_;
    alt =     alt_;
    date =     date_;
    device =     device_;
    os =     os_;
    version = version_;
  }
}
