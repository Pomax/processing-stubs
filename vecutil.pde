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

void rect(Vec2 p, Vec2 dims) {
  rect(p.x, p.y, dims.x, dims.y);
}

double dist(Vec2 v1, Vec2 v2) {
  return v2.minus(v1).mag();
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
