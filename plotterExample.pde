Plotter plt = new Plotter();
PlotterLine line;
int dD = 2;
void setup() {
  println(dD,displayDensity());
  pixelDensity(dD);
  size(1200,800, P2D);
  
  translate(width/2, height/2);
  background(255);
  fill(#efefef);
  stroke(#FF0000);
  
  int shiftY = -100;
  rect(0,0+shiftY,20,20);
  rect(62, -10+shiftY,2,20);
  rect(74,-10+shiftY,2,20);
  rect(86,-10+shiftY,2,20);
  rect(98,-10+shiftY,2,20);
  
  rect(-10, 62+shiftY,20,2);
  rect(-10, 74+shiftY,20,2);
  rect(-10, 86+shiftY,20,2);
  rect(-10, 98+shiftY,20,2);
  noFill();
  stroke(0);
  plt.update();
  line = plt.newLine();
  line.addColor(#efefef);
  line.addColor(#FF0000);
  
  strokeWeight(2);
  stroke(#00ff00);
  line.lineTo(new PVector(0,0+shiftY));
  line.lineTo(new PVector(100,0+shiftY));
  line.lineTo(new PVector(100,100+shiftY));
  line.lineTo(new PVector(0,100+shiftY));
  line.lineTo(new PVector(0,0+shiftY));
  
  
  
  PlotterLine line2 = plt.newLine();
  line2.addColor(#efefef);
  line2.addColor(#FF0000);
  
  strokeWeight(2);
  stroke(#00ff00);
  line2.moveTo(new PVector(-110,-10));
  line2.moveTo(new PVector(-110,-10));
  line2.moveTo(new PVector(-120,-20));
  line2.moveTo(new PVector(-110,-10));
  line2.lineTo(new PVector(-200,0));
  line2.moveTo(new PVector(-200,100));
  line2.lineTo(new PVector(-190,50));
  line2.lineTo(new PVector(-180,100));
  line2.moveTo(new PVector(-120,100));
  line2.lineTo(new PVector(-100,100));
  
  line2.drawOutline();
  //image(screen, 0,0,500,300);
}

void draw() {
  plt.update();
  line.drawOutline();
  
}
