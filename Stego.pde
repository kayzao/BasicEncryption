/* How it works: All pixels with a red value of 255 are marked as containing a secret character. 
 * That secret character is in integer form, stored in the blue value of the pixel. The blue value is the ASCII value of the character. 
 * Looping through all pixels in order eventually returns the full message
 */
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
  for (int i = 0; i < img.pixels.length; i++) {
    if (red(img.pixels[i]) == 255) message += (char)blue(img.pixels[i]); //if the red value is 255, it contains a hidden character
  }
  return message;
}

int[] getSecretPixels(int numSecrets, int numPixels) { //generates random numbers
  int[] secretPixels = new int[numSecrets];

  for (int i = 0; i < numSecrets; i++) { //repeatedly generates a number until it is not a duplicate of a previously generated number
    int rand = int(random(0, numPixels));
    boolean dupe = false;
    if (i != 0) {
      for (int j = 0; j < i; j++) {
        if (secretPixels[i] == secretPixels[j]) {
          i--;
          dupe = true;
          break;
        }
      }
    }
    if (dupe) continue;
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

  for (int i = 0; i < secret.length(); i++) secretValues[i] = int(secret.charAt(i)); //converts characters to ASCII integer values

  int counter = 0; //keeps track of how many pixels have been changed from original
  for (int p = 0; p < tmp.pixels.length; p++) { //looks at all pixels, and if the pixel is supposed to be a secret pixel, put the information inside
    boolean isSecret = false;
    for (int i : secretPixels) {
      if (p == i) {
        isSecret = true;
        tmp.set(int(p % tmp.width), int(p / tmp.width), color(255, green(img.pixels[p]), secretValues[counter]));
        counter++;
        break;
      }
    }
    if (!isSecret) {
      if (red(img.pixels[p]) == 255) { //copies the original pixel, but it has to make sure there are no red values of 255
        tmp.set(int(p % tmp.width), int(p / tmp.width), color(254, green(img.pixels[p]), blue(img.pixels[p])));
      } else {
        tmp.set(int(p % tmp.width), int(p / tmp.width), img.pixels[p]);
      }
    }
  }
  return tmp;
}
