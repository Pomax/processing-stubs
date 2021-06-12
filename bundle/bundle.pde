class Bezier {
  int dims = 0; 
  Vec2[] points;
  Bezier derivative;

  int[][] binomial = {
    {     1}, 
    {    1, 1}, 
    {   1, 2, 1}, 
    {  1, 3, 3, 1}, 
    { 1, 4, 6, 4, 1}
  };

  public Bezier(Vec2... points) {
    int n = points.length;
    this.points = new Vec2[n];
    arrayCopy(points, 0, this.points, 0, n);
    if (n>=2) {
      Vec2 d[] = new Vec2[n-1];
      for (int i=0; i<n-1; i++) {
        d[i] = points[i+1].minus(points[i]).scale(n-1);
      }
      derivative = new Bezier(d);
    }
    dims = 2;
  }

  void draw() {
    draw(true);
  }

  void draw(boolean full) {
    beginShape();
    for (double t=0; t<1; t+=0.01) {
      vertex(get(t));
    }
    vertex(get(1.0));
    endShape();
    if (full) {
      pushStyle();
      stroke(0, 100);
      circle(points[0], 3);
      for (int i=0, e=points.length; i<e-1; i++) {
        line(points[i], points[i+1]);
        circle(points[i+1], 3);
      }
      popStyle();
    }
  }

  Vec2 get(double t) {
    int n = points.length - 1;
    double x = 0;
    double y = 0;
    for (int k=0; k<=n; k++) {
      Vec2 p = points[k];
      int b = binomial[n][k];
      double w = pow(t, k) * pow(1-t, n-k);
      x += p.x * w * b;
      y += p.y * w * b;
    }
    return new Vec2(x, y);
  }

  Vec2 getPointNear(Vec2 p) {
    return getPointNear(p, 10);
  }

  Vec2 getPointNear(Vec2 m, double r) {
    for (Vec2 p : points) {
      if (p.minus(m).mag() <= r) return p;
    }
    return null;
  }

  Vec2 tangent(double t) {
    return velocity(t);
  }
  
  Vec2 velocity(double t) {
    if (derivative == null) return null;
    return derivative.get(t);
  }

  Vec2 accelleration(double t) {
    if (derivative == null) return null;
    if (derivative.derivative == null) return null;
    return derivative.derivative.get(t);
  }

  Vec2 normal(double t) {
    Vec2 tangent = velocity(t);
    double m = tangent.mag();
    return new Vec2(tangent.y/m, -tangent.x/m);
  }


  String toString() {
    int e = points.length;
    String[] r = new String[e];
    for (int i=0; i<e; i++) r[i] = points[i].toString();
    return "[" + join(r, ", ") + "]";
  }
}
// widht/height are ints, and that always messes things up for me

double w() { 
  return (double) width;
}

double h() { 
  return (double) height;
}

// Maths functions, which mostly passes things straight over to the Math object

double floor(double v) { 
  return Math.floor(v);
}

double round(double v) { 
  return Math.round(v);
}

double ceil(double v) { 
  return Math.ceil(v);
}

double sin(double v) { 
  return Math.sin(v);
}

double cos(double v) { 
  return Math.cos(v);
}

double tan(double v) { 
  return Math.tan(v);
}

double asin(double v) { 
  return Math.asin(v);
}

double acos(double v) { 
  return Math.acos(v);
}

double atan(double v) { 
  return Math.atan(v);
}

double abs(double v) { 
  return Math.abs(v);
}

double sqrt(double v) { 
  return Math.sqrt(v);
}

double ln(double v) { 
  return Math.log(v);
}

double log(double v) { 
  return Math.log(v) / Math.log(10);
}

double log2(double v) { 
  return Math.log(v) / Math.log(2.);
}

double exp(double v) { 
  return Math.exp(v);
}

double pow(double v, double p) { 
  return Math.pow(v, p);
}

double atan2(double dy, double dx) { 
  return Math.atan2(dy, dx);
}

double lerp(double a, double b, double r) { 
  return r==0? a : r==1 ? b : a*(1-r) + b*r;
}

double min(double a, double b) { 
  return Math.min(a, b);
}

double max(double a, double b) { 
  return Math.max(a, b);
}

