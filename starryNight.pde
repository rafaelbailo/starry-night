String imageSource = "starryNight_1280x1014.jpg";
int imgWidth = 1280;
int imgHeight = 1014;
int N = 7000;
int lifeExpectancy = 50;
int transition=120;

PImage img;
PImage imgBlurred;
int imgLength;

float[] brightness;
PVector[] brushDirection;
Particle[] particles;
int life[];

void settings() {
  size(imgWidth, imgHeight);
}

void setup() {
  background(0);
  imgLength = width * height;

  img = loadImage(imageSource);
  background(img);
  img.filter(BLUR, 1);
  img.loadPixels();

  brightness = logBrightnessArray(img);
  brushDirection = brushDirectionArray(brightness);
  particles = particleArray(N);
  life = new int[N];
  for (int k = 0; k < N; k++) {
    life[k] = round(random(1, lifeExpectancy));
  }
}

void draw() {
  noStroke();
  fill(0, 3);
  rect(0, 0, width, height);

  if (frameCount>transition) {

    int i;
    int j;
    float x;
    float y;
    float alpha;
    float radius;

    int limit = min(N, 100*(frameCount-transition));

    for (int k = 0; k < limit; k++) {
      if (life[k]==0) {
        life[k] = round(random(lifeExpectancy/2, lifeExpectancy));
        particles[k].setX(new PVector(random(0, width - 1), random(0, height - 1)));
      } else {
        life[k]--;
      }

      x = particles[k].getX().x;
      y = particles[k].getX().y;

      i = round(x);
      j = round(y);

      particles[k].setV(brushDirection[index(i, j)]);

      particles[k].move(0.1f * 300);

      alpha=map(life[k], 0, lifeExpectancy, 150, 0);
      fill(img.pixels[index(i, j)], alpha);

      radius=map(life[k], 0, lifeExpectancy, 2, 12);
      circle(x, y, radius);
    }
  }
  
  saveFrame("frames/####.png");
}

void circle(float x, float y, float r) {
  ellipse(x, y, r, r);
}

int index(int i, int j) {
  return i + j * width;
}

float[] logBrightnessArray(PImage img) {
  float[] brightness = new float[imgLength];
  for (int k = 0; k < imgLength; k++) {
    brightness[k] = log(1 + brightness(img.pixels[k]));
  }
  return brightness;
}

PVector[] brushDirectionArray(float[] array) {
  PVector[] direction = new PVector[imgLength];
  float dx;
  float dy;

  for (int i = 1; i < width - 1; i++) {
    for (int j = 1; j < height - 1; j++) {
      dx = 0.5f * (array[index(i + 1, j)] - array[index(i - 1, j)]);
      dy = 0.5f * (array[index(i, j + 1)] - array[index(i, j - 1)]);
      direction[index(i, j)] = new PVector(-dy, dx);
    }
  }

  for (int i = 0; i < width; i++) {
    direction[index(i, 0)] = new PVector(0, 1);
    direction[index(i, height - 1)] = new PVector(0, -1);
  }

  for (int j = 0; j < height; j++) {
    direction[index(0, j)] = new PVector(1, 0);
    direction[index(width - 1, j)] = new PVector(-1, 0);
  }

  return direction;
}

Particle[] particleArray(int N) {
  Particle[] particles = new Particle[N];
  for (int k = 0; k < N; k++) {
    particles[k] = new Particle();
    particles[k].setX(new PVector(random(0, width - 1), random(0, height - 1)));
    particles[k].setBounds(0, width - 1, 0, height - 1);
  }
  return particles;
}
