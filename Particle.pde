class Particle {
  PVector x;
  PVector v;

  boolean bounded = false;
  float xMax;
  float xMin;
  float yMax;
  float yMin;

  PVector getX() {
    return x;
  } 
  void setX(PVector x) {
    this.x = x;
  } 
  PVector getV() {
    return v;
  }
  void setV(PVector v) {
    this.v = v;
  }

  Particle() {
    x = new PVector();
    v = new PVector();
  }

  void move(float dt) {
    x.add(PVector.mult(v, dt));
    if (bounded) {
      constrain();
    }
  }

  void constrain() {
    float x = getX().x;
    float y = getX().y;

    if (x < xMin) {
      x = xMin;
    }
    if (x > xMax) {
      x = xMax;
    }
    if (y < yMin) {
      y = yMin;
    }
    if (y > yMax) {
      y = yMax;
    }

    setX(new PVector(x, y));
  }

  void setBounds(float xMin, float xMax, float yMin, float yMax) {
    this.xMin = xMin;
    this.xMax = xMax;
    this.yMin = yMin;
    this.yMax = yMax;
    bounded = true;
  }
}
