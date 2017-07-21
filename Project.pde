ArrayList<Level> levels=new ArrayList<Level>();//ARRAYLIST HOLDING ALL LEVELS
Level currLevel;
int indexOfCurrentLevel=0;

int lives;//LIVES OR ATTEMPTS PER GAME

//GAMESTATES
final int GAMESTART =-1;
final int GAMEINTRO =0;
final int LEVEL_ONE=1;
final int LEVEL_TWO=2;
final int LEVEL_THREE=3;
final int LEVEL_FOUR=4;
final int WIN=5;
final int LOSE=6;
int gameState=GAMESTART;

//SOUND EFFECTS
final String HIT= "hit.wav";
final String  DEAD = "attack.wav";
final String MUSIC = "music.mp3";
//Minim m;
//AudioPlayer sound;

/*@pjs preload="data/gameintro.png", 
               "data/bg.png",
               "data/bg1.png",
               "data/level1.png",
               "data/level2.png",
               "data/level3.png",
               "data/level4.png",
               "data/running0.png",
               "data/running1.png",
               "data/running2.png",
               "data/standing0.png",
               "data/punch0.png",
               "data/punch1.png",
               "data/kick0.png",
               "data/kick1.png",
               "data/kick2.png",
               "data/kick3.png",
               "data/jump0.png",
               "data/badRunning0.png",
               "data/badRunning1.png",
               "data/badRunning2.png",
               "data/badStanding0.png",
               "data/badPunch0.png",
               "data/badPunch1.png",
               "data/badJump0.png",
               "data/badJump1.png",
               "data/badJump2.png",
               "data/badJump3.png",
               "data/badJump4.png",
               "data/badJump5.png",
               "data/badJump6.png",
               "data/badJump7.png",
               "data/ninjaStar0.png",
               "data/ninjaStar1.png",
               "data/swordStanding0.png",
               "data/swordRunning0.png",
               "data/swordRunning1.png",
               "data/swordRunning2.png",
               "data/swordSwipe0.png",
               "data/swordSwipe1.png",
               "data/swordSwipe2.png",
               "data/princess0.png",
               "data/princess1.png",
               "data/fall0.png",
               "data/health0.png",
               "data/dying0.png",
               "data/dying1.png",
               "data/badDying0.png",
               "data/badDying1.png"
               */

int textPos; //OFFSET FOR SCROLLING TEXT IN START SCREEN
int FLOOR = 100; //OFFSET FOR FLOOR OF PLAYER 
PFont f = createFont("Jing Jing", 80, true);

//INTIALIZE IMAGE ARRAYS FOR ANIMATIONS
PImage[] runningPlayer, standing, punching, kicking, jumping, badrunningPlayer, badstanding, badpunching, badkicking;
PImage[] badjumping, star, swordStanding, swordRunning, swordSwipe, princessTemp, falling, dying, baddying, healthImg;

//BACKGROUND IMAGES
PImage bg, bg1, level1Bg, level2Bg, level3Bg, level4Bg, gameIntroBg;

//PLAYER
Player player;


//CALLED WHEN PLAYER DIES AND HAS LIVES LEFT OVER
void resetLevel() {
  lives--; //LIVES DECREMENTED
  player.health = 70; //RESET HEALTH BUT NOT FULLY TO MAINTAIN DIFFICULTY
  player.dead = false;
  player.pos = new PVector(75, height/2+FLOOR);
  levels.clear();
  initializeLevels();
  gameState=GAMEINTRO;
  currLevel=levels.get(indexOfCurrentLevel); //RETURNED TO MOST RECENT LEVEL
}

//CALLED WHEN GAME IS OVER, GAME IS COMPLETLY RESET
void reset() {
  lives=3;
  FLOOR=100;
  player.health = 100;
  player.dead = false;
  player.pos = new PVector(75, height/2+FLOOR);
  levels.clear();
  initializeLevels();
  gameState=GAMEINTRO;
  indexOfCurrentLevel=0; //RETURNED TO BEGINNNING OF GAME
  currLevel=levels.get(indexOfCurrentLevel);
}


