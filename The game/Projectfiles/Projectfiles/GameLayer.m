//
//  GameLayer.m
//  DoodleDrop
//
//  Created by Jorrie Brettin on 2/27/14.
//
//

#import "GameLayer.h"
#import "SimpleAudioEngine.h"

NSMutableArray* buttonColors;
NSMutableArray* randomizationArray; //randomization array is a reshuffled ordered array. This is used to color the buttons
NSMutableArray* orderedArray; //holds the button colors
NSArray *purpleA,*redA,*blueA,*fadedBlueA,*greenA; //each array is a color
NSInteger* temp; //temporarily holds values for button randomization purposes
NSNumber* tester;
int temp1, temp2, temp3, temp4, temp5; //these are the button randomization variables
int done = 0; //this keeps track of where the first portal strip is
int done1 = 240; //this keeps track of where the second portal strip is
int WINDOW_WIDTH;
int WINDOW_HEIGHT;
int portalHeight1; //portal1.position.y
int portalHeight2; //portal2.position.y
int portalSize; //how tall the portal is
int spriteHeight = 15; //estimate on sprite size for collision detection
int spriteWidth = 43;
bool collisionHappened = false;
int score = 0; //unimplemented score counter
float red = 1.0, blue = 1.0, green = 1.0, alpha = 1.0;
float bb0, bb1, bb2, bb3, bb4, gb0, gb1, gb2, gb3, gb4, rb0, rb1, rb2, rb3, rb4, ab0, ab1, ab2, ab3, ab4;//randomization variables for the button colors
int pinkPortal, bluePortal, currentTouch; //keeps track of whether the background is properly set or not
int portalSpeed = 2;
int white = 1; //flips the portal strips from white to black; if (white == 1) stripcolor = white;



@implementation GameLayer

+(id) scene //you can initialize as many scenes as you want under the scene. this just intializes
//the GameLayer's scenes
{
    
    CCScene *scene = [CCScene node]; //We've initialized the scene. This needs to happen to
    CCLayer* layer = [GameLayer node]; // construct it as a ccscene
    [scene addChild:layer];
    return scene;
}

- (void) update:(ccTime)dt
{
    KKInput* input = [KKInput sharedInput];
    CGPoint posMove = [input locationOfAnyTouchInPhase:KKTouchPhaseStationary];
    
    if (posMove.x < WINDOW_WIDTH/6) {
    //moves the penguin if you touch the screen in the appropriate place
        if (posMove.x != 0 && posMove.y != 0) {
            penguin.position = CGPointMake(penguin.position.x, penguin.position.y + .1*(-penguin.position.y+posMove.y));
            //glClearColor(0.f, 1.0f, 1.0f, 1.0f);
        }
    }
    else if (posMove.x > WINDOW_WIDTH*5/6){
        [self backgroundSwitch:posMove];
    }
    
    
    //The strips that move across the screen are defined here.
    if (done < 0) {
        done = WINDOW_WIDTH;
        portalHeight1 = arc4random() % (WINDOW_HEIGHT - portalSize);
    }
    //first if will be run on the collision event. it will give the player enough time to reorient
    if (done > WINDOW_WIDTH) {
        done = done - portalSpeed;
    } else {
        done = ((done - portalSpeed) % WINDOW_WIDTH);
    }
    
    if (done1 < 0) {
        done1 = WINDOW_WIDTH;
        portalHeight2 = arc4random() % (WINDOW_HEIGHT - portalSize);
    }
    //first if will be run on the collision event. it will give the player enough time to reorient
    if (done1 > WINDOW_WIDTH) {
        done1 = done1 - portalSpeed;
        
    } else {
        done1 = ((done1 - portalSpeed) % WINDOW_WIDTH);
    }
    
    if (penguin.position.x == done || penguin.position.x == done1){
        red = (rand() % 10) * .1;
        blue = (rand() % 10) * .1;
        green = (rand() % 10) * .1;
        alpha = (rand() % 10) * .1;
        [self buttonRecolor];
        if (white == 0){
            white = 1;
        } else {
            white = 0;
        }
    }
    

    [self collisionDetection];
}




-(void) backgroundSwitch: (CGPoint) posMove
{
    currentTouch = 6;
    if (posMove.y != 0)
    {
        if (posMove.y < WINDOW_HEIGHT/5) {
            glClearColor(rb4, gb4, bb4, ab4);
            currentTouch = 5;
        } else if (posMove.y < WINDOW_HEIGHT*2/5) {
            glClearColor(rb3, gb3, bb3, ab3);
            currentTouch = 4;
        } else if (posMove.y < WINDOW_HEIGHT*3/5) {
            glClearColor(rb2, gb2, bb2, ab2);
            currentTouch = 3;
        } else if (posMove.y < WINDOW_HEIGHT*4/5) {
            glClearColor(rb1, gb1, bb1, ab1);
            currentTouch = 2;
        } else {
            glClearColor(rb0, gb0, bb0, ab0);
            currentTouch = 1;
        }
    }
}

