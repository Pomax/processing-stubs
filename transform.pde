class RTS {
  Vec2 cursor;

  Vec2 mark; // where does a click-drag start?
  Vec2 offset; // what is the current click-drag offset?
  Vec2 gOffset; // what is the current global offset?
  Vec2 translation; // what is the resulting screen translation?
  
  double zoom, scale;
  Vec2 zoomPoint; // what was the cursor's world coordinate when we started scaling?
  Vec2 zoomDiff; // what is the difference between that, and the current cursor world coordinate?
  
  public RTS() {
    zoom = 0;
    scale = 1;
    mark = new Vec2(0,0);
    offset = new Vec2(0,0);
    gOffset = new Vec2(0,0);
    translation = new Vec2(0,0);
    cursor = new Vec2(0,0);
    zoomDiff = new Vec2(0,0);
  }

  void apply() {
    scale(scale);   
    translate(translation.plus(zoomDiff));
  }
  
  Vec2 getWorldCursor() {
    return world(cursor);
  }

  Vec2 world(double screenX, double screenY) {
    return world(new Vec2(screenX, screenY));
  }
 
  Vec2 world(Vec2 screen) {
    return screen.div(scale).sub(translation).sub(zoomDiff);
  }

  Vec2 screen(double worldX, double worldY) {
    return screen(new Vec2(worldX, worldY));
  }
 
  Vec2 screen(Vec2 world) {
    return world.plus(translation).scale(scale);
  }
  
  Vec2 updateCursor() {
    return cursor.set(mouseX, mouseY);
  }
  
  void mouseMoved() {
    zoomPoint = null;
  }

  void mousePressed() {
    zoomPoint = null;
    updateCursor();
    mark.set(cursor);
    gOffset.add(offset);
    offset.set(0,0);
  }
  
  void mouseDragged() {
    updateCursor();
    if (mouseButton == RIGHT) {
      offset = cursor.minus(mark);
      translation = gOffset.plus(offset);
    }
  }
  
  void mouseWheel(double steps) {
    if (zoomPoint == null) {
      zoomPoint = updateCursor().copy();
    }
    zoom += steps;
    Vec2 prev = world(zoomPoint);
    scale = pow(0.99, zoom);
    zoomDiff.add(world(zoomPoint).sub(prev));
  }
}

RTS RTS = new RTS();
