//Mariana Molina 202222414
//E7: Bases de datos 
//Social media engagement data base
Table table;
int nSamples;
//arreglo para plataformas
String[] platforms;
//arreglo para likes 
float[] likes;
//arreglo para comentarios
float[] comments;
//arreglo de sentiment score 
String[] sentiments;

// máximo 10 plataformas distintas
String[] MaxPlatforms = new String[10]; 
int numMaxPlatforms = 0;

//cargar base de datos 
void setup() {
  size(1000, 600);
  table = loadTable("social_media_engagement1.csv", "header");
  nSamples = table.getRowCount();

  platforms = new String[nSamples];
  likes = new float[nSamples];
  comments = new float[nSamples];
  sentiments = new String[nSamples];

//guardar datos de la base de dar=tos en el arreglo al recorrerlas
  for (int i = 0; i < nSamples; i++) {
    String platform = table.getString(i, "platform");
    platforms[i] = platform;
    likes[i] = table.getFloat(i, "likes");
    comments[i] = table.getFloat(i, "comments");
    sentiments[i] = table.getString(i, "sentiment_score");


//guardar cada plataforma unicamente una vez
//recorrer la lista y marcxar las que ya estan guardadas
    boolean found = false;
    for (int j = 0; j < numMaxPlatforms; j++) {
      if (MaxPlatforms[j].equals(platform)) {
        found = true;
        //rompe el ciclo for
        break;
      }
    }
    //Si no esta en la lista se agrega al final y aumenta el conteo de plataformas
    if (!found) {
      MaxPlatforms[numMaxPlatforms] = platform;
      numMaxPlatforms++;
    }
  }
}
//lienzo,titulo
void draw() {
  background(255);
  textAlign(CENTER);
  fill(0);
  textSize(20);
  text("Engagement en Redes Sociales", width / 2, 40);

  // Ejes y marcas
  drawYAxis();
  drawColor();

  // Dibujar burbujas
  for (int i = 0; i < nSamples; i++) {
    //nombre de pltaforma a numero para asignar posicion horizontal
    int platformIndex = getPlatformIndex(platforms[i]);
    //posicion horizontal y vertical de las burbujas
    float x = map(platformIndex, 0, numMaxPlatforms - 1, 150, width - 150);
    float y = map(likes[i], 0, getMax(likes), height - 100, 100);
    float size = map(comments[i], 0, getMax(comments), 10, 60);

    // Color según sentimiento
    if (sentiments[i].equals("positive")) {
      // amarillo
      fill(255, 204, 0, 180); 
    } else if (sentiments[i].equals("neutral")) {
      // azul
      fill(0, 102, 204, 180); 
    } else if (sentiments[i].equals("negative")) {
      // morado
      fill(128, 0, 128, 180); 
    } else {
      fill(150);
    }

    noStroke();
    ellipse(x, y, size, size);
  }

  // Etiquetas plataforma (eje X)
  textSize(14);
  fill(0);
  for (int i = 0; i < numMaxPlatforms; i++) {
    float x = map(i, 0, numMaxPlatforms - 1, 150, width - 150);
    text(MaxPlatforms[i], x, height - 60);
  }
}
//eje vertical "likes"
void drawYAxis() {
  stroke(200);
  line(100, 100, 100, height - 100);
  fill(0);
  textAlign(RIGHT);
  textSize(12);

  int numDivisiones = 5;
  float maxY = getMax(likes);
//dibujar lineas horizontales
  for (int i = 0; i <= numDivisiones; i++) {
    float y = map(i, 0, numDivisiones, height - 100, 100);
    float value = map(i, 0, numDivisiones, 0, maxY);
    stroke(220);
    line(100, y, width - 100, y);
    noStroke();
    text(int(value), 90, y + 4);
  }

  textAlign(CENTER);
  text("Likes", 60, 80);
}

void drawColor() {
  textAlign(LEFT);
  textSize(12);

  int colorX = width - 160;
  int colorY = 80;

  // positive
  fill(255, 204, 0);
  ellipse(colorX, colorY, 15, 15);
  fill(0);
  text("Positivo", colorX + 20, colorY + 5);

  // neutral
  fill(0, 102, 204);
  ellipse(colorX, colorY + 25, 15, 15);
  fill(0);
  text("Neutral", colorX + 20, colorY + 30);

  // negative
  fill(128, 0, 128);
  ellipse(colorX, colorY + 50, 15, 15);
  fill(0);
  text("Negativo", colorX + 20, colorY + 55);
}
//busca indice con el q se guarda la plataforma
int getPlatformIndex(String name) {
  for (int i = 0; i < numMaxPlatforms; i++) {
    if (MaxPlatforms[i].equals(name)) {
      return i;
    }
  }
  return -1;
}
//encuentra el valor maximo dentro del arreglo
float getMax(float[] array) {
  float m = array[0];
  for (int i = 1; i < array.length; i++) {
    if (array[i] > m) m = array[i];
  }
  return m;
}