//ALL IMAGES ARE LOADED AND RESIZED HERE
void loadAssets() {
  textAlign(CENTER);
  runningPlayer = loadFrames("running", 3, 0);
  standing = loadFrames("standing", 1, 0);
  punching = loadFrames("punch", 2, 0);
  kicking = loadFrames("kick", 4, 0);
  jumping = loadFrames("jump", 1, 0);
  badrunningPlayer = loadFrames("badRunning", 3, 0);
  badstanding = loadFrames("badStanding", 1, 0);
  badpunching = loadFrames("badPunch", 2, 0);
  badkicking = loadFrames("badKick", 4, 0);
  badjumping = loadFrames("badJump", 8, 0);
  star = loadFrames("ninjaStar", 2, 0);
  swordStanding = loadFrames("swordStanding", 1, 0);
  swordRunning = loadFrames("swordRunning", 3, 0);
  swordSwipe = loadFrames("swordSwipe", 3, 0);
  princessTemp = loadFrames("princess", 2, 0);
  falling = loadFrames("fall", 1, 0);
  healthImg = loadFrames("health", 1, 0);
  dying = loadFrames("dying", 2, 0);
  baddying = loadFrames("badDying", 2, 0);
  gameIntroBg = loadImage("data/gameintro.png");
  bg = loadImage("data/bg.png");
  bg1 = loadImage("data/bg1.png");
  level1Bg = loadImage("data/level1.png");
  level2Bg = loadImage("data/level2.png");
  level3Bg = loadImage("data/level3.png");
  level4Bg = loadImage("data/level4.png");
  bg1.resize(width, height);
  bg.resize(width, height);
  gameIntroBg.resize(width, height);
  level1Bg.resize(width, height);
  level2Bg.resize(width, height);
  level3Bg.resize(width, height);
  level4Bg.resize(width, height);
  player = new Player(new PVector(75, height/2+FLOOR));
}

//FUNCTION TO FILL ARRAYS WITH CORRESPONDING IMAGES AS DONE IN LAB DEMO
PImage[] loadFrames(String fileName, int numFrames, int intialFrame) {
  PImage[] loadedArray=new PImage[numFrames];
  for (int i=intialFrame; i<numFrames+intialFrame; i++) {
    loadedArray[i-intialFrame]=loadImage("data/"+fileName+i+".png");
  }
  return loadedArray;
}

//FUNCTION TO SET SPECIFIC LEVEL PARAMETRES FOR GAMEPLAY
void initializeLevels() {
  for (int i=0; i<5; i++) {
    Level l= new Level();
    switch(i) {
    case GAMEINTRO:
      l.intro="Infiltrate the Compund";
      l.bg = gameIntroBg;
      l.door = 700;
      break;
    case LEVEL_ONE:
      l.enemies.add(new Enemy(new PVector(width/2-200, height/2), badstanding[0]));
      l.enemies.add(new Enemy(new PVector(width/2+200, height/2), badstanding[0]));
      l.obstacles.add(new Obstacle(new PVector(width/2, height/2+20), 50, 100));
      l.intro="Level 1: Defeat the poorly trained fighters";
      l.bg = level1Bg;
      l.door = 800;
      break;
    case LEVEL_TWO:
      l.enemies.add(new StarNinja(new PVector(width/2-150, height/2)));
      l.enemies.add(new Enemy(new PVector(width/2+100, height/2), badstanding[0]));
      l.obstacles.add(new Obstacle(new PVector(width/2-50, height/2+20), 50, 100));
      l.obstacles.add(new Obstacle(new PVector(width/2+200, height/2+20), 50, 100));
      l.intro="Level 2: Watch out for the Ninja Stars!";
      l.bg = level2Bg;
      l.door = 800;
      break;
    case LEVEL_THREE:
      l.enemies.add(new SwordNinja(new PVector(width/2+450, height/2)));
      l.enemies.add(new StarNinja(new PVector(200, height/2)));
      l.obstacles.add(new Obstacle(new PVector(350, height/2+20), 50, 100));
      l.intro="Level 3: Can you defeat the sword masters?";
      l.bg = level3Bg;
      l.door = 800;
      break;
    case LEVEL_FOUR:
      l.enemies.add(new BossNinja(new PVector(width/2, height/2)));
      l.obstacles.add(new Obstacle(new PVector(width-100, height/2-50), 50, 260));
      l.obstacles.add(new Obstacle(new PVector(width-400, height/2-50  ), 50, 260));
      l.obstacles.add(new Obstacle(new PVector(width-250, 60), 350, 20));
      l.intro="Level 4: Save the princess from the all powerful master!";
      l.bg = level4Bg;
      l.door = 800;
      l.lastLevel = true;
      l.princess = new Princess(new PVector(width-250, height/2));
      break;
    }
    levels.add(l);
  }
}

//CALLED WHEN LEVEL HAS BEEN BEATEN, ie ALL ENEMIES KILLED AND PASSED THROUGH DOOR
void nextLevel() {
  if (indexOfCurrentLevel<4) indexOfCurrentLevel++;
  if (indexOfCurrentLevel<levels.size()) {
    FLOOR=0; 
    player.pos=new PVector(75, height/2);
    currLevel=levels.get(indexOfCurrentLevel);
  }
}

//START SCREEN FUNCTION
void gamestart() {  
  if (textPos<900) textPos+=2;
  drawGameStart(textPos);
}


