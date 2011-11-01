//
//  Constants.m
//  GopherPop
//
//  Created by Алексей Ермаков on 04.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"

int const O_HOLE = 1024;//v1
int const O_MOLE = 128;
int const O_DUST = 192;
int const O_SCORE_LABEL = 12;
int const O_MISS_COUNT_LABEL = 16;
int const O_STAGE_LABEL = 18;
int const O_PAUSE_LAYER = 212;
int const O_GAMEOVER_LAYER = 213;

// Welcome screen labels
int const O_WEL_START_LABEL = 1;
int const O_WEL_SCORE_LABEL = 2;
int const O_WEL_ABOUT_LABEL = 3;

// Pause screen labels
int const O_PAUSE_RESUME_LABEL = 16;
int const O_PAUSE_MENU_LABEL = 17;

float const STAGE_INTERVAL = 12; // Stage length
float CHECK_INTERVAL = 0.1f; // Mole action check interval

bool isFirstTime;

// Moles total
int const MOLES_TOTAL = 6;

// Music & Sound toogles
int const O_MUSIC_OFF = 512;
int const O_SOUND_OFF = 513;
bool musicOn;
bool soundOn;

CGPoint MUSIC_POS = {70, 24};
CGPoint SOUND_POS = {160, 24};

int const HOLE_TABLE[20] = { 2,3,3,3,3,4,4,4,4,5,5,5,5,5,6,6,6,6,6,6 };//v1

// Speed table: number of moles simulatenously on screen, minimul state time, + time to maximal state time
int const SPEED_TABLE[20][3] = {
  {2, 1500, 4100}, // 1
  {2, 1500, 4100}, // 2
  {3, 1500, 4100}, // 3
  {3, 1400, 4000}, // 4
  {3, 1400, 4000}, // 5
  {3, 1300, 3900}, // 6
  {3, 1300, 3900}, // 7
  {4, 1200, 3600}, // 8
  {4, 1200, 3400}, // 9
  {4, 1100, 3300}, // 10
  {4, 1100, 3300}, // 11
  {4, 1000, 3300}, // 12
  {4, 900, 3000}, // 13
  {5, 800, 2700}, // 14
  {5, 800, 2500}, // 15
  {5, 800, 2000}, // 16
  {5, 700, 1800}, // 17
  {5, 700, 1600}, // 18
  {6, 700, 1400}, // 19
  {6, 600, 1400}  // 20
};

// Holes position
//int const HOLES_POSITIONS[6][2] = { {110, 70}, {370, 70}, {240, 115}, {240, 40}, {390, 145}, {90, 145} };
int const HOLES_POSITIONS[6][2] = { {200, 200}, {824, 200}, {512, 350}, {512, 80}, {924, 400}, {100, 400} };
//int const MOLE_OFFSET[2] = {9,30};
int const MOLE_OFFSET[2] = {9,70};

// Last game stats

struct gameStats lastGameStats;

id nextScene; // Used to set next scene from ScoreScreen

bool shouldBePaused;
