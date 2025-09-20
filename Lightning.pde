int startX, startY;
int endX, endY;
PGraphics crackLayer;
PGraphics rgbLayer;

int screenLeft = 120;
int screenTop  = 80;
int screenW    = 760;
int screenH    = 480;

boolean drawCrackNow = false; 
int clickCount = 0;
boolean glitchesStopped = false;

void setup() {
  size(1000, 700);
  strokeWeight(2);
  background(180);

  crackLayer = createGraphics(width, height);
  rgbLayer   = createGraphics(width, height);

  drawMonitor();
}

void draw() {
  drawMonitor();
  image(rgbLayer, 0, 0);
  image(crackLayer, 0, 0);

  if (drawCrackNow) {
    crackLayer.beginDraw();
    crackLayer.stroke(255);
    crackLayer.strokeWeight(2);

    int safety = 0;
    while (endX < screenW && safety < 20000) {
      endX = startX + (int)(Math.random() * 10);          
      endY = startY + ((int)(Math.random() * 19) - 9);    
      endY = constrain(endY, 0, screenH);

      crackLayer.line(screenLeft + startX, screenTop + startY,
                      screenLeft + endX, screenTop + endY);

      startX = endX;
      startY = endY;
      safety++;
    }
    crackLayer.endDraw();
    drawCrackNow = false;
  }
}

void mousePressed() {
  if (mouseX >= screenLeft && mouseX <= screenLeft + screenW &&
      mouseY >= screenTop  && mouseY <= screenTop  + screenH) {

    startX = mouseX - screenLeft;
    startY = mouseY - screenTop;
    endX = startX;
    endY = startY;

    drawCrackNow = true;
    clickCount++;

    if (!glitchesStopped) {
      if (clickCount < 8) {
        addRGBGlitches(4 + clickCount * 2);
      } else {
        // Fix for web: fully overwrite the RGB layer instead of using clear()
        rgbLayer.beginDraw();
        rgbLayer.background(0, 0); // fully transparent background
        rgbLayer.endDraw();
        glitchesStopped = true;
      }
    }
  }
}

void addRGBGlitches(int howMany) {
  rgbLayer.beginDraw();
  for (int i = 0; i < howMany; i++) {
    int x = screenLeft + (int)(Math.random() * screenW);
    int w = 2 + (int)(Math.random() * 8);
    int cr = (int)(Math.random() * 256);
    int cg = (int)(Math.random() * 256);
    int cb = (int)(Math.random() * 256);

    rgbLayer.noStroke();
    rgbLayer.fill(cr, cg, cb, 200);
    rgbLayer.rect(x, screenTop, w, screenH);

    if (Math.random() < 0.3) {
      int hy = screenTop + (int)(Math.random() * screenH);
      int hh = 4 + (int)(Math.random() * 40);
      rgbLayer.fill((int)(Math.random() * 256),
                    (int)(Math.random() * 256),
                    (int)(Math.random() * 256), 180);
      rgbLayer.rect(screenLeft, hy, screenW, hh);
    }
  }
  rgbLayer.endDraw();
}

void drawMonitor() {
  background(180);
  noStroke();

  fill(30);
  rect(screenLeft - 20, screenTop - 20, screenW + 40, screenH + 120, 8);

  fill(10);
  rect(screenLeft, screenTop, screenW, screenH);

  fill(60);
  rect(screenLeft + screenW/2 - 60, screenTop + screenH + 20, 120, 20, 4);
  rect(screenLeft + screenW/2 - 30, screenTop + screenH + 40, 60, 12, 4);

  noFill();
  stroke(80);
  strokeWeight(1);
  rect(screenLeft, screenTop, screenW, screenH);
}
