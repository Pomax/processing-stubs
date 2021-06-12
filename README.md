# Processing-stubs

Code that I constantly end up writing when using Processing.

## If you want to use everything

Just grab the [./bundle/bundle.pde](https://raw.githubusercontent.com/Pomax/processing-stubs/main/bundle/bundle.pde) file.

## If you want to cherry pick which functionality to use:

- `double.pde`: almost all math and drawing functions uplifted to accept `double` values instead of `float`.
- `vec.pde`: `Vec2` and `Vec3` classes, based on doubles (depends on `double.pde`).
- `vecutil.pde`: some math and drawing functions uplifted to allow `Vec2`/`Vec3` arguments (depends on `vec.pde`), including `lli` for finding line/line intersections.
- `rts.pde`: universal "right-click-drag to pan" and "mouse scroll to zoom" behaviour (depends on `vec.pde`) through a global called `RTS`.
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