// detect for collisions and run collision if one occurs
-(void) collisionDetection
{
    
    if ((penguin.position.x+spriteWidth > done && penguin.position.x+spriteWidth < (done+32)) || (penguin.position.x +spriteWidth > done && penguin.position.x + spriteWidth < (done+32))) {
        if (((penguin.position.y + spriteHeight) > (portalHeight1 + portalSize)) || ((penguin.position.y - spriteHeight) < portalHeight1)) {
            collisionHappened = true;
        } else if (!(currentTouch == bluePortal)) {
            collisionHappened = true;
        }
    }

    if ((penguin.position.x+spriteWidth > done1 && penguin.position.x+spriteWidth < (done1+32)) || (penguin.position.x +spriteWidth > done1 && penguin.position.x + spriteWidth < (done1+32))) {
        if (((penguin.position.y + spriteHeight) > (portalHeight2 + portalSize)) || ((penguin.position.y - spriteHeight) < portalHeight2)) {
            collisionHappened = true;
        } else if (!(currentTouch == pinkPortal)) {
            collisionHappened = true;
        }
    }
    
    
    if (collisionHappened) {
        [self collision];
    }
}

-(void) collision
{
    done = WINDOW_WIDTH * 1.5;
    done1 = WINDOW_WIDTH * 2;
    portalHeight1 = rand() % (WINDOW_HEIGHT - portalSize);
    portalHeight2 = rand() % (WINDOW_HEIGHT - portalSize);
    collisionHappened = false;
    score = 0;
    [[SimpleAudioEngine sharedEngine] playEffect:@"explo2.wav"];
    
}



-(id) init //this is where you initialize all the objects in the screen; labels, sprites, etc.
{
    if ((self = [super init])) {
        
        CCLabelTTF* jorrie = [CCLabelTTF labelWithString:@"JorrieB" fontName:@"AppleGothic" fontSize:48];
        jorrie.color = ccCYAN;
        jorrie.position = [CCDirector sharedDirector].screenCenter;
       // [self addChild:jorrie];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"explo2.wav"];
        
        glClearColor(red, blue, green, alpha);
        
        penguin = [CCSprite spriteWithFile:@"waitingpenguin.png"]; //cocos auto-loads -hd files on retina
        [self addChild:penguin z:1];
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        WINDOW_HEIGHT = screenSize.height;
        WINDOW_WIDTH = screenSize.width;
        portalSize = WINDOW_HEIGHT/5;
        float imageHeight = penguin.texture.contentSize.height;
        penguin.position = CGPointMake(screenSize.width / 6, imageHeight / 2);
       
        [self buttonRecolor];
        [self scheduleUpdate];
    }
    
    return self;
}


