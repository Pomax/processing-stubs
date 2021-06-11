class Bezier {
  int dims = 0; 
  Vec2[] points;
  
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
      stroke(0,100);
      circle(points[0], 3);
      for(int i=0, e=points.length; i<e-1; i++) {
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
    for(int k=0; k<=n; k++) {
      Vec2 p = points[k];
      int b = binomial[n][k];
      double w = pow(t,k) * pow(1-t, n-k);
      x += p.x * w * b;
      y += p.y * w * b;
    }
    return new Vec2(x, y);
  }

  Vec2 getPointNear(Vec2 p) {
    return getPointNear(p, 10);
  }

  Vec2 getPointNear(Vec2 m, double r) {
    for (Vec2 p: points) {
      if (dist(p, m) <= r) return p;
    }
    return null;
  }

  
  String toString() {
    int e = points.length;
    String[] r = new String[e];
    for(int i=0; i<e; i++) r[i] = points[i].toString();
    return "[" + join(r, ", ") + "]";
  }
}