//GAMESTART SCREEEN
void drawGameStart(int i) {
  pushMatrix();
  background(bg1);
  fill(0);
  textFont(f, 70); 
  text("Ninja Warrior", 500, 500-i);
  textFont(f, 20);
  text("Your Princess has been kidnapped by the evil war lords!", 500, 600-i);
  text("You must infiltrate their compound and save her", 500, 700-i);
  text("Be aware of their martial art skill!", 520, 800-i);
  text("Punch with 'd' kick with'f'", 500, 900-i);
  textFont(f, 25); 
  text("Click to Continue", 500, 1100-i);
  popMatrix();
}
//WIN SCREEN
void drawWin() {
  pushMatrix();
  background(bg);
  textFont(f, 50); 
  fill(0);
  text("MISSION SUCCESSFUL!", 500, 200);
  textFont(f, 25);
  text("Click to Play Again", 475, 480);
  popMatrix();
}

//LOSE SCREEN
void drawGameOver() {
  pushMatrix();
  background(bg);
  textFont(f, 50); 
  fill(0);
  text("MISSION FAILED!", 500, 200);
  textFont(f, 25);
  text("Click to Play Again", 475, 480);
  popMatrix();
}

//FUNCTION FOR CUSTOM SCREEN FOR LEVEL INTROS
void showScreen(String txt) {
  background(bg);
  textSize(25);
  fill(0);
  text(txt, width/2, height/2);
  text("Lives Remaining: " +lives, width/2, height/2+100);
}

// void playSound(String file) {
//   sound=m.loadFile(file, 2048);
//   sound.play();
// }

PVector upForce=new PVector(0, -30);
PVector downForce=new PVector(0, 1);
PVector leftForce=new PVector(-1, 0);
PVector rightForce=new PVector(1, 0);
boolean left, right, up, down, punch, kick;
int punchTimer = -1;
int kickTimer = -1;

void mousePressed() {
  if (gameState == GAMESTART) gameState = GAMEINTRO;  //INPUT FOR GAME START
  if (gameState == WIN || gameState == LOSE) reset();  //INPUT FOR RESETING
}

void keyPressed() {

  //INPUT TO PUNCH
  if (key=='f'||key=='F') {
    if (punchTimer > 0) { //PREVENT FROM SIMPLY HOLDING BUTTON
      punch=false;
      punchTimer--;
    }
    if (punchTimer == 0) punchTimer = -1;
    if ( punchTimer<0) { //IF KEY IS HELD DOWN SHOOTS AT INTERVAL
      punchTimer = 15;
      punch = true;
    }
  }
  
  //INPUT TO KICK
  if (key=='d'||key=='D') {
    if (kickTimer > 0) {
      kick =false;
      kickTimer--;
    }
    if (kickTimer == 0) kickTimer = -1;
    if ( kickTimer<0) { //IF KEY IS HELD DOWN SHOOTS AT INTERVAL
      kickTimer = 15;
      kick = true;
    }
  }
  
  //INPUT TO MOVE
  if (key==CODED) {
    if (keyCode==UP) up = true;
    if (keyCode==RIGHT) {
      player.turning = 1;
      right=true;
    }
    if (keyCode==LEFT) {
      player.turning = -1;
      left=true;
    }
  }
}

void keyReleased() {

  if (key=='f'||key=='F') {
    punchTimer = -1;
    punch = false;
  }
  if (key=='d'||key=='D') {
    kick = false;
    kickTimer = -1;
  }
  if (key==CODED) {
    if (keyCode==UP) up = false;
    if (keyCode==RIGHT) right=false;
    if (keyCode==LEFT) left=false;
  }
}



class AnimatedCharacter {

  PVector pos, vel, acc; //PHYSICS VECTORS
  float damp, health;

  //VARIABLES AND FRAMES ARRRAY FOR ANIMATION
  PImage img; 
  PImage[] frames; 
  int currFrame, animationRate;

  int turning; //HANDLES WHICH WAY CHARACTER IS FACING
  boolean dead; //FLAG FOR WHEN CHARACTER IS DEAD

  AnimatedCharacter(PVector pos, PVector vel, PImage img) {
    damp=0.8;
    health=100;
    dead = false;
    acc=new PVector();
    this.pos=pos;
    this.vel=vel;
    this.img=img;
    frames = standing;
    animationRate=7;
    turning=1;
  }

  void update() {
    handleAnimation();
    handleWalls();
    if (health <=0) dead = true;
    move();
    draw();
  }

  //HANDLES PHYSICS FOR MOVEMENT
  void move() {
    vel.add(acc);
    pos.add(vel);
    vel.mult(damp);
    acc.mult(0);
  }

  //USED TO PUSH CHARACTER WHEN HIT, OR GIVEN INPUT
  void accelerate(PVector force) {
    acc.add(force);
  }

