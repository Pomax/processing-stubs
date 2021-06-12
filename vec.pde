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
