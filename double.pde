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