double map(double v, double s1, double e1, double s2, double e2) {
  return s2 + (v-s1) * (e2-s2)/(e1-s1);
}


// Draw function wrappers

void stroke(double v) {
  stroke((int)v);
}

void stroke(double v, double a) {
  stroke((int)v, (int)a);
}

void line(double x1, double y1, double x2, double y2) { 
  line((float)x1, (float)y1, (float)x2, (float)y2);
}

void circle(double x, double y) { 
  circle((float)x, (float)y, 1);
}

void circle(double x, double y, double r) { 
  ellipse(x, y, r*2, r*2);
}

void ellipse(double x, double y, double w, double h) { 
  ellipse((float)x, (float)y, (float)w, (float)h);
}

void text(String str, Vec2 p) { 
  text(str, p.x, p.y);
}

void text(String str, double x, double y) { 
  text(str, (float)x, (float)y);
}

void quad(double x1, double y1, double x2, double y2, double x3, double y3, double x4, double y4) {
  quad((float)x1, (float)y1, (float)x2, (float)y2, (float)x3, (float)y3, (float)x4, (float)y4);
}

void vertex(double x, double y) { 
  vertex((float)x, (float)y);
}

// Transforms

void translate(double x, double y) { 
  translate((float)x, (float) y);
}

void rotate(double a) { 
  rotate((float)a);
}
void scale(double s) { 
  scale((float)s);
}
void scale(double xs, double sy) { 
  scale((float)xs, (float)sy);
}
class Projector {
  Vec3 XY = new Vec3(1, 1, 0);
  Vec3 XZ = new Vec3(1, 0, 1);
  Vec3 YZ = new Vec3(0, 1, 1);

  Projector createPerspective(Vec2 origin, double yScale, Vec2... vanishingPoints) {
    return new PerspectiveProjector(origin, yScale, vanishingPoints);
  }

  Projector createCabinet() {
    return new CabinetProjector();
  }
  
  Vec2[] getPoints() {
    throw new UnsupportedOperationException("getPoints() is not defined for Projector superclass");
  }

  Vec2 project(double worldX, double worldY, double worldZ) {
    return project(new Vec3(worldX, worldY, worldZ));
  }

  Vec2 project(Vec3 world) {
    throw new UnsupportedOperationException("project() is not defined for Projector superclass");   
  }

  Vec2 projectXY(double worldX, double worldY, double __) {
    return projectXY(new Vec3(worldX, worldY, 0));
  }

  Vec2 projectXY(Vec3 v) {
    return project(v.times(XY));
  }

  Vec2 projectXZ(double worldX, double __, double worldZ) {
    return projectXZ(new Vec3(worldX, 0, worldZ));
  }

  Vec2 projectXZ(Vec3 v) {
    return project(v.times(XZ));
  }

  Vec2 projectYZ(double __, double worldY, double worldZ) {
    return projectYZ(new Vec3(0, worldY, worldZ));
  }

  Vec2 projectYZ(Vec3 v) {
    return project(v.times(YZ));
  }

  private class CabinetProjector extends Projector {
    Vec2 offset;
    double phi;

    public CabinetProjector() {
      this(new Vec2(0, 0), -PI/6);
    }

    public CabinetProjector(Vec2 offset, double phi) {
      this.offset = offset;
      this.phi = phi;
    }

    Vec2[] getPoints() {
      throw new UnsupportedOperationException("getPoints() is not defined for CabinetProjector class");
    }

    Vec2 project(Vec3 world) {
      // what they rarely tell you: if you want Z to "go up",
      // X to "come out of the screen", and Y to be the "left/right",
      // we need to switch some coordinates around:
      double
        a = world.y, 
        b = -world.z, 
        c = -world.x / 2;

      return new Vec2(
        offset.x + a + c * Math.cos(phi), 
        offset.y + b + c * Math.sin(phi)
        );
    }
  }

  private class PerspectiveProjector extends Projector {
    double perspectiveFactor = 1.25, dyO, yFactor;
    boolean threePoint = false;
    public Vec2 O, HO, X, Y, Z;

