//
//  Constants.h
//  GopherPop
//
//  Created by Алексей Ермаков on 04.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#include "cocos2d.h"

extern int const O_HOLE;//v1
extern int const O_MOLE;
extern int const O_DUST;
extern int const O_SCORE_LABEL;
extern int const O_MISS_COUNT_LABEL;
extern int const O_STAGE_LABEL;
extern int const O_PAUSE_LAYER;
extern int const O_GAMEOVER_LAYER;

// Welcome screen labels
extern int const O_WEL_START_LABEL;
extern int const O_WEL_SCORE_LABEL;
extern int const O_WEL_ABOUT_LABEL;

// Pause screen labels
extern int const O_PAUSE_RESUME_LABEL;
extern int const O_PAUSE_MENU_LABEL;

extern float const STAGE_INTERVAL;
extern float CHECK_INTERVAL;

// Moles total
extern int const MOLES_TOTAL;

// Music & Sound toogles
extern int const O_MUSIC_OFF;
extern int const O_SOUND_OFF;
extern bool musicOn;
extern bool soundOn;

extern CGPoint MUSIC_POS;
extern CGPoint SOUND_POS;

// Mole state
enum {
  MS_HIDDEN = 0,
  MS_ANIM_SHOW = 1,
  MS_SHOWN = 2,
  MS_ANIM_HIDE = 3,
  MS_ANIM_HIT = 4
};

extern bool isFirstTime;

extern int const HOLE_TABLE[20];//v1

// Speed table
extern int const SPEED_TABLE[20][3];

// Holes positions
extern int const HOLES_POSITIONS[6][2];
extern int const MOLE_OFFSET[2];

// Last game stats

struct gameStats {
  int score;
  double duration;
  int gophers_hit;
};

extern struct gameStats lastGameStats;

extern id nextScene; // Used to set next scene from ScoreScreen;

extern bool shouldBePaused;
