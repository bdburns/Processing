// all class variables needed to be able to be pulled out for other functions
//floats for charts plot area
float xMax, xMin, yMax, yMin;
PFont f; //creating a font
//floats for team 3 interpolation and stuff.
float life, nextlife, dlife, spend, nextspend, dspend, pop, nextPop, dpop;
//float time; (only if you fix the header thing)
float diameter, yPosition, xPosition;
int year=1;
int cycle=60;
String name;
PImage img;
int clickCount = 0; // so a button is activated only once per click



//creates an array of 6 country objects
Country[] country = new Country[7];

//creates 4 tables
Table ccTable, hsTable, leTable, pTable;


//all the void setup stuff
void setup() {
  frameRate(60);
    f = createFont("Arial", 16);

  //make the canvas size and color it
  size(1000, 500);
  background(255);

  //Loads in the four datas within the files folder
  ccTable = loadTable("country_color.csv", "header");
  hsTable = loadTable("health_spending.csv", "header");
  leTable = loadTable("life_expectancy.csv", "header");
  pTable = loadTable("population.csv", "header");

  img = loadImage("rewind-play-pause-audio-buttons-hi.png");

  //creates a country object that has a name and color, based on the table.
  for (int i = 0; i < country.length; i++) {
  country[i] = new Country(ccTable.getString(i, 0), ccTable.getString(i, 1));
  }
}

void chartNumbers(){
  textAlign(RIGHT);
  text("85", xMax+(xMin*.25), yMin+20);
  text("0", xMin-(xMin*.05), yMin+20);
  text("9000", xMin-(xMin*.05), yMax+10);
  
  
  
}
void chartLabels() {
  fill(240);
  stroke(240, 50);
   // set the corners of the axis
  xMin = (width*.15);
  xMax = (width*.95);
  yMin = (height*.85);
  yMax = (height*.15);

  // label the chart
  // chart title
  textSize(width*.03);
   textAlign(LEFT);
  String chartTitle = "Health Cost vs. Life Expectancy";
  float cWidth = textWidth(chartTitle);
  text(chartTitle, (width*.45 - cWidth/2), (height*.07));

// axis titles
  textSize(width*.025);

  // X Axis, Life Expectancy in years 0-85
  text("Life Expectency (Years)", (xMin), (height*.96));

  // Y Axis, Health Spending in dollars 0-9000
  pushMatrix();
  translate(width/16, yMin);
  rotate(PI/-2.0);
  text("Health Spending (US Dollar)", 0, 0);
  popMatrix();
}

//Create X AXIS Grid
void draw_xAxis() {
  fill(240);
  stroke(240);
  strokeWeight(2);
  // define the plot area
  // set the corners of the axis
  xMin = (width*.15);
  xMax = (width*.95);
  yMin = (height*.85);
  yMax = (height*.15);
  
  //Create box around grid area
  line(xMax, yMin, xMin, yMin);
  line(xMax, yMax, xMin, yMax);
  line(xMax, yMin, xMax, yMax);
 
 stroke(240,50);
 strokeWeight(1);
 float delta_x = ((xMin+xMax)/12);
  for (float x_span = xMin; x_span < xMax; x_span = x_span+delta_x) {
  line(x_span, yMax, x_span, yMin);
  }  

}
//Create Y AXIS Grid
void draw_yAxis() {
  fill(240);
  stroke(240);
  strokeWeight(2);
  // define the plot area
  // set the corners of the axis
  xMin = (width*.15);
  xMax = (width*.95);
  yMin = (height*.85);
  yMax = (height*.15);
  
 line(xMin, yMin, xMin, yMax);
 stroke(240,50);
  strokeWeight(1);
  float delta_y = (yMin-yMax)/9;
  for (float y_span = yMax; y_span < yMin; y_span = y_span+delta_y) {
  line((xMin), y_span, xMax, y_span); 
  fill(255, 50);
  }

}

void yearCounter(){
  
}

