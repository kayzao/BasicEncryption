PImage art;

void setup() {
  size(256, 256);
  art = loadImage("secret.png");
  art.loadPixels();
  image(art, 0, 0);
}

void draw() {
  image(art, 0, 0);
}

void keyPressed() {
  if (key == 'r') {
    //orginal cat image, no secret message
    art = loadImage("cat.jpg");
  }
  if (key == 'e') {
    art = encode(art, "bye everybody!");
    image(art, 0, 0);
    saveFrame("data/secret.png");
  }
  if (key == 'd') {
    println(decode(art));
  }
}

String decode(PImage img) {
  String message = "";
  img.loadPixels();
  for(int i = 0; i < img.pixels.length; i++){
    if(red(img.pixels[i]) == 255) message += (char)blue(img.pixels[i]);
  }
  return message;
}

int[] getSecretPixels(int numSecrets, int numPixels) {
  int[] secretPixels = new int[ numSecrets ];
  
  for(int i = 0; i < numSecrets; i++){
    int rand = int(random(0, numPixels));
    boolean dupe = false;
    if(i != 0){
      for(int j = 0; j < i; j++){
        if(secretPixels[i] == secretPixels[j]){
          i--;
          dupe = true;
          break;
        }
      }
    }
    if(dupe) continue;
    secretPixels[i] = rand;
  }
  secretPixels = sort(secretPixels);
  return secretPixels;
}

PImage encode(PImage img, String secret) {
  PImage tmp = new PImage(img.width, img.height);
  tmp.loadPixels();
  img.loadPixels();
  
  int[] secretPixels = getSecretPixels(secret.length(), img.pixels.length);
  int[] secretValues = new int[secret.length()];
  
  for(int i = 0; i < secret.length(); i++){
    secretValues[i] = int(secret.charAt(i));
  }
  
  int counter = 0;
  
  for(int p = 0; p < tmp.pixels.length; p++){
    boolean isSecret = false;
    for(int i : secretPixels){
      if(p == i){
        isSecret = true;
        tmp.set(int(p % tmp.width), int(p / tmp.width), color(255, green(img.pixels[p]), secretValues[counter]));
        counter++;
        break;
      }
    }
    if(!isSecret){
      if(red(img.pixels[p]) == 255){
        tmp.set(int(p % tmp.width), int(p / tmp.width), color(254, green(img.pixels[p]), blue(img.pixels[p])));
      } else {
        tmp.set(int(p % tmp.width), int(p / tmp.width), img.pixels[p]);
      }
    }
  }
  return tmp;
}
