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
     * Constructor argument ordering: Vec2[X,Z,Y]
     */
    public PerspectiveProjector(Vec2 origin, double yScale, Vec2[] vanishingPoints) {
      O = origin;
      Z = vanishingPoints[0];
      X = vanishingPoints[1];

      if (vanishingPoints.length == 3) {
        threePoint = true;
        Y = vanishingPoints[2];
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
