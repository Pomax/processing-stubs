# Processing-stubs

This repo houses code that I, for the last however-many years, just constantly end up writing, over and over again, when firing up [Processing](https://processing.org/) for some quick and dirty graphics programming. Making that activity decidedly not-so-quick, so hopefully having everything here fixes that.

## If you want to use everything

Create a new tab in the PDE and copy-paste the code from [./bundle/bundle.pde](https://raw.githubusercontent.com/Pomax/processing-stubs/main/bundle/bundle.pde) into it.

## If you want to cherry pick which functionality to use:

- `double.pde`: almost all math and drawing functions uplifted to accept `double` values instead of `float`.
- `vec.pde`: `Vec2` and `Vec3` classes, based on doubles (depends on `double.pde`).
- `vecutil.pde`: some math and drawing functions uplifted to allow `Vec2`/`Vec3` arguments (depends on `vec.pde`), including `lli` for finding line/line intersections.
- `rts.pde`: universal "right-click-drag to pan" and "mouse scroll to zoom" behaviour (depends on `vec.pde`) through a global called `RTS`. [See below](#using-the-rts-class) for details.
- `projector.pde`: a 3D-to-2D projector class supporting cabinet projection as well as two/three-point perspectives. [See below](#using-a-projector) for details.
- `bezier.pde`: a `Bezier` class ([obviously](https://pomax.github.io/bezierinfo)).

# Using the RTS class

Update your code to:

```java
void draw() {
  RTS.apply();
  // ...and then your code here... 
}

void mouseMoved() {
  RTS.mouseMoved();
  // ...and then your code here...  
}

void mousePressed() {
  RTS.mousePressed();
  // ...and then your code here...  
  redraw();  
}

void mouseDragged() {
  RTS.mouseDragged();  
  // ...and then your code here...  
  redraw();
}

void mouseWheel(MouseEvent event) {
  RTS.mouseWheel(event.getCount());
  // ...and then your code here...  
  redraw();
}
```

Note that redraw() is 100% mandatory for three of the four event handling functions. The reason it's not mandatory for mouse move is that usually, just moving the mouse is not enough to warrant a redraw. Of course, if your own code does something to warrant a redraw (e.g. highlighting something if the cursor is over it) then that would be a good reason to have a redraw().

If you want your sketch to be resizable, you can use the RTS class for this, too:

```java

void setup() {
  RTS.enableResize();
  // ...and then your code here...
}
```
This allows your sketch to be resized via normal window manipulation, as well as through code. For example:

```java
void keyPressed() {
  if (key == '+') {
    RTS.resize(2*width, 2*height);
  }
}
```

# Using a Projector

Sometimes you just want simple 3D emulation, rather than working in 3D with cameras and lights and geometries. For those occasions, the `Projector` class supports two different kinds of projections: [cabinet projection](https://en.wikipedia.org/wiki/Oblique_projection) and [vaninshing point perspective](https://en.wikipedia.org/wiki/Vanishing_point).

## Cabinet projection

A useful projection that completely ignores that fact that in real life the same distance interval close up looks bigger than the same distance interval far away.

```
Projector cabinet;
Vec3[] coords;
Bezier curve, curveXY, curveXZ, curveYZ;

void setup() {
  RTS.enableResize();
  size(500, 500);

  cabinet = Projector.createCabinet();

  coords = new Vec3[]{
    new Vec3(0.35 * width, 0.25 * height,   0),
    new Vec3(0.15 * width, 0.75 * height, 100),
    new Vec3(0.85 * width, 0.75 * height, 200),
    new Vec3(0.65 * width, 0.25 * height, 300)
  };
  
  setupProjector(cabinet);
}

void setupProjector(Projector p) { 
  curve = new Bezier(
    p.project(coords[0]),
    p.project(coords[1]),
    p.project(coords[2]),
    p.project(coords[3])
  );
  
  // projections
  curveXY = new Bezier(
    p.projectXY(coords[0]),
    p.projectXY(coords[1]),
    p.projectXY(coords[2]),
    p.projectXY(coords[3])
  );

  curveXZ = new Bezier(
    p.projectXZ(coords[0]),
    p.projectXZ(coords[1]),
    p.projectXZ(coords[2]),
    p.projectXZ(coords[3])
  );

  curveYZ = new Bezier(
    p.projectYZ(coords[0]),
    p.projectYZ(coords[1]),
    p.projectYZ(coords[2]),
    p.projectYZ(coords[3])
  );
}

void draw() {
  background(255);
  noFill();
  stroke(0);
  RTS.apply();

  stroke(50);
  line(cabinet.project(0,0,0),cabinet.project(1000,0,0)); 
  line(cabinet.project(0,0,0),cabinet.project(0,1000,0)); 
  line(cabinet.project(0,0,0),cabinet.project(0,0,1000));

  stroke(15);
  curveXY.draw(false);
  curveXZ.draw(false);
  curveYZ.draw(false);
  
  stroke(0);
  curve.draw();
}
```

Yields:

![image](https://user-images.githubusercontent.com/177243/121784273-ed67b980-cb67-11eb-8615-46e894d81ad3.png)


## Vanishing point perspective

This is a perspective projection, supporting both [two point perspective](https://en.wikipedia.org/wiki/Perspective_(graphical)#Two-point_perspective) and [three point perspective](https://en.wikipedia.org/wiki/Perspective_(graphical)#Three-point_perspective).

### Two point perspective

This requires calling `Projector.createPerspective(origin, yScale, X, Z)`, where `origin` is the 2D screen point that acts as (0,0,0), `yScale` tells the projector how high the horizon is with respect to the origin, and `X` and `Z` are our right and left vanishing points in 2D screen coordinates, respectively.

```
Projector perspective;
Vec3[] coords;
Bezier curve, curveXY, curveXZ, curveYZ;
double yScale = 5;

void setup() {
  RTS.enableResize();
  size(500, 500);

  perspective = Projector.createPerspective(
    center().plus(0, w()/4),
    yScale,
    new Vec2(0, h()/2),
    new Vec2(w(), h()/2)
  );

  coords = new Vec3[]{
    new Vec3(2, 0, 2),
    new Vec3(2, 2, 1),
    new Vec3(1, 4, 2),
    new Vec3(2, 6, 2),
  };

  setupProjector(perspective);
}

void setupProjector(Projector p) { 
  curve = new Bezier(
    p.project(coords[0]),
    p.project(coords[1]),
    p.project(coords[2]),
    p.project(coords[3])
  );

  curveXY = new Bezier(
    p.projectXY(coords[0]),
    p.projectXY(coords[1]),
    p.projectXY(coords[2]),
    p.projectXY(coords[3])
  );

  curveXZ = new Bezier(
    p.projectXZ(coords[0]),
    p.projectXZ(coords[1]),
    p.projectXZ(coords[2]),
    p.projectXZ(coords[3])
  );

  curveYZ = new Bezier(
    p.projectYZ(coords[0]),
    p.projectYZ(coords[1]),
    p.projectYZ(coords[2]),
    p.projectYZ(coords[3])
  );
}

void draw() {
  background(255);
  noFill();
  stroke(0);
  RTS.apply();

  Vec2[] points = perspective.getPoints();
  Vec2 X = points[0], Z = points[2], O = points[3];

  stroke(200);
  for(int i=0; i<10; i++) {
    Vec2 px = perspective.project(i,0,0);
    Vec2 pz = perspective.project(0,0,i);
    line(X,pz); line(Z,px);
  }

  stroke(50);
  line(O,X); line(O,Z);

  stroke(150);
  curveXY.draw(false); curveXZ.draw(false); curveYZ.draw(false);
  
  stroke(0);
  curve.draw();
}
```

Yields:

![image](https://user-images.githubusercontent.com/177243/121784511-16d51500-cb69-11eb-9ed3-610d4236fb05.png)

### Three point perspective

This requires calling `Projector.createPerspective(origin, yScale, X, Y, Z)`, where `origin` is the 2D screen point that acts as (0,0,0), `yScale` tells the projector how high the horizon is with respect to the origin, `X` and `Z` are our right and left vanishing points in 2D screen coordiantes, respectively, and `Y` is our elevation vanishing point as 2D screen coordinate.

```
// ...same globals as above...

void setup() {
  RTS.enableResize();
  size(500, 500);

  perspective = Projector.createPerspective(
    center().plus(0, w()/4), 
    yScale, 
    new Vec2(0, h()/2), 
    new Vec2(w()/2, 10), 
    new Vec2(w(), h()/2)
  );
  
  // ...rest of setup() as above...
}

void setupProjector(Projector p) { 
  // ...same code as above...
}

void draw() {
  background(255);
  noFill();
  stroke(0);
  RTS.apply();

  Vec2[] points = perspective.getPoints();
  Vec2 X = points[0], Y = points[1], Z = points[2], O = points[3];

  stroke(200);
  for (int i=0; i<10; i++) {
    Vec2 px = perspective.project(i, 0, 0);
    Vec2 pz = perspective.project(0, 0, i);
    Vec2 py = perspective.project(0, i, 0);
    line(X, pz); line(X, py);
    line(Y, pz); line(Y, px);
    line(Z, px); line(Z, py);
  }

  stroke(50);
  line(O, X); line(O, Y); line(O, Z);

  stroke(100);
  curveXY.draw(false); curveXZ.draw(false); curveYZ.draw(false);

  stroke(0);
  curve.draw();
}
```

Yields:

![image](https://user-images.githubusercontent.com/177243/121784688-31f45480-cb6a-11eb-9696-77ad12390817.png)