-(void) buttonRecolor
{
   
    
    NSArray *purpleA = [NSArray arrayWithObjects:@1,@0, @1, @1, nil]; // the pink portal
    NSArray *redA = [NSArray arrayWithObjects:@1,@0, @0, @1, nil];
    NSArray *blueA = [NSArray arrayWithObjects:@0,@0, @1, @1, nil];
    NSArray *fadedBlueA = [NSArray arrayWithObjects:@0,@1,@1,@1, nil]; // the blue portal
    NSArray *greenA = [NSArray arrayWithObjects:@0,@1, @0, @1, nil];
    NSMutableArray *orderedArray = [NSMutableArray arrayWithObjects:purpleA, redA, blueA, fadedBlueA, greenA, nil];
    
    temp1 = arc4random() % 5;
    temp2 = arc4random() % 5;
    while (temp1 == temp2) {
        temp2 = arc4random() % 5;
    }
    temp3 = arc4random() % 5;
    while (temp1 == temp3 || temp2 == temp3) {
        temp3 = arc4random() % 5;
    }
    temp4 = arc4random() % 5;
    while (temp4 == temp1 || temp4 == temp2 || temp4 == temp3) {
        temp4 = arc4random() % 5;
    }
    temp5 = arc4random() % 5;
    while (temp5 == temp1 || temp5 == temp2 || temp5 == temp3 || temp5 == temp4) {
        temp5 = arc4random() % 5;
    }
    
    if (temp1 == 0) {
        pinkPortal = 1;
    } else if (temp2 == 0) {
        pinkPortal = 2;
    } else if (temp3 == 0) {
        pinkPortal = 3;
    } else if (temp4 == 0) {
        pinkPortal = 4;
    } else {
        pinkPortal = 5;
    }
    
    if (temp1 == 3) {
        bluePortal = 1;
    } else if (temp2 == 3) {
        bluePortal = 2;
    } else if (temp3 == 3) {
        bluePortal = 3;
    } else if (temp4 == 3) {
        bluePortal = 4;
    } else {
        bluePortal = 5;
    }
   
    
    tester = [[orderedArray objectAtIndex:temp1] objectAtIndex:0];
    rb0 = tester.floatValue;
    tester = [[orderedArray objectAtIndex:temp1] objectAtIndex:1];
    gb0 = tester.floatValue;
    tester = [[orderedArray objectAtIndex:temp1] objectAtIndex:2];
    bb0 = tester.floatValue;
    tester = [[orderedArray objectAtIndex:temp1] objectAtIndex:3];
    ab0 = tester.floatValue;
    tester = [[orderedArray objectAtIndex:temp2] objectAtIndex:0];
    rb1 = tester.floatValue;
    tester = [[orderedArray objectAtIndex:temp2] objectAtIndex:1];
    gb1 = tester.floatValue;
    tester = [[orderedArray objectAtIndex:temp2] objectAtIndex:2];
    bb1 = tester.floatValue;
    tester = [[orderedArray objectAtIndex:temp2] objectAtIndex:3];
    ab1 = tester.floatValue;
    tester = [[orderedArray objectAtIndex:temp3] objectAtIndex:0];
    rb2 = tester.floatValue;
    tester = [[orderedArray objectAtIndex:temp3] objectAtIndex:1];
    gb2 = tester.floatValue;
    tester = [[orderedArray objectAtIndex:temp3] objectAtIndex:2];
    bb2 = tester.floatValue;
    tester = [[orderedArray objectAtIndex:temp3] objectAtIndex:3];
    ab2 = tester.floatValue;
    tester = [[orderedArray objectAtIndex:temp4] objectAtIndex:0];
    rb3 = tester.floatValue;
    tester = [[orderedArray objectAtIndex:temp4] objectAtIndex:1];
    gb3 = tester.floatValue;
    tester = [[orderedArray objectAtIndex:temp4] objectAtIndex:2];
    bb3 = tester.floatValue;
    tester = [[orderedArray objectAtIndex:temp4] objectAtIndex:3];
    ab3 = tester.floatValue;
    tester = [[orderedArray objectAtIndex:temp5] objectAtIndex:0];
    rb4 = tester.floatValue;
    tester = [[orderedArray objectAtIndex:temp5] objectAtIndex:1];
    gb4 = tester.floatValue;
    tester = [[orderedArray objectAtIndex:temp5] objectAtIndex:2];
    bb4 = tester.floatValue;
    tester = [[orderedArray objectAtIndex:temp5] objectAtIndex:3];
    ab4 = tester.floatValue;
    
}

-(void) draw
{
    glClearColor(red, blue, green, alpha);
    
    ccDrawSolidRect(ccp(done-32, 0), ccp(done, WINDOW_HEIGHT), ccc4f(white, white, white, 1));
    ccDrawSolidRect(ccp(done-32, portalHeight1), ccp(done, portalHeight1+portalSize), ccc4f(0, 1, 1, 1.0));
    ccDrawSolidRect(ccp(done1-32, 0), ccp(done1, WINDOW_HEIGHT), ccc4f(white, white, white, 1));
    ccDrawSolidRect(ccp(done1-32, portalHeight2), ccp(done1, portalHeight2+portalSize), ccc4f(1, 0, 1, 1.0));

    CGSize screenSize = [CCDirector sharedDirector].winSize;
    ccColor4F rectColorPurple = ccc4f(rb0, gb0, bb0, ab0); //parameters correspond to red, green, blue, and alpha (transparancy)
    ccDrawSolidRect(ccp( screenSize.width*5/6, screenSize.height*.8), ccp(screenSize.width, screenSize.height), rectColorPurple);
    
    ccColor4F rectColorRed = ccc4f(rb1, gb1, bb1, ab1); //parameters correspond to red, green, blue, and alpha (transparancy)
    ccDrawSolidRect(ccp( screenSize.width*5/6, screenSize.height*.6), ccp(screenSize.width, screenSize.height*.8), rectColorRed);
    
    ccColor4F rectColorBlue = ccc4f(rb2, gb2, bb2, ab2); //parameters correspond to red, green, blue, and alpha (transparancy)
    ccDrawSolidRect(ccp( screenSize.width*5/6, screenSize.height*.4), ccp(screenSize.width, screenSize.height*.6), rectColorBlue);
    
    ccColor4F rectColorYellow = ccc4f(rb3, gb3, bb3, ab3); //parameters correspond to red, green, blue, and alpha (transparancy)
    ccDrawSolidRect(ccp( screenSize.width*5/6, screenSize.height*.2), ccp(screenSize.width, screenSize.height*.4), rectColorYellow);
    
    ccColor4F rectColorGreen = ccc4f(rb4, gb4, bb4, ab4); //parameters correspond to red, green, blue, and alpha (transparancy)
    ccDrawSolidRect(ccp( screenSize.width*5/6, 0), ccp(screenSize.width, screenSize.height*.2), rectColorGreen);
    
    
}


@end