  //HANDLES LOSS IN HEALTH
  void decreaseHealth(float amount) {
    health -= amount;
  }

  //CYCLES THROUGH FRAMES ARRAY AT A SET RATE TO ANIMATE CHARACTER
  void handleAnimation() {
    if (frameCount%animationRate==0) {
      if (currFrame<frames.length-1) currFrame++; //IF INDEX HAS NOT REACHED END OF ARRAY INCREMENT
      else currFrame=0; //ELSE GO BACK TO START
      img=frames[currFrame]; //SET CURRENT FRAME TO BE IMAGE TO BE DRAWN
    }
  }

  //DO NOT ALLOW CHARACTERS TO GO OFF SCREEN
  void handleWalls() {
    if (pos.x < 80) pos.x = 80;
    if (pos.x > width - 80) pos.x = width - 80;
    if (pos.y < 80) pos.y = 80;
    if (pos.y > height - 80) pos.y = height - 80;
  }

  //DRAW CENTERED IMAGE
  void draw() {
    pushMatrix();
    translate(pos.x, pos.y);
    scale(turning, 1); //ENSURE THE CHARACTER IS FACING THE RIGHT WAY
    image(img, -img.width/2, -img.height/2);
    popMatrix();
  }
}


class Player extends AnimatedCharacter {

  float gravity;
  boolean isJumping, fall;
  int fallTimer;

  Player(PVector pos) {
    super(pos, new PVector(), standing[0]);
    gravity = 0.7;
    isJumping = false;
    fall = false;
    fallTimer = -1;
  }

  void update() {
    resolveEnemies(); //CHECK IF PLAYER HAS HIT ANY ENEMY AND RESOLVE THOSE HITS

    //IF PLAYER HAS HEALTH REDUCED TO A MULTIPE OF 10 THEN PLAYER IS THROWN BACKWARDS 
    if ((int)health%10==0 && health!= 100) {
      //playSound(HIT);
      fallTimer= 25;
      accelerate(new PVector(-turning*50, 0));
      health-=1;
    } 

    //TIMER TO HANDLE FALL ANIMATION
    if (fallTimer >0) {
      fallTimer--;
      frames = falling;
    }
    if (fallTimer == 0) {
      fallTimer = -1;
      frames = standing;
    }

    //HANDLE JUMMPS
    if (pos.y >height/2+FLOOR) {
      pos.y =height/2+FLOOR;
      isJumping = false;
    }
    super.update();
  }

  //JUMP 
  void jump() {
    accelerate(upForce);
    isJumping = true;
  }

  //HANDLE DECREASES IN HEALTH
  void resolveHit() {
    decreaseHealth(0.1);
  }

  //HANDLE ENEMIES
  void resolveEnemies() {
    for (int i=0; i<currLevel.enemies.size (); i++) {
      Enemy curr_enemy = currLevel.enemies.get(i);
      //A HIT ONLY COUNTS IF PLAYER IS PUNCHING OR KICKING
      if (punch||kick) {   
        if (curr_enemy.hitCharacter(player)) {
          curr_enemy.resolveHit();
        }
      }
      if (curr_enemy.timer == 0) currLevel.enemies.remove(curr_enemy); //IF DEAD REMOVE ENEMY
    }
  }
}

class Enemy extends AnimatedCharacter {

  float dist; //DISTANCE FROM PLAYER
  int punchTimer, kickTimer, timer, fallTimer; //CRUCIAL TIMERS FOR ATTACKING AND DEAD ANIMATIONS
  boolean freeze, sword, sound; //FREEZE FLAG STOPS MOVEMENTS, SWORD FLAG IS FOR SWORD NINJA CLASS

  Enemy(PVector pos, PImage img) {
    super(pos, new PVector(), img);
    freeze = false;
    sound=true;
    timer = -1; //TIMER FOR DEAD ANIMATION ONLY SET WHEN ENEMY IS DEAD
    punchTimer =  -1; 
    kickTimer = -1;
    fallTimer = -1;
  }

  void update() {

    //IF ENEMY IS ALIVE CALCULATE DISTANCE AND SET TURNING TO WHERE ENEMY IS FACING
    if (timer < 0) {
      dist = player.pos.x-pos.x;
      if (dist < 0 ) turning = -1;
      else if (dist> 0 ) turning = 1;
      fight(); // CALL FIGHT
    }
    //IF DEAD THEN SET DEAD ANIMATION
    if (timer>0) {
      timer--;
      frames = baddying;
      pos.y+=3;
    }
    super.update();
  }