    /**
     * Orientation:
     *
     *       y
     *      /|\
     *     / | \
     *    z--O--x
     *
     * Constructor argument ordering: Vec2[X,Z] or Vec2[X,Y,Z]
     */
    public PerspectiveProjector(Vec2 origin, double yScale, Vec2[] vanishingPoints) {
      O = origin;
      X = vanishingPoints[0];
      Z = vanishingPoints[1];

      if (vanishingPoints.length == 3) {
        threePoint = true;
        X = vanishingPoints[0];
        Y = vanishingPoints[1];
        Z = vanishingPoints[2];
      }

      HO = lli(O, O.plus(0, 10), Z, X);
      dyO = O.y - HO.y;
      yFactor = dyO / yScale;
    }
    
    Vec2[] getPoints() {
      return new Vec2[]{X,Y,Z,O,HO};
    }

    double stepToDistanceRatio(double step) {
      return 1. - 1. / (1 + perspectiveFactor * step);
    }

    Vec2 project(Vec3 v) {
      return project(v.x, v.y, v.z);
    }

    Vec2 project(double x, double y, double z) {
      if (threePoint) return get3(x, y, z);
      return get2(x, y, z);
    }

    Vec2 get3(double x, double y, double z) {
      // A simple, but absolutely necessary, shortcut:
      if (x==0 && y==0 && z==0) return O;

      // Then, get the XY/ZY plane coordinate components,
      Vec2 oX = O.to(X, stepToDistanceRatio(x));
      Vec2 oZ = O.to(Z, stepToDistanceRatio(z));

      // If there is no elevation, then the actual coordinate
      // is the line intersection from our components to our
      // vanishing points:
      if (y==0) return lli(X, oZ, Z, oX);

      // If there *is* an elevation, we'll need to get the Y
      // component as well, and then construct a few more
      // points basd on line intersections.
      Vec2 oY = O.to(Y, stepToDistanceRatio(y));
      Vec2 YZ = lli(Y, oZ, Z, oY);
      Vec2 XY = lli(Y, oX, X, oY);
      return lli(XY, Z, X, YZ);
    }

    Vec2 get2(double x, double y, double z) {
      if (x==0 && y==0 && z==0) return O;

      Vec2 oX = x == 0 ? O : O.to(X, stepToDistanceRatio(x));
      Vec2 oZ = z == 0 ? O : O.to(Z, stepToDistanceRatio(z));
      Vec2 ground = lli(X, oZ, Z, oX);
      if (y==0) return ground;

      boolean inZ = (ground.x < O.x);
      double rx = inZ ? (ground.x - Z.x) / (O.x - Z.x) : (X.x - ground.x) / (X.x - O.x);
      Vec2 onAxis = lli(inZ ? Z : X, O, ground, ground.plus(0, 10));
      double ry = (ground.y - HO.y) / (onAxis.y - HO.y);
      return ground.minus(0, rx * ry * y * yFactor);
    }
  }
}

