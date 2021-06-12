# Processing-stubs

Code that I constantly end up writing when using Processing.

## If you want to use everything

Just grab the [./bundle/bundle.pde](https://raw.githubusercontent.com/Pomax/processing-stubs/main/bundle/bundle.pde) file.

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

The projector code supports two different kinds of projections: [cabinet projection]() and [vaninshing point perspective]().

## Cabinet projection

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

  stroke(0);
  curve.draw();
}
```

Yields:

![image](https://user-images.githubusercontent.com/177243/121784273-ed67b980-cb67-11eb-8615-46e894d81ad3.png)


## Vanishing point perspective