  //FIGHT ALGORITHM
  void fight() {
    //IF ENEMY IS NOT IN VICINITY OF PLAYER THEN CHASE HIM 
    if (abs(dist) > 80 && freeze == false ) {
      frames = badrunningPlayer;
      pos.x += dist/100;
    } else if (abs(dist) < 80) { //ELSE STOP MOVING AND HIT PLAYER FOR CERTAIN INTERVAL
      freeze = true;
      frames = badstanding;
      punchTimer = 40;
    } 

    //HANDLE PUNCH TIMER
    if (punchTimer>0) {
      punchTimer--;
      frames = badpunching;
    }
    if (punchTimer == 0) {
      punchTimer= -1;
      frames = badstanding;
      freeze = false;
    }
  }

  //HOW MUCH TO DECREASE HEALTH IF BOSS IS HIT AND CHECK IF BOSS IS DEAD
  void resolveHit() {
    decreaseHealth(1);
    if (dead) {
      timer = 60;
      if (sound) {
        //playSound(DEAD);
        sound=false;
      }
    }
  }

  //BOOLEAN FUCNTION TO CHECK IF ENEMY HAS HIT ANOTHER CHARACTER
  boolean hitCharacter(AnimatedCharacter name) {
    if (abs(pos.x - name.pos.x) < img.width/2 + name.img.width/2 &&
      abs(pos.y - name.pos.y) < img.height/2 + name.img.height/2) {
      return true; //collision
    }
    return false; //no collision
  }

  //DRAW CENTRED IMAGE WITH TURNING SET
  void draw() {
    pushMatrix();
    translate(pos.x, pos.y);
    scale(turning, 1);
    image(img, -img.width/2, -img.height/2);

    //HEALTH BAR
    if (health > 0) {        
      fill(color(255, 0, 0));
      rect(-50, -100, 100, 10);
      fill(color(0, 255, 0));
      rect(-50, -100, health, 10);
    }
    popMatrix();
  }
}

class BossNinja extends Enemy {

  PVector upForce1; //FORCE USED BY BOSS TO JUMP
  boolean attack, isJumping;  //FLAGS USED TO HANDLE UNIQUE MOVEMENT OF BOSS

  BossNinja(PVector pos) {
    super(pos, badstanding[0]);
    attack = false;
    isJumping = false;
    upForce1=new PVector(0, -15);
  } 

  void update() {
    //IF BOSS IS JUMPING SET APPROPRIATE FRAMES AND FORCE HIM DOWN
    if (isJumping) { 
      accelerate(downForce);
      frames=badjumping;
    }
    //ENSURE BOSS DOES NOT GO BELOW SET FLOOR AND SER JUMPING FLAG
    if (pos.y > height/2) {
      pos.y = height/2;
      isJumping = false;
    }
    super.update();
  }

  //HANDLE HOW BOSS ATTACKS PLAYER
  void fight() {
    //IF BOSS IS NOT IN VICINITY OF PLAYER THEN CHASE HIM 
    if (abs(dist) > 70 && freeze == false ) {
      if (!isJumping) frames = badrunningPlayer;
      pos.x += dist/40;
    } else if (abs(dist) < 70) { //ELSE STOP MOVING AND HIT PLAYER FOR CERTAIN INTERVAL
      freeze = true;
      punchTimer = 40;
    } 

    //IF AT A CERTAIN DISTANCE BOSS WILL JUMP TO ATTACK PLAYER
    if (abs(dist) < 250 && abs(dist) > 200 && freeze == false ) {
      frames=badjumping;//SET FRAMES
      jump();// SET MOVEMENT
    }

    //HANDLE PUNCH TIMER
    if (punchTimer>0&& isJumping==false) {
      punchTimer--;
      frames = badpunching;
    }
    if (punchTimer == 0) {
      punchTimer= -1;
      frames = badstanding;
      freeze = false;
    }
  }

  //JUMP FUNCTION
  void jump() {
    accelerate(upForce1);
    isJumping = true;
  }

  //HOW MUCH TO DECREASE HEALTH IF BOSS IS HIT AND CHECK IF BOSS IS DEAD
  void resolveHit() {
    decreaseHealth(0.1);
    if (dead) {
      timer = 60;
      if (sound) {
        //playSound(DEAD);
        sound=false;
      }
    }
  }
}

class StarNinja extends Enemy {

  ArrayList<Star> stars;
  int shootTimer, throwTimer, SHOOTTIME, THROWTIME;
  boolean throwing;

  StarNinja(PVector pos) {
    super(pos, badstanding[0]);
    stars = new ArrayList();
    SHOOTTIME = 30;
    THROWTIME = 25;
    shootTimer = SHOOTTIME;
    throwTimer = -1;
    throwing = false;
  }

