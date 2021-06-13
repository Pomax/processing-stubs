class Bezier {
  int dims = 0; 
  Vec2[] points;
  Bezier derivative;

  final int[][] binomial = {
    {        1          }, 
    {       1, 1        }, 
    {     1, 2, 1       } , 
    {    1, 3, 3, 1     }, 
    {   1, 4, 6, 4, 1   },
    { 1, 5, 10,10, 5, 1 }    
  };

  public Bezier(Vec2... points) {
    int n = points.length;
    this.points = new Vec2[n];
    arrayCopy(points, 0, this.points, 0, n);
    dims = 2;
    update();
  }
  
  void update() {
    int n = points.length;
    if (n>=2) {
      Vec2 d[] = new Vec2[n-1];
      for (int i=0; i<n-1; i++) {
        d[i] = points[i+1].minus(points[i]).scale(n-1);
      }
      derivative = new Bezier(d);
    }    
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
    
  final double[] WEIGHTS = {
    0.2491470458134028,
    0.2491470458134028,
    0.2334925365383548,
    0.2334925365383548,
    0.2031674267230659,
    0.2031674267230659,
    0.1600783285433462,
    0.1600783285433462,
    0.1069393259953184,
    0.1069393259953184,
    0.0471753363865118,
    0.0471753363865118
  };

  final double[] ABSCISSAE = {
    -0.1252334085114689,
    0.1252334085114689,
    -0.3678314989981802,
    0.3678314989981802,
    -0.5873179542866175,
    0.5873179542866175,
    -0.7699026741943047,
    0.7699026741943047,
    -0.9041172563704749,
    0.9041172563704749,
    -0.9815606342467192,
    0.9815606342467192
  };
  
  double length() {
    if (derivative == null) {
      return points[0].minus(points[1]).mag();
    }
    int n = WEIGHTS.length, i;
    double z = 0.5, sum = 0, t;
    for ( i = 0; i < n; i++) {
      t = z * ABSCISSAE[i] + z;
      sum += WEIGHTS[i] * derivative.get(t).mag();
    }
    return z * sum;
  }

  String toString() {
    int e = points.length;
    String[] r = new String[e];
    for (int i=0; i<e; i++) r[i] = points[i].toString();
    return "[" + join(r, ", ") + "]";
  }
}
