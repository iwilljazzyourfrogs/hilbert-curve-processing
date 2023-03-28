int order = 9;
int N = int(pow(2, order));
int total = N * N;

int counter = 1;
int perFrame = total;

float phi = (1 + sqrt(5)) / 2;

float numCycles = (1 + random(1)) * (order / phi);
float a;
float b;
float c;

color[][] cols = new color[N][N];

PVector[] path = new PVector[total];

boolean rendering = false;


PVector hilbert(int i) {
  PVector[] points = {
    new PVector(0, 0),
    new PVector(0, 1),
    new PVector(1, 1),
    new PVector(1, 0)
  };
  
  int index = i & 3;
  PVector v = points[index];
  for (int j = 1; j < order; j++) {
    i = i >>> 2;
    index = i & 3;
    int len = int(pow(2, j));
    if (index == 0) {
      float temp = v.x;
      v.x = v.y;
      v.y = temp;
    } else if (index == 1) {
      v.y += len;
    } else if (index == 2) {
      v.x += len;
      v.y += len;
    } else if (index == 3) {
      float temp = len - 1 - v.x;
      v.x = len - 1 - v.y;
      v.y = temp;
      v.x += len;
    }
  }
  return v;
}

void settings() {
  size(512, 512);
}

void setup() {
  
  a = random(1);
  b = random(1);
  c = random(1);
  
  println(numCycles / (order / phi) - 1, a, b, c);
      
  for (int i = 0; i < total; i++) {
    path[i] = hilbert(i);
    float len = float(width) / N;
    path[i].mult(len);
    path[i].add(len / 2, len / 2);
  }
  background(0);
  //colorMode(HSB);
}

void draw() {
  for (int z = 0; z < perFrame; z++) {
    strokeWeight(width / N);
    float h = map(counter, 0, total / numCycles, 0, 255);
    stroke((h + a * 255) % 255, (h + b * 255) % 255, (h + c * 255) % 255);
    
    
    line(path[counter].x, path[counter].y, path[counter - 1].x, path[counter - 1].y);
    counter++;
    if (counter >= path.length) {
      noLoop();
      println("Done!");
      if (rendering) {
        save("render3.png");
      }
      break;
    }
  }
}