  void update() {
    //RESOLVE PROJECTILES
    for (int i = 0; i < stars.size (); i++) {
      Star star_i = stars.get(i);
      if (star_i.hitCharacter(player)) player.resolveHit();
      star_i.update();
      //RESOLVE COLLSIONS OF PROJECTILES WITH OBSTACLES
      for (int k = 0; k < currLevel.obstacles.size (); k++) {
        Obstacle curr_obstacle = currLevel.obstacles.get(k);
        if (curr_obstacle.hitStar(star_i) == true) curr_obstacle.resolveStar(star_i);
      }
    }
    super.update();
  }

  void fight() {
    //TIMER TO HANDLE ANIMATIONS FOR THROWING NINJA STARS
    if (throwTimer>0) {
      frames = badpunching;
      throwTimer--;
    }
    if (throwTimer ==0) {
      freeze = false;
      throwTimer = -1;
    }
    
    //CHASE PLAYER BASED ON DISTANCE 
    if (abs(dist) > 80 && freeze == false ) {
      if (shootTimer > 0) shootTimer--; //SHOOT AT CERTAIN INTERVAL
      if (shootTimer <= 0 ) shoot();      
      frames = badrunningPlayer;
      pos.x += dist/700;
    } else if (abs(dist) < 80) { //IF CLOSE TO PLAYER START PUNCHING
      freeze = true;
      frames = standing;
      punchTimer = 40;
    } 
    
    //HANDLE PUNCH TIMER
    if (punchTimer>0) {
      punchTimer--;
      frames = badkicking;
    }
    if (punchTimer == 0) {
      punchTimer= -1;
      frames = badstanding;
      freeze = false;
    }
  }

   //SHOOT FUNCTION, HANDLE ANIMATIONS AND TIMING
  void shoot() {
    stars.add(new Star( this, new PVector(pos.x, pos.y-40)));
    shootTimer = SHOOTTIME;
    freeze = true;
    throwTimer = THROWTIME;
    frames = badpunching;
  }
}



class SwordNinja extends Enemy {

  SwordNinja(PVector pos) {
    super(pos, swordStanding[0]);
    sword = true;
  }

  void fight() {
    //IF SWORD MASTER IS NOT IN VICINITY OF PLAYER THEN CHASE HIM 
    if (abs(dist) > 100 && freeze == false ) {
      frames = swordRunning;
      pos.x += dist/40;
    } else if (abs(dist) < 100) { //HANDLE ATTACK ANIMATION
      freeze = true;
      frames = swordSwipe;
      punchTimer = 40;
    } 

    //HANDLE PUNCH TIMER
    if (punchTimer>0) {
      punchTimer--;
    }
    if (punchTimer == 0) {
      punchTimer= -1;
      frames = swordStanding;
      freeze = false;
    }
  }

  //RESLOVE IF ENEMY IF HIT
  void resolveHit() {
    decreaseHealth(0.5);
    if (dead) {
      timer = 60;
      if (sound) {
        //playSound(DEAD);
        sound=false;
      }
    }
  }
}



class Princess extends AnimatedCharacter {
  // PRINCESS CAN ONLY MOVE IN ONE DIRECTION 
  
  PVector v = new PVector(1, 0);
  
  Princess(PVector pos) {
    super(pos, new PVector(2, 0), princessTemp[0]);
    frames = princessTemp;
    animationRate=15;
  }


  void update() {
    pos.add(v);
    super.update();
  }
}



class Health extends Object {

  Health(PVector pos) {
    super(pos, new PVector(), healthImg[0]);
    frames= healthImg;// SET APPROPRIATE IMAGE FOR ANIMATION
  }

  //HANDLE HEALTH INCREASE
  void increaseHealth(AnimatedCharacter name) {
    if (name.health<100) name.health+=25;
  }
}

class Level {

  String intro; //STRING FOR INTRO SCREEN

  //TIMER FOR SPAWING ENEMIES
  int spawnTimer, SPAWNTIME;

  //TIMER FOR LEVEL STATES
  int introTimer, winTimer;

  //LEVEL STATES
  final int GAMEPLAY=0;
  final int INTRO=1;
  final int WON=2;
  int lvlState, door;

  PImage bg; //BACKGROUNG IMAGE

  //APPROPRIATE ARRAYLISTS
  ArrayList<Enemy> enemies;
  ArrayList<Obstacle> obstacles;
  ArrayList<Health> healthTokens;

  //LAST LEVEL FLAG FOR PRINCESS
  boolean lastLevel = false;
  Princess princess;

  Level() {
    enemies=new ArrayList<Enemy>();
    obstacles=new ArrayList<Obstacle>();
    healthTokens=new ArrayList<Health>();
    introTimer=120;
    winTimer=120;
    lvlState=INTRO;
    SPAWNTIME=360;
    spawnTimer = SPAWNTIME;
  }

