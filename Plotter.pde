import processing.svg.*;
PImage screen;

int defaultRadius = 2;
class Plotter {
  ArrayList<PlotterLine> lines = new ArrayList<PlotterLine>();
  PlotterLine newLine() {
    PlotterLine plotterLine = new PlotterLine();
    lines.add(plotterLine);
    return plotterLine;
  }
  
  
  void saveSvg() {
    saveSvg("vector");
  }
  void saveSvg(String name) {
    PGraphics svg = createGraphics(1920, 1080, SVG, "output/"+name+month()+day()+hour()+minute()+".svg");
    svg.beginDraw();
    for (PlotterLine line:lines) {
      for (ArrayList<PVector> ls : line.points) {
        
        if(ls.size() <= 1) continue;
        svg.beginShape();
        svg.noFill();
        svg.stroke(line.strokeColor);
        for(PVector p : ls) {
          svg.vertex(p.x*line.scale+line.shiftX, p.y*line.scale+line.shiftY);
          
        }
        svg.endShape();
      }
      
    }
    svg.endDraw();
  }
  
  
  void update() {
    screen = get(0,0,width*dD, height*dD);
  }
  
  void addLine(PlotterLine line) {
    lines.add(line);
  }
  void addLine(PlotterLine line, float x, float y) {
    lines.add(line);
  }
  
}


class PlotterLine {
  color strokeColor = #000000;
  float random = 0;
  int dashed = 0;
  ArrayList<Integer> colorsToCheck2 = new ArrayList<Integer>();
  int checkRadius = defaultRadius;
  Boolean penDown = true;
  Boolean lastPenDown = true;
  ArrayList<ArrayList<PVector>> points = new ArrayList<ArrayList<PVector>>();
  ArrayList<PVector> mainPoints = new ArrayList<PVector>();
  ArrayList<PVector> currentLine;
  
  float shiftX;
  float shiftY;
  float scale = 1;
  PlotterLine() {
    shiftX = width/2;
    shiftY = height/2;
    points.add(new ArrayList<PVector>());
    currentLine = points.get(0);
    
  }
  PlotterLine copy() {
    PlotterLine linecopy = new PlotterLine();
    
    ArrayList<ArrayList <PVector>> _points = new ArrayList();
    for(ArrayList<PVector> line : points) {
      _points.add(new ArrayList());
      for(PVector p:line) {
        _points.get(_points.size()-1).add(p.copy());
      }
    }
    
    linecopy.points = points;
    return linecopy;
  }
  void addColor(color _colorsToCheck) {
    colorsToCheck2.add(_colorsToCheck);
  }
  void setStrokeColor(color _color) {
    strokeColor = _color;
  }
  void setRadius(int _r) {
    checkRadius = _r;
  }
  float resolution = 1.0;
  void dashedLineTo(PVector toPos, int dash) {
    dashed = dash;
    lineTo(toPos);
  }
  
  void lineTo(float x, float y) {
    lineTo(new PVector(x,y));
  }
  
  
  void lineTo(PVector toPos) {
    if(mainPoints.size() > 0) {
      PVector lastOne = mainPoints.get(mainPoints.size()-1).copy();
      PVector direction = new PVector(toPos.x-lastOne.x, toPos.y-lastOne.y);//toPos.copy().sub(lastOne);
      
      PVector from = lastOne.copy();
      
      for(int i = 0; i<lastOne.dist(toPos)/resolution; i++) {
        float scale2 = map(i, 0, lastOne.dist(toPos)/resolution, 0, 1);
        PVector to = lastOne.copy().add(direction.copy().mult(scale2));
        
        penDown = true;
        
        checkColor(from.x, from.y);
        checkColor(to.x, to.y);
        dash(i);
        
        if(penDown) {
          line(from.x,from.y, to.x,to.y);
          if(scale2!=1) currentLine.add(to);
        }
        
        if(lastPenDown != penDown && !penDown) {
          points.add(new ArrayList<PVector>());
          currentLine = points.get(points.size()-1);
        }
        lastPenDown = penDown;
        
        from = to;
      }
    }
    if(penDown) {
      currentLine.add(toPos);
    }
    mainPoints.add(toPos);
  }
  void moveTo(float x, float y){
    moveTo(new PVector(x,y));
  }
  void moveTo(PVector pos){
    
    if( points.get(points.size()-1).size() != 0){
      points.add(new ArrayList<PVector>());
    }
    currentLine = points.get(points.size()-1);
    mainPoints.add(pos);
  }
  
  void dash(int index) {
    if(dashed == 0) return;
    if(index % dashed*2 < dashed) {
      penDown = false;
    }
    
  }
  
  void checkColor(float x, float y) {
    if(colorsToCheck2.size() == 0) {
      penDown = true;
    } else {
      PImage asd = screen.get(int((x*scale+shiftX)*dD-checkRadius), int((y*scale+shiftY)*dD-checkRadius), int(checkRadius*2), int(checkRadius*2));
      
      
      for(color pix : asd.pixels) {
        for(color c : colorsToCheck2) {
          float dist = dist(red(c),blue(c),green(c), red(pix),blue(pix),green(pix));
          if(dist < 10) {
            penDown = false;
          } else {
          }
        }
      }
    }
  }
  
  void push(float x, float y) {
    shiftX += x;
    shiftY += y;
    //for (ArrayList<PVector> line : points ) {
    //  if(line.size() == 0) continue;
    //  for(PVector p : line) {
    //    p.x += x;
    //    p.y += y;
    //  }
    //}
  }
  void scale(float _scale) {
    scale = _scale;
  }
  
  void drawOutline() {
    for (ArrayList<PVector> line : points ) {
      if(line.size() == 0) continue;
      PVector lastPoint = line.get(0);
      for(PVector p : line) {
        line(lastPoint.x*scale+shiftX, lastPoint.y*scale+shiftY, p.x*scale+shiftX, p.y*scale+shiftY);
        lastPoint = p;
        
      }
    }
  }
  void drawFill() {
    beginShape();
    for (PVector p : mainPoints ) {
      vertex(p.x*scale+shiftX, p.y*scale+shiftX);
      
    }
    endShape(CLOSE);
  }  
}
