// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// ScoreScreen Layer
@interface ScoreScreen : CCLayer <UITextFieldDelegate> {
  ccTime totalTime;
  NSMutableArray *scores;
  UITextField *playerNameEntry;
  int rank;
  int screenOffset;
}

// returns a Scene that contains the ScoreScreen as the only child
+(id) scene;

-(void) textFieldDidBeginEditing:(UITextField *)textField;


-(void) textFieldShouldReturn:(UITextField *)textField;

-(void) sortScores;
-(void) cropScores;
-(void) loadScores;
-(void) saveScores;

@property (nonatomic, assign) ccTime totalTime;
@property (nonatomic, assign) NSMutableArray *scores;
@property (nonatomic, assign) UITextField *playerNameEntry;
@property (nonatomic, assign) int rank;
@property (nonatomic, assign) int screenOffset;

@end

NSInteger compare_scores(id first, id second, void *ctx);