  //HANDLE LEVEL STATES
  void gamePlay() {
    switch(lvlState) {
    case INTRO:
      handleIntro();
        break;
    case GAMEPLAY:
      handleGamePlay();
      break;
    case WON:
      handleWin();
      break;
    }
  }

  //DISPLAY INTRO SCREEN FOR 2 SECONDS
  void handleIntro() {
    if (introTimer>0) introTimer--;
    if (introTimer==0) lvlState=GAMEPLAY;
    showScreen(intro);
  }

  //HANDLE ALL GAMEPLAYE ASPECTS
  void handleGamePlay() {
    background(bg);
    drawHUD();
    handleInput();  
    resolveCharacters();
    resolveObstacles();
    if (frameCount % 480 == 0) addHealthTokens(); // ADD HEALTH TOKENS IF NEEDED AT SET INTERVALS
    if (lastLevel) {  //IF LAST LEVEL AND ALL ENEMIES KILLED SET LEVEL STATE TO EIN 
      if (enemies.size()==0) {
        obstacles.clear();
        lvlState = WON;
      }
    } else if (enemies.size()==0 && player.pos.x > currLevel.door) nextLevel();//IF NOT LAST LEVEL AND ALL ENEMIES KILLED GO TO NEXT LEVEL
  } 

  //WAIT 2 SECONDS THEN SHOW WIN SCREEN
  void handleWin() {  
    if (winTimer>0) winTimer--;
    if (winTimer==0) gameState=WIN;
    background(bg);
    drawHUD();
    handleInput();   
    resolveCharacters();
    resolveObstacles();
  }

  //HANDLE ALL CHARACTER
  void resolveCharacters() {

    //HANDLE PLAYER
    player.update(); 
    if (player.dead && lives ==0) gameState = LOSE; //IF DEAD AND NO LIVES LEFT THEN LOSE
    if (player.dead && lives >0) resetLevel(); //ELSE RESET LEVEL

    //IF LAST LEVEL HANDLE PRINCESS
    if (lastLevel) princess.update(); 

    //HANDLE ENEMIES
    for (int i=0; i<enemies.size (); i++) {
      Enemy curr_enemy = enemies.get(i);
      curr_enemy.update();
      if (curr_enemy.hitCharacter(player)) player.resolveHit(); //IF ENEMY HITS PLAYER RESOLVE THE HIT
    }

    //HANDLE ALL HEALTH TOKENS;
    for (int i=0; i<healthTokens.size (); i++) {
      Health curr_health = healthTokens.get(i);
      curr_health.update();
      //IF COLLISION WITH PLAYER, UPDATE HEALTH AND REMOVE TOKEN
      if (curr_health.hitCharacter(player)) {
        curr_health.increaseHealth(player);
        healthTokens.remove(curr_health);
      }
    }

    // SPAWN NEW SET OF ENEMIES AFTER A SET INTERVAL ONCE
    if (spawnTimer>0) spawnTimer--;
    if (spawnTimer==0) {
      spawnEnemy();
      spawnTimer=-1;
    }
  }

  //HANDLE ALL OBSTACLES IN LEVEL
  void resolveObstacles() {
    for (int i = 0; i < obstacles.size (); i++) {
      Obstacle curr_obstacle = obstacles.get(i);
      curr_obstacle.draw();
      //HANDLE PLAYER COLLISONS
      if (curr_obstacle.hitCharacter(player)) curr_obstacle.resolveHit(player);
      if (lastLevel) { //HANDLE PRINCESS COLLISIONS
        if (curr_obstacle.hitCharacter(princess)) curr_obstacle.resolvePrincess(princess);
      }
      //HANDLE ENEMY COLLISIONS
      for (int j = 0; j < enemies.size (); j++) {
        Enemy curr_enemy = enemies.get(j);
        if (curr_obstacle.hitCharacter(curr_enemy) == true) curr_obstacle.resolveEnemy(curr_enemy);
      }
    }
  }

  //HANDLE ALL MOUSE AND KEYBOARD INPUTS
  void handleInput() {

    //HANDLE FRAMES BASED ON INPUTS FOR PLAYER
    if (up) player.frames = jumping;
    else if (left||right) player.frames = runningPlayer;
    else if (punch) player.frames = punching;
    else if (kick) player.frames = kicking;
    else player.frames = standing;

    //HANDLE PHYSICS BASED ON INPUT
    if (player.isJumping) player.accelerate(downForce);
    if (left) player.accelerate(leftForce);
    if (right) player.accelerate(rightForce);
    if (up && !player.isJumping) {
      player.jump();
    }
  }

  //ONLY ADD HEALTH TOKENS WHEN HEALTH IS BELOW 40% AND HEALTH ARRAY LIST IS EMPTY
  void addHealthTokens() {
    if (healthTokens.size()<1  && player.health<40) {
      healthTokens.add(new Health( new PVector(random(width/2), height/2)));
    }
  }