void draw() {
  background(0);
  draw_xAxis();
  draw_yAxis();
  chartLabels();
  chartNumbers();
  yearCounter();
  //time=leTable.getFloat(0, year); can't pull header
  textFont(f,64);
  fill(255,100);
  textAlign(CENTER);
  //text(time,width/2-20/2, height/2); need header for year
  text(year+2005,(xMin+xMax)/2, (yMax+yMin)/2);
   textFont(f,14);
  image(img, width - 210, height - 50, 200, 40);
  //Framerate controls time, created a counter to count 60 frames
  int counter=frameCount%cycle+1;
  //puts the bubbles where they belong, realtime draw
  for (int i=0; i<country.length; i++) {
  life=leTable.getFloat(i, year);//life
  spend=hsTable.getFloat(i, year);//spend

  if (year<5) {
    nextlife=leTable.getFloat(i, year+1);//nextlife

    nextspend=hsTable.getFloat(i, year+1);//nextspend
  }

  pop=pTable.getFloat(i, year);
  nextPop=pTable.getFloat(i, year);


  dlife=(nextlife-life)/cycle;
  dspend=(nextspend-spend)/cycle;
  dpop=(nextPop-pop)/cycle;
  if (year<5) {
    country[i].setXLifeExpectancy(life+dlife*counter);
    country[i].setDiameterPopulation(pop+dpop*counter);
    country[i].setYSpending(spend+dspend*counter);
  } else {
    country[i].setXLifeExpectancy(life);
    country[i].setDiameterPopulation(pop);
    country[i].setYSpending(spend);
  }

  //println(life, nextlife, dlife, counter);

  country[i].display();
  country[i].showLabel();
  }
  if (counter==cycle) {
  year++;
  }
  if (year>5) {
  year=1;
  }
  //text(year, 500, 500);
}

void mousePressed() {
  if ((mouseX >= 790 && mouseX <= 856) && (mouseY > 450 && mouseY <= 490) ) {
  year = 1;
  loop();
  }
  if ((mouseX >= 857 && mouseX <= 922) && (mouseY > 450 && mouseY <= 490)) {
  loop();
  }
  if ((mouseX >= 923 && mouseX <= 988) && (mouseY > 450 && mouseY <= 490)) {
  noLoop();
  }
}



//Team 2 set class
class Country
{
  String _name;
  color _color;
  float _xPosition;
  float _yPosition;
  float _diameter;

  Country(String name, String c)
  {
  _name = name;

  if (c.equals("red")) {
    _color = color(255, 0, 0, 127);
  }

  if (c.equals("orange")) {
    _color = color(255, 140, 0, 127);
  }

  if (c.equals("yellow")) {
    _color = color(255, 255, 102, 127);
  }

  if (c.equals("green")) {
    _color = color(0, 255, 0, 127);
  }

  if (c.equals("blue")) {
    _color = color(0, 0, 255, 127);
  }
  if (c.equals("purple")) {
    _color = color(153, 50, 204, 127);
  }
  }

  void setDiameterPopulation(float pop)
  {
  _diameter = map(pop, 0, 1400000000, 10, 75);
  }

  void setXLifeExpectancy(float life)
  {
  _xPosition = map(life, 0, 100, (.15*width), (.85*width));
  }

  void setYSpending(float spend)
  {
  _yPosition = map(spend, 0, 9000, (yMin-(10)), (yMax));
  }

  void display()
  {
  fill(_color);
  ellipse(_xPosition, _yPosition, _diameter, _diameter);
  }

  String getCountryName()
  {
  return _name;
  }

  void showLabel()
  {

  //display label if mouse hovers on country bubble
  if ((abs(mouseX - _xPosition))<(abs(_diameter/2)) && (abs(mouseY - _yPosition))<(abs(_diameter/2)))  
  {
    fill(255);
    textAlign(LEFT);
    text(_name, _xPosition+_diameter/2, _yPosition-20);
    text("Pop: ", _xPosition+_diameter/2, _yPosition);
    text(pop, _xPosition+(_diameter/2+30), _yPosition);
    text("Yrs: ", _xPosition+_diameter/2, _yPosition+20);
    text(life, _xPosition+(_diameter/2+30), _yPosition+20);
    text("USD: ", _xPosition+_diameter/2, _yPosition+40);
    text(spend, _xPosition+(_diameter/2+30), _yPosition+40);
  }
  }
}

//end