Projector Projector = new Projector();
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
  
  void enableResize() {
    surface.setResizable(true);
  }
  
  void resize(double w, double h) {
    surface.setSize((int)w, (int)h);
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
    updateCursor();    
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
      offset = cursor.minus(mark).div(scale);
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
// like PVector, but doubles, and explicitly Vec2/Vec3

/**
 * ...docs go here...
 */
class Vec2 {
  double x, y;
  
  public Vec2(double x, double y) {
    set(x, y);
  }
  
  public Vec2(Vec2 v) {
    set(v);
  }
  
  Vec2 set(double x, double y) {
    this.x = x;
    this.y = y;
    return this;
  }
  
  Vec2 set(Vec2 v) {
    return set(v.x, v.y);
  }
  
  Vec2 copy() {
    return new Vec2(x, y);
  }
  
  // "add"/"sub" add and remove values in-place
  Vec2 add(double _x, double _y) {
    x += _x;
    y += _y;
    return this;
  }
  
  Vec2 add(Vec2 v) {
    add(v.x, v.y);
    return this;
  }
  
  // "plus" and "minus" generate a new vector
  Vec2 plus(double _x, double _y) {
    return new Vec2(x+_x, y+_y);
  }
  
  Vec2 plus(Vec2 v) {
    return plus(v.x, v.y);
  }
  
  Vec2 sub(double _x, double _y) {
    x -= _x;
    y -= _y;
    return this;
  } 
  
  Vec2 sub(Vec2 v) {
    sub(v.x, v.y);
    return this;
  }
  
  Vec2 minus(double _x, double _y) {
    return new Vec2(x-_x, y-_y);
  }
  
  Vec2 minus(Vec2 v) {
    return minus(v.x, v.y);
  }
  
  Vec2 times(Vec2 v) {
    return new Vec2(x*v.x, y*v.y);
  }
  
  // "scale" scales in-place
  Vec2 scale(double s) {
    x *= s;
    y *= s;
    return this;
  }
  
  // "mul"/"div" yield new vectors
  Vec2 mul(double s) {
    return new Vec2(x*s, y*s);
  }
  
  Vec2 div(double s) {
    return new Vec2(x/s, y/s);
  }
  
  // "flip" happens in-place
  Vec2 flip() {
    x = -x;
    y = -y;
    return this;
  }
  
  // "opposite" yields a new, flipped vector
  Vec2 opposite() {
    return new Vec2(-x, -y);
  }
  
  // "normalize" yields a new vector
  Vec2 normalize() {
    double m = this.mag();
    return new Vec2(x/m, y/m);
  }
  
  // "rotate" happens in-place
  Vec2 rotate(double angle) {
    return rotate(0, 0, angle);
  }
  
  Vec2 rotate(double ox, double oy, double angle) {
    double x = this.x - ox;
    double y = this.y - oy;    
    this.x = ox + x * cos(angle) - y * sin(angle);
    this.y = oy + x * sin(angle) + y * cos(angle);
    return this;
  }
  
  // "sweep" yields a new, rotated vector
  Vec2 sweep(double ox, double oy, double angle) {
    return new Vec2(this).rotate(ox, oy, angle);
  } 
  
  Vec2 to(double _x, double _y) {
    return new Vec2(_x-x, _y-y);
  }
  
  Vec2 to(Vec2 v) {
    return to(v.x, v.y);
  }
  
  Vec2 to(Vec2 v, double r) {
    return lerp(this, v, r);
  }
  
  double cross(Vec2 v) {
    return x*v.y - y*v.x;
  }
  
  double dot(Vec2 v) {
    return x*v.x + y*v.y;
  }
  
  double mag() {
    return sqrt(x*x + y*y);
  }

  String toString() {
    return x + "," + y;
  }
}


/**
 * ...docs go here...
 */
class Vec3 extends Vec2 {
  double z;
  
  public Vec3(double x, double y, double z) {
    super(x, y);
    this.z = z;
  }
  
  public Vec3(Vec2 v) {
    super(v);
    set(v);
    this.z = 0;
  }  
  
  public Vec3(Vec3 v) {
    super(v);
    set(v);
  }  
  
  Vec3 set(double x, double y, double z) {
    super.set(x, y);
    this.z = z;
    return this;
  }
  
  Vec3 set(Vec3 v) {
    return set(v.x, v.y, v.z);
  }  
  
  Vec3 copy() {
    return new Vec3(x, y, z);
  }
  
  Vec3 add(double x, double y, double _z) {
    super.add(x, y);
    z += _z;
    return this;
  }  
  
  Vec3 add(Vec3 v) {
    add(v.x, v.y, v.z);
    return this;
  }
  
  Vec3 plus(double _x, double _y, double _z) {
    return new Vec3(x+_x, y+_y, z+_z);
  } 
  
  Vec3 plus(Vec3 v) {
    return plus(v.x, v.y, v.z);
  }
  
  Vec3 sub(double x, double y, double _z) {
    super.sub(x, y);
    z -= z;
    return this;
  }  
  
  Vec3 sub(Vec3 v) {
    sub(v.x, v.y, v.z);
    return this;
  }
  
  Vec3 minus(double _x, double _y, double _z) {
    return new Vec3(x-_x, y-_y, z-_z);
  }
  
  Vec3 minus(Vec3 v) {
    return minus(v.x, v.y, v.z);
  }
  
  Vec3 times(Vec3 v) {
    return new Vec3(x*v.x, y*v.y, z*v.z);
  }
  
  Vec3 scale(double s) {
    super.scale(s);
    z *= s;
    return this;
  }
  
  Vec3 mul(double s) {
    return new Vec3(x*s, y*s, z*s);
  }
  
  Vec3 div(double s) {
    return new Vec3(x/s, y/s, z/s);
  }
  
  Vec3 flip() {
    super.flip();
    z = -z;
    return this;
  }
  
  Vec3 opposite() {
    return new Vec3(-x, -y, -z);
  } 
  
  Vec3 normalize() {
    double m = this.mag();
    return new Vec3(x/m, y/m, z/m);
  }
  
  Vec3 rotateX(double angle) {
    return rotateX(0, 0, angle);
  }
  
  Vec3 rotateX(double oy, double oz, double angle) {
    double y = this.y - oy;    
    double z = this.z - oz;
    this.y = oy + y * sin(angle) + z * cos(angle);
    this.z = oz + y * cos(angle) - z * sin(angle);
    return this;
  }
  
  Vec3 rotateY(double angle) {
    return rotateY(0, 0, angle);
  }
  
  Vec3 rotateY(double ox, double oz, double angle) {
    double x = this.x - ox;
    double z = this.z - oz;
    this.x = ox + (x * sin(angle) + z * cos(angle));
    this.z = oz + (x * cos(angle) - z * sin(angle));
    return this;
  }
  
  Vec3 rotateZ(double angle) {
    return rotateZ(0, 0, angle);
  }
  
  Vec3 rotateZ(double ox, double oy, double angle) {
    double x = this.x - ox;    
    double y = this.y - oy;
    this.x = ox + x * sin(angle) + y * cos(angle);
    this.y = oy + x * cos(angle) - y * sin(angle);
    return this;
  }
  
  Vec3 to(double _x, double _y, double _z) {
    return new Vec3(_x-x, _y-y, _z-z);
  }
  
  Vec3 to(Vec3 v) {
    return to(v.x, v.y, v.z);
  }
  
  Vec3 to(Vec3 v, double r) {
    return lerp(this, v, r);
  }
  
  double cross(Vec3 v) throws UnsupportedOperationException {
    throw new UnsupportedOperationException("Cross product is only defined in 2D");
  }
  
  double dot(Vec3 v) {
    return super.cross(v) + z*v.z;
  }
  
  double mag() {
    return sqrt(x*x + y*y + z*z);
  }  

  String toString() {
    return super.toString() + "," + z;
  }
}
// convenience vector representing the middle of the screen

Vec2 __center;

Vec2 center() {
  if (__center != null) return __center;
  __center = new Vec2(w()/2, h()/2);
  return __center;
}

double atan2(Vec2 d) { 
  return atan2(d.y, d.x);
}

void translate(Vec2 p) { 
  translate(p.x, p.y);
}

void line(Vec2 p1, Vec2 p2) { 
  line(p1.x, p1.y, p2.x, p2.y);
}

void circle(Vec2 p) { 
  circle(p.x, p.y);
}

void circle(Vec2 p, double r) { 
  circle(p.x, p.y, r);
}

void ellipse(Vec2 p, double w, double h) { 
  ellipse(p.x, p.y, w, h);
}

void quad(Vec2 p1, Vec2 p2, Vec2 p3, Vec2 p4) { 
  quad(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x, p4.y);
}

void vertex(Vec2 p) { 
  vertex(p.x, p.y);
}


Vec2 lerp(Vec2 v1, Vec2 v2, double r) {
  double mr = 1-r;
  return new Vec2(
    mr * v1.x + r * v2.x, 
    mr * v1.y + r * v2.y
    );
}

Vec3 lerp(Vec3 v1, Vec3 v2, double r) {
  if (r==0) return v1;
  if (r==1) return v2;
  double mr = 1-r;
  return new Vec3(
    mr * v1.x + r * v2.x, 
    mr * v1.y + r * v2.y, 
    mr * v1.z + r * v2.z    
    );
}

Vec2 lli(Vec2 l1p1, Vec2 l1p2, Vec2 l2p1, Vec2 l2p2) {
  return lli(l1p1.x, l1p1.y, l1p2.x, l1p2.y, l2p1.x, l2p1.y, l2p2.x, l2p2.y);
}

Vec2 lli(double x1, double y1, double x2, double y2, double x3, double y3, double x4, double y4) {
  double nx = (x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4);
  double ny = (x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4);
  double  d = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
  if (d == 0) return null;
  return new Vec2(nx/d, ny/d);
}