  //SPAWN A SET OF ENEMIES BASED ON LEVEL
  void spawnEnemy() {
    switch(indexOfCurrentLevel) {
    case LEVEL_ONE:  
      enemies.add(new Enemy(new PVector(-400, height/2), badstanding[0]));
      break;
    case LEVEL_TWO:
      enemies.add(new StarNinja(new PVector(-400, height/2)));
      break;
    case LEVEL_THREE:
      enemies.add(new SwordNinja(new PVector(-400, height/2)));
      break;
    case LEVEL_FOUR:
      break;
    }
  }

  //DRAW HUD
  void drawHUD() {
    pushMatrix();
    fill(255, 155);
    rect(5, 5, width-10, 50);
    textFont(f, 14); 
    fill(0);
    text("Player Health", 70, 30);
    text("Level: "+indexOfCurrentLevel, 500, 30);
    text( "Lives Remaining: "+lives, 900, 30);
    fill(color(255, 0, 0));
    rect(140, 15, 100, 10);
    fill(color(0, 255, 0));
    rect(140, 15, player.health, 10);
    popMatrix();
  }
}

class Object extends AnimatedCharacter {
  
  //OBJECT HAS SLOWER ANIMATION LATE AND ONLY INTERACTS BASED ON COLLISIONS
  //REACTS DIFFERENTLY TO COLLISIONS BASED ON CHARACTER AND TYPE OF OBJECT
  
  int animationRate, timer; 

  Object(PVector pos, PVector vel, PImage img) {
    super(pos, vel, img);
    animationRate=3;
  }

  void update() {
    handleAnimation();
    draw();
    pos.add(vel);
  }

  boolean hitCharacter(AnimatedCharacter name) {
    if (abs(pos.x - name.pos.x) < img.width/2 + name.img.width/2 &&
      abs(pos.y - name.pos.y) < img.height/2 + name.img.height/2) {
      return true; //collision
    }
    return false; //no collision
  }
}

class Obstacle {
  int WIDTH, HEIGHT;
  PVector pos;

  Obstacle(PVector pos, int WIDTH, int HEIGHT) {
    this.pos = pos;
    this.WIDTH = WIDTH;
    this.HEIGHT = HEIGHT;
  } 

  //DETECTS COLLISION OF CHARACTER
  boolean hitCharacter(AnimatedCharacter name) {
    if (abs(pos.x - name.pos.x) < WIDTH/2 + name.img.width/2 &&
      abs(pos.y - name.pos.y) < HEIGHT/2 + name.img.height/2) {
      return true; //collision
    }
    return false; //no collision
  }

  //DETECTS COLLISION OF PROJECTILE
  boolean hitStar(Star name) {
    if (abs(pos.x - name.pos.x) < WIDTH/2 + name.img.width/2 &&
      abs(pos.y - name.pos.y) < HEIGHT/2 + name.img.height/2) {
      return true; //collision
    }
    return false; //no collision
  }

  //STOPS PLAYER FROM GOING THROUGH OBSTACLE
  void resolveHit(AnimatedCharacter name) {
    if ((pos.x - name.pos.x) < 0) name.pos.x = pos.x+80;
    if ((pos.x - name.pos.x) > 0) name.pos.x = pos.x-80;
  }

  //STOPS ENEMY FROM MOVING WHEN HITTING AN OBSTACLE
  void resolveEnemy(Enemy name) {
    name.freeze=true;
    if (name.sword) name.frames=swordStanding;
    else name.frames=badstanding;
  }

  //TURNS THE PRINCESS AROUND WHEN HITTNG THE OBSTACKE
  void resolvePrincess(Princess name) { 
    name.turning*=-1;
    name.v.x *= -1;
  }

  // BOUNCE PROJECTILE OFF OBSTACLE
  void resolveStar(Star name) { 
    name.vel.x *= -1;
  }

  //DRAW CENTERD RECTANGLE
  void draw() {
    pushMatrix();
    fill(color(193, 193, 178));
    translate(pos.x, pos.y);
    rect(-WIDTH/2, -HEIGHT/2, WIDTH, HEIGHT);
    popMatrix();
  }
}



void setup() {
  size(1000, 500);
  strokeWeight(5);
  textAlign(CENTER);
  loadAssets();
  initializeLevels();
  lives = 3;
  currLevel=levels.get(indexOfCurrentLevel);
  //playSound(MUSIC);
}


void draw() {
  //HANDLE GAMESTATES
  switch(gameState) {
  case WIN:
    drawWin();
    break;
  case LOSE:
    drawGameOver();
    break;
  case GAMESTART:
    gamestart();
    break;
  default:
    currLevel.gamePlay();
  }
}

