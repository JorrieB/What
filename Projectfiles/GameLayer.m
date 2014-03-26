//
//  GameLayer.m
//  DoodleDrop
//
//  Created by Jorrie Brettin on 2/27/14.
//
//
#import "StartMenu.h"
#import "GameLayer.h"
#import "SimpleAudioEngine.h"
#import "HeyaldaGLDrawNode.h"


NSMutableArray* randomizationArray; //randomization array is a reshuffled ordered array. This is used to color the buttons
NSMutableArray* orderedArray; //holds the button colors
NSArray *purpleA,*redA,*blueA,*fadedBlueA,*greenA; //each array is a color
NSInteger* temp; //temporarily holds values for button randomization purposes
NSNumber* tester;
int temp1, temp2, temp3, temp4, temp5; //these are the button randomization variables
int portalPosition1; //this keeps track of where the first portal strip is
int portalPosition2; //this keeps track of where the second portal strip is
int WINDOW_WIDTH;
int WINDOW_HEIGHT;
CGFloat portalHeight1; //portal1.position.y
CGFloat portalHeight2; //portal2.position.y
int portalSize = 22; //how tall the portal is
int spriteHeight = 15; //estimate on sprite size for collision detection
int spriteWidth = 43;
bool collisionHappened = false;
int score = 0; //unimplemented score counter
//float red = 1.0, blue = 1.0, green = 1.0, alpha = 1.0;
//float bb0, bb1, bb2, bb3, bb4, gb0, gb1, gb2, gb3, gb4, rb0, rb1, rb2, rb3, rb4, ab0, ab1, ab2, ab3, ab4;//randomization variables for the button colors
int pinkPortal, bluePortal, currentTouch; //keeps track of whether the background is properly set or not
float portalSpeed;
CGPoint* triCenter;
int triCentX,triCentY;
float shipScaleFactor = .2;
float portalScaleFactor = .44;
float pillarScaleFactor = .3;
int globalPosMov;
int radius = 20;
float smoothTwist;
int shipLayerInteger = 5;
int portalLayerInteger = 4;
int currentShipTag = 2;
float shipRotation = 0;
int colorPortal1, colorPortal2;
int scoreInt;
float beatCounter = .030555555555555*2*M_PI;
double pulseCounter = 0;
double speedIncreaser;// = 90./256.*1./60.;

float r,g,b;

@implementation GameLayer

+(id) scene //you can initialize as many scenes as you want under the scene. this just intializes
//the GameLayer's scenes
{
//    CGSize screenSize = [CCDirector sharedDirector].winSize;
//    WINDOW_HEIGHT = screenSize.height;
//    WINDOW_WIDTH = screenSize.width;
    
    CCScene *scene = [CCScene node]; //We've initialized the scene. This needs to happen to
    CCLayer* layer = [GameLayer node]; // construct it as a ccscene
//    CCLayer* leftSide;
//    leftSide.contentSize = CGSizeMake(100, 500);
//    leftSide.anchorPoint = CGPointMake(0, 0);
//    leftSide.position = CGPointMake(0, 0);
//    [scene addChild:leftSide];
//    CCLayer* rightSide;
//    rightSide.contentSize = CGSizeMake(100, 500);
//    rightSide.anchorPoint = CGPointMake(1,0);
//    rightSide.position = CGPointMake(WINDOW_WIDTH, 0);
//    [scene addChild:rightSide];
//    layer.size =
    [scene addChild:layer];
    return scene;
}

- (void) update:(ccTime)dt
{
    
    visibleShip.scale = visibleShip.scale + .003*sin(pulseCounter);
    
    CCSprite* spriteScaler;
    for (int i = 1; i < 6; i++) {
        spriteScaler = (CCSprite *) [self getChildByTag:i];
        spriteScaler.scale = visibleShip.scale + .003*sin(pulseCounter);
    }
    
    speedIncreaser += 190./(90.*60.);
    portalSpeed = 1+ log2(speedIncreaser);
    
    pulseCounter += beatCounter;
    //KKTouch* touch = [KKTouch ]
    KKInput* input = [KKInput sharedInput];
    //KKInput* leftTouch = [KKInput ]
    //CGpoint posMove= input locationOfAnyTouchInPhase:KKTouchPhaseAny
    CGPoint posMove = [input locationOfAnyTouchInPhase:KKTouchPhaseStationary];
    CGPoint touch2 = [input locationOfAnyTouchInPhase:KKTouchPhaseStationary];
    //globalPosMov = posMove.x;
    //CGPoint triCenter = CGPointMake(triCentX, triCentY);
    CCSprite* tempSprite = (CCSprite *) [self getChildByTag:currentShipTag];
    
//    CCArray* touches = [KKInput sharedInput].touches;
//    KKInput* touch;
//    touch.
//    CCARRAY_FOREACH(touches, touch)
//    {
//        
//        //CGPoint posMove = [touch locationOfAnyTouchInPhase:KKTouchPhaseStationary];
//        if (touch.location < WINDOW_WIDTH/6) {
//            if (touch.anyTouchLocation.y != 0 && touch.anyTouchLocation.x != 0) {
//                smoothTwist = (triCentY - touch.anyTouchLocation.y) * .5;
//                triCentY = triCentY + .1*(touch.anyTouchLocation.y - triCentY);
//                shipRotation = .4*(triCentY - touch.anyTouchLocation.y);
//                tempSprite.rotation = shipRotation;
//                tempSprite.position = ccp(triCentX, triCentY);
//            } else {
//                shipRotation = smoothTwist;
//                tempSprite.rotation = shipRotation;
//                smoothTwist = smoothTwist * .8;
//            }
//        } else if (touch.anyTouchLocation.x > WINDOW_WIDTH*5/6){
//            [self backgroundSwitch:touch.anyTouchLocation];
//        }
//    }
    
    if (posMove.x < WINDOW_WIDTH/6) {
        if (posMove.x != 0 && posMove.y != 0) {
            smoothTwist = (triCentY - posMove.y) * .5;
            triCentY = triCentY + .1*(posMove.y - triCentY);
            shipRotation = .4*(triCentY - posMove.y);
            tempSprite.rotation = shipRotation;
            tempSprite.position = ccp(triCentX, triCentY);
        } else {
            shipRotation = smoothTwist;
            tempSprite.rotation = shipRotation;
            smoothTwist = smoothTwist * .8;
        }
    }
    
    if (touch2.x < WINDOW_WIDTH/6) {
        if (touch2.x != 0 && touch2.y != 0) {
            smoothTwist = (triCentY - touch2.y) * .5;
            triCentY = triCentY + .1*(touch2.y - triCentY);
            shipRotation = .4*(triCentY - touch2.y);
            tempSprite.rotation = shipRotation;
            tempSprite.position = ccp(triCentX, triCentY);
        } else {
            shipRotation = smoothTwist;
            tempSprite.rotation = shipRotation;
            smoothTwist = smoothTwist * .8;
        }
    }
    
    
//    
//    if (posMove.x < WINDOW_WIDTH/6) {
//        CCSprite* tempSprite = (CCSprite *) [self getChildByTag:currentShipTag];
//        if (posMove.x != 0 && posMove.y != 0) {
////            scaleFactor = .005*(posMove.y - triCentY);
//            triCentY = triCentY + .15*(posMove.y - triCentY);
//            smoothTwist = (-posMove.y + tempSprite.position.y)* .5;
//            tempSprite.position = CGPointMake(tempSprite.position.x, tempSprite.position.y + .1*(posMove.y - tempSprite.position.y));
//            tempSprite.rotation = .5*(-posMove.y + tempSprite.position.y) - 90;
//        } else {
////            scaleFactor = scaleFactor*.9;
//            tempSprite.rotation = smoothTwist - 90;
//            smoothTwist = smoothTwist*.8;
//        }
//    }
    
    if (posMove.x > WINDOW_WIDTH*5/6){
        [self backgroundSwitch:posMove];
    }
    
    if (touch2.x > WINDOW_WIDTH*5/6){
        [self backgroundSwitch:touch2];
    }

    //The strips that move across the screen are defined here.
    if (portalPosition1 < -30) {
        [self portalOneSpriteChange:((arc4random()%5)+6)];
        portalPosition1 = WINDOW_WIDTH - 30;
        portalHeight1 = arc4random() % (WINDOW_HEIGHT*1/2)+(WINDOW_HEIGHT/5);
        [self repositionPortal1];
        [self scoreIncrement];
    } else {
        portalPosition1 = portalPosition1 - portalSpeed;
        [self repositionPortal1];
    }
    //first if will be run on the collision event. it will give the player enough time to reorient
//    if (portalPosition1 > WINDOW_WIDTH) {
//        portalPosition1 = portalPosition1 - portalSpeed;
//        [self repositionPortal1];
//
//        //portal1.position = portal1.position - portalSpeed;
//    } else {
//        portalPosition1 = (portalPosition1 - portalSpeed);
//        [self repositionPortal1];
//
//        //portal1.position = ((portal1.position - portalSpeed) % WINDOW_WIDTH);
//
//    }
    
    if (portalPosition2 < -30) {
        [self portalTwoSpriteChange:((arc4random()%5)+11)];
        portalPosition2 = WINDOW_WIDTH - 30;
        portalHeight2 = arc4random() % (WINDOW_HEIGHT*1/2)+(WINDOW_HEIGHT/3);
        [self repositionPortal2];
        [self scoreIncrement];
    } else {
        portalPosition2 = portalPosition2 - portalSpeed;
        [self repositionPortal2];
    }
//    //first if will be run on the collision event. it will give the player enough time to reorient
//    if (portalPosition2 > WINDOW_WIDTH) {
//        //portal2.position = portal2.position - portalSpeed;
//        portalPosition2 = portalPosition2 - portalSpeed;
//        [self repositionPortal2];        
//    } else {
//        portalPosition2 = ((portalPosition2 - portalSpeed) % WINDOW_WIDTH);
//        [self repositionPortal2];
//    }
    
//    if (penguin.position.x == portalPosition1 || penguin.position.x == portalPosition2){
//        red = (rand() % 10) * .1;
//        blue = (rand() % 10) * .1;
//        green = (rand() % 10) * .1;
//        alpha = (rand() % 10) * .1;
//        }
    
//
    [self collisionDetection];
}

-(void) repositionPortal1
{
    portal1.position = CGPointMake(portalPosition1, portalHeight1);
    topPillar1.position = CGPointMake(portalPosition1, portalHeight1 + 155);
    bottomPillar1.position = CGPointMake(portalPosition1, portalHeight1 - 161);
}

-(void) repositionPortal2
{
    portal2.position = CGPointMake(portalPosition2, portalHeight2);
    topPillar2.position = CGPointMake(portalPosition2, portalHeight2 + 155);
    bottomPillar2.position = CGPointMake(portalPosition2, portalHeight2 - 161);
}

-(void) spriteRepositionOnColor: (int) newSprite
{
    CCSprite* tempSprite = (CCSprite *) [self getChildByTag:newSprite];
    tempSprite.rotation = shipRotation;
    tempSprite.position = ccp(triCentX, triCentY);
}


/* takes which portal sprites it will redefine and an offset, which will be used
 * to select using the sprite tags
 */
-(void) portalOneSpriteChange: (int) newColor
{
    //hide the sprites, from the scene so we don't just leave them in limbo
    //portal1.visible = false;
    topPillar1.visible = false;
    bottomPillar1.visible = false;
    //assign whatever portal sprites were passed in to new portal objects
    //portal1 = (CCSprite *) [self getChildByTag:newColor];
    topPillar1 = (CCSprite *) [self getChildByTag:newColor + 10];
    bottomPillar1 =  (CCSprite *)[self getChildByTag:newColor + 20];
    //portal1.visible = true;
    topPillar1.visible = true;
    bottomPillar1.visible = true;
    colorPortal1 = newColor % 5;
}

/* this is a dumb copy of portalOneSpriteChange because I don't know objective C :(
 */
-(void) portalTwoSpriteChange: (int) newColor
{
    //hide the sprites, from the scene so we don't just leave them in limbo
    //portal2.visible = false;
    topPillar2.visible = false;
    bottomPillar2.visible = false;
    //assign whatever portal sprites were passed in to new portal objects
    //portal2 = (CCSprite *) [self getChildByTag:newColor];
    topPillar2 = (CCSprite *) [self getChildByTag:newColor+10];
    bottomPillar2 = (CCSprite *) [self getChildByTag:newColor + 20];
    //portal2.visible = true;
    topPillar2.visible = true;
    bottomPillar2.visible = true;
    colorPortal2 = newColor % 5;
}



-(void) backgroundSwitch: (CGPoint) posMove
{
        for (int i = 0; i < 5; i++){
            if (posMove.y < WINDOW_HEIGHT * (i+1) / 5) {
                [self shipSwitch: (i + 1)];
                break;
            }
    }
}

-(void) shipSwitch: (int) shipColor
{
    //only go through the color of changing the ship color if a different button has been pressed
    if (currentShipTag != shipColor) {
        for (int i = 1; i<6; i++) {
            if (i == shipColor) {
                currentShipTag = i;
                CCSprite* tempSprite = (CCSprite *) [self getChildByTag:i];
                [self spriteRepositionOnColor: i];
                tempSprite.visible = true;
                visibleShip = tempSprite;
            } else {
                CCSprite *tempSprite = (CCSprite *) [self getChildByTag:i];
                tempSprite.visible = false;
            }
        }
    }
}

-(void) scoreIncrement
{
    scoreInt++;
    NSString* tempstring = [NSString stringWithFormat:@"%d", scoreInt];
    score.string = tempstring;
}

// detect for collisions and run collision if one occurs
-(void) collisionDetection
{
    if (triCentX < portalPosition1 + 15 && triCentX > portalPosition1 - 15) {
        if (triCentY > portalHeight1 +portalSize || triCentY < portalHeight1 - portalSize - 5) {
            collisionHappened = true;
        } else if (!(currentShipTag%5 == colorPortal1)) {
//            collisionHappened = true;
        }
    }
    
    if (triCentX < portalPosition2 + 15 && triCentX > portalPosition2 - 15) {
        if (triCentY > portalHeight2 +portalSize || triCentY < portalHeight2 - portalSize - 5) {
            collisionHappened = true;
        } else if (!(currentShipTag % 5 == colorPortal2)) {
//            collisionHappened = true;
        }
    }
    
    if (collisionHappened) {
        [self collision];
    }
    
    
}

-(void) collision
{
//    portalPosition1 = WINDOW_WIDTH * 1.5 - 30;
//    portalPosition2 = WINDOW_WIDTH * 2 - 30;
//    portalHeight1 = arc4random() % (WINDOW_HEIGHT*2/3)+(WINDOW_HEIGHT/6);
//    portalHeight2 = arc4random() % (WINDOW_HEIGHT*2/3)+(WINDOW_HEIGHT/6);
//    [self portalOneSpriteChange:((arc4random()%5)+6)];
//    [self portalTwoSpriteChange:((arc4random()%5)+11)];
//    [self repositionPortal1];
//    [self repositionPortal2];
    
//    score = 0;
    [self unscheduleUpdate];
    currentShipTag = 2;
    
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] playEffect:@"downedShip.wav"];
    
    id move1 = [CCMoveBy actionWithDuration:2.0f position:CGPointMake(100,0)];
    id move2 = [CCMoveBy actionWithDuration:2.0f position:CGPointMake(100,0)];
    id move3 = [CCMoveBy actionWithDuration:2.0f position:CGPointMake(100,0)];
    id move4 = [CCMoveBy actionWithDuration:2.0f position:CGPointMake(100,0)];
    [bottomPillar1 runAction:move1];
    [bottomPillar2 runAction:move2];
    [topPillar1 runAction:move3];
    [topPillar2 runAction:move4];
    id shipRotate = [CCRotateBy actionWithDuration:2.0f angle:-500];
    [visibleShip runAction:shipRotate];
    id shipFade = [CCFadeOut actionWithDuration:2.0f];
    [visibleShip runAction:shipFade];
    
    [self schedule:@selector(sceneTransitionDelay:) interval:1.0f];
    
//    CCScene* transition = [CCTransitionFade transitionWithDuration:1.0f scene:[StartMenu scene]];
//    [[CCDirector sharedDirector] replaceScene:transition];
//    [[CCDirector sharedDirector] replaceScene:
//	 [CCTransitionFade transitionWithDuration:2.0f scene:[StartMenu scene]]];
    

    
//    id shipFall = [CCMoveBy actionWithDuration:2.0f position:CGPointMake(0, -100)];
//    id shipGravityFall = [CCAccelAmplitude actionWithAction:move1 duration:2.0f];
//    [[SimpleAudioEngine sharedEngine] playEffect:@"electronicFunky.mp3"];
    //[[SimpleAudioEngine sharedEngine] playEffect:@"explo2.wav"];
    
}

-(void) sceneTransitionDelay:(ccTime) delta
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:2.0f scene:[StartMenu scene]]];
    [self unschedule:@selector(sceneTransitionDelay:)];
}



-(id) init //this is where you initialize all the objects in the screen; labels, sprites, etc.
{
    if ((self = [super init])) {
        
        
        collisionHappened = false;

        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"downedShip.wav"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"electronicFunky.mp3" loop:true];
        
        //glClearColor(red, blue, green, alpha);
        
//        SKEmitterNode* rocketFlames = [NSKeyedUnarchiver unarchiveObjectWithFile:@"MyParticle.sks"];
//        [self addChild:rocketFlames z:0 tag:7];
        
//        CCSprite* testPortal = [CCSprite spriteWithFile:@"orangePortal.png"];
//        testPortal.position = ccp(140, 180);
//        testPortal.scale = testPortal.scale*portalScaleFactor;
//        [self addChild:testPortal];
//        CCSprite* testTopPillar = [CCSprite spriteWithFile:@"redNeonPillar.png"];
//        testTopPillar.position = ccp(140, 180+155);
//        testTopPillar.scale = testTopPillar.scale*pillarScaleFactor;
//        //testTopPillar.scaleY = 1.25;
//        [self addChild:testTopPillar];
//        CCSprite* testBottomPillar = [CCSprite spriteWithFile:@"redNeonPillar.png"];
//        testBottomPillar.position = ccp(140, 180-161);
//        testBottomPillar.scale = testBottomPillar.scale*pillarScaleFactor;
//        //testBottomPillar.scaleY = 1.25;
//        [self addChild:testBottomPillar];
//        CCSprite* testBottomPillar1 = [CCSprite spriteWithFile:@"greenNeonPillar.png"];
//        testBottomPillar1.position = ccp(180, 130);
//        testBottomPillar1.scale = testBottomPillar1.scale*pillarScaleFactor;
        //testBottomPillar1.scaleY = 1.2;
//        [self addChild:testBottomPillar1];
        
        
        //add all the ships to the the scene
        yellowTri = [CCSprite spriteWithFile:@"NPurple.png"];
        [self addChild:yellowTri z:shipLayerInteger tag:5];
        purpleTri = [CCSprite spriteWithFile:@"NBlue.png"];
        [self addChild:purpleTri z:shipLayerInteger tag:4];
        blueTri = [CCSprite spriteWithFile:@"NYellow.png"];
        [self addChild:blueTri z:shipLayerInteger tag:3];
        orangeTri = [CCSprite spriteWithFile:@"NGreen.png"];
        [self addChild:orangeTri z:shipLayerInteger tag:2];
        greenTri = [CCSprite spriteWithFile:@"NRed.png"];
        [self addChild:greenTri z:shipLayerInteger tag:1];
        for (int i =1; i < 6; i++) {
            CCSprite* tempSprite = (CCSprite *) [self getChildByTag:i];
            tempSprite.scale = shipScaleFactor;//tempSprite.scale*
        }
        
        //add the above pillars in the exact same fashion
        CCSprite* greenAbovePortal1 = [CCSprite spriteWithFile:@"greenNeonPillar.png"];
        [self addChild:greenAbovePortal1 z:shipLayerInteger tag:17];
        CCSprite* orangeAbovePortal1 = [CCSprite spriteWithFile:@"redNeonPillar.png"];
        [self addChild:orangeAbovePortal1 z:shipLayerInteger tag:16];
        CCSprite* blueAbovePortal1 = [CCSprite spriteWithFile:@"blueNeonPillar.png"];
        [self addChild:blueAbovePortal1 z:shipLayerInteger tag:19];
        CCSprite* purpleAbovePortal1 = [CCSprite spriteWithFile:@"purpleNeonPillar.png"];
        [self addChild:purpleAbovePortal1 z:shipLayerInteger tag:20];
        CCSprite* yellowAbovePortal1 = [CCSprite spriteWithFile:@"yellowNeonPillar.png"];
        [self addChild:yellowAbovePortal1 z:shipLayerInteger tag:18];
        CCSprite* greenAbovePortal2 = [CCSprite spriteWithFile:@"greenNeonPillar.png"];
        [self addChild:greenAbovePortal2 z:shipLayerInteger tag:22];
        CCSprite* orangeAbovePortal2 = [CCSprite spriteWithFile:@"redNeonPillar.png"];
        [self addChild:orangeAbovePortal2 z:shipLayerInteger tag:21];
        CCSprite* blueAbovePortal2 = [CCSprite spriteWithFile:@"blueNeonPillar.png"];
        [self addChild:blueAbovePortal2 z:shipLayerInteger tag:24];
        CCSprite* purpleAbovePortal2 = [CCSprite spriteWithFile:@"purpleNeonPillar.png"];
        [self addChild:purpleAbovePortal2 z:shipLayerInteger tag:25];
        CCSprite* yellowAbovePortal2 = [CCSprite spriteWithFile:@"yellowNeonPillar.png"];
        [self addChild:yellowAbovePortal2 z:shipLayerInteger tag:23];
        for (int i = 16; i < 26; i++) {
            CCSprite* tempSprite = (CCSprite *) [self getChildByTag:i];
            tempSprite.scale = tempSprite.scale*pillarScaleFactor;
            tempSprite.scaleY = .58;
            tempSprite.visible = false;
        }
        
        CCSprite* greenBelowPortal1 = [CCSprite spriteWithFile:@"greenNeonPillar.png"];
        [self addChild:greenBelowPortal1 z:shipLayerInteger tag:27];
        CCSprite* orangeBelowPortal1 = [CCSprite spriteWithFile:@"redNeonPillar.png"];
        [self addChild:orangeBelowPortal1 z:shipLayerInteger tag:26];
        CCSprite* blueBelowPortal1 = [CCSprite spriteWithFile:@"blueNeonPillar.png"];
        [self addChild:blueBelowPortal1 z:shipLayerInteger tag:29];
        CCSprite* purpleBelowPortal1 = [CCSprite spriteWithFile:@"purpleNeonPillar.png"];
        [self addChild:purpleBelowPortal1 z:shipLayerInteger tag:30];
        CCSprite* yellowBelowPortal1 = [CCSprite spriteWithFile:@"yellowNeonPillar.png"];
        [self addChild:yellowBelowPortal1 z:shipLayerInteger tag:28];
        CCSprite* greenBelowPortal2 = [CCSprite spriteWithFile:@"greenNeonPillar.png"];
        [self addChild:greenBelowPortal2 z:shipLayerInteger tag:32];
        CCSprite* orangeBelowPortal2 = [CCSprite spriteWithFile:@"redNeonPillar.png"];
        [self addChild:orangeBelowPortal2 z:shipLayerInteger tag:31];
        CCSprite* blueBelowPortal2 = [CCSprite spriteWithFile:@"blueNeonPillar.png"];
        [self addChild:blueBelowPortal2 z:shipLayerInteger tag:34];
        CCSprite* purpleBelowPortal2 = [CCSprite spriteWithFile:@"purpleNeonPillar.png"];
        [self addChild:purpleBelowPortal2 z:shipLayerInteger tag:35];
        CCSprite* yellowBelowPortal2 = [CCSprite spriteWithFile:@"yellowNeonPillar.png"];
        [self addChild:yellowBelowPortal2 z:shipLayerInteger tag:33];
        for (int i = 26; i < 36; i++) {
            CCSprite* tempSprite = (CCSprite *) [self getChildByTag:i];
            tempSprite.scale = tempSprite.scale*pillarScaleFactor;
            tempSprite.scaleY = .58;
            tempSprite.visible = false;
        }
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        WINDOW_HEIGHT = screenSize.height;
        WINDOW_WIDTH = screenSize.width;
        
        pulseCounter = 0;
        scoreInt = 0;
        speedIncreaser = 0;
        
        NSString* scoreString = [NSString stringWithFormat:@"%d", scoreInt];
        score = [CCLabelTTF labelWithString:scoreString fontName:@"AndroidNationBold" fontSize:24];
        //score.color = ccCYAN;
        score.color = ccWHITE;
        score.anchorPoint = CGPointMake(1, 0);
        score.position = CGPointMake(WINDOW_WIDTH*5/6 - 5,0);
        [self addChild:score z:0 tag:99];
        
        
        
        portalPosition1 = WINDOW_WIDTH;
        portalPosition2 = WINDOW_WIDTH*1.5;
        
        CCSprite* buttons = [CCSprite spriteWithFile:@"NeonButtons.png"];
        buttons.position = CGPointMake(WINDOW_WIDTH*5/6+ 45, WINDOW_HEIGHT*.5);
        buttons.scaleY = buttons.scaleY*.66;
        [self addChild:buttons z:shipLayerInteger +1];
        
        // setting initial points
        triCentX = WINDOW_WIDTH/6;
        triCentY = WINDOW_HEIGHT/2;
        
        [KKInput sharedInput].multipleTouchEnabled = YES;
        
        portalHeight1 = arc4random() % (WINDOW_HEIGHT*2/3)+(WINDOW_HEIGHT/6);
        portalHeight2 = arc4random() % (WINDOW_HEIGHT*2/3)+(WINDOW_HEIGHT/6);
        
        [self createGradient];
        [self scheduleUpdate];
        [self shipSwitch:currentShipTag+1];
        [self portalOneSpriteChange:((arc4random()%5)+6)];
        [self portalTwoSpriteChange:((arc4random()%5)+11)];
        [self repositionPortal1];
        [self repositionPortal2];
        
    }
    
    return self;
}


-(void) createGradient
{
    // Create an instance of the HeyaldaGLDrawNode class and add it to this layer.
//    HeyaldaGLDrawNode* glDrawNode = [[HeyaldaGLDrawNode alloc] init];
//    [self addChild:glDrawNode];
//    
//    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    
    
//    stepSize = screenSize.height/(numColors-1);
//    colors = [[NSMutableArray alloc] init];
//    for (int k = 0; k < numColors; ++ k) //rows
//    {
//        CGPoint thisLeftCorner = ccp(screenSize.width*5/6, stepSize*k);
//        CGPoint thisRightCorner = ccp(screenSize.width, stepSize*k);
//        r = (arc4random() % 255);
//        b = (arc4random() % 255);
//        g = (arc4random() % 255);
//        NSArray* thiscolor = [NSArray arrayWithObjects:[NSNumber numberWithFloat:r],
//                              [NSNumber numberWithFloat:g],
//                              [NSNumber numberWithFloat:b], nil];
//        [colors addObject:thiscolor];
//        [glDrawNode addToDynamicVerts2D:thisLeftCorner withColor:ccc4(r,g,b, 255)];
//        [glDrawNode addToDynamicVerts2D:thisRightCorner withColor:ccc4(r,g,b, 255)];
//
//    }
    
    
//    // Define the four corners of the screen
//    CGPoint upperLeftCorner = ccp(screenSize.width*5/6, screenSize.height);
//    CGPoint lowerLeftCorner = ccp(screenSize.width*5/6, 0);
//    CGPoint upperRightCorner = ccp(screenSize.width, screenSize.height);
//    CGPoint lowerRightCorner = ccp(screenSize.width,0);
//    
//    // Create a triangle strip with a counter-clockwise winding.
//    [glDrawNode addToDynamicVerts2D:upperLeftCorner withColor:ccc4(0, 100, 200, 255)];
//    [glDrawNode addToDynamicVerts2D:lowerLeftCorner withColor:ccc4(0, 200, 100, 255)];
//    [glDrawNode addToDynamicVerts2D:upperRightCorner withColor:ccc4(0,100, 200, 255)];
//    [glDrawNode addToDynamicVerts2D:lowerRightCorner withColor:ccc4(0,200, 100, 255)];
    
//    // Rednudant because the defualt is kDrawTriangleStrip, but setting it here for this example.
//    glDrawNode.glDrawMode = kDrawTriangleStrip;
//    
//    // Tell the HeyaldaGLDrawNode that it is ready to draw when it's draw method is called.
//    [glDrawNode setReadyToDrawDynamicVerts:YES];

}


//-(void) draw
//{
//    glClearColor(red, blue, green, alpha);
//    
//    //ccDrawSolidRect(ccp(portalPosition1-32, 0), ccp(portalPosition1, WINDOW_HEIGHT), ccc4f(white, white, white, 1));
//    ccDrawSolidRect(ccp(portalPosition1-32, portalHeight1), ccp(portalPosition1, portalHeight1+portalSize), ccc4f(0, 1, 1, 1.0));
//    //ccDrawSolidRect(ccp(portalPosition2-32, 0), ccp(portalPosition2, WINDOW_HEIGHT), ccc4f(white, white, white, 1));
//    ccDrawSolidRect(ccp(portalPosition2-32, portalHeight2), ccp(portalPosition2, portalHeight2+portalSize), ccc4f(1, 0, 1, 1.0));

   // glClearColor(1, 1, 1, 1);
    
//    CGPoint triFontVert = CGPointMake(triCentX + radius*cos(triFrontRef + scaleFactor), triCentY + radius*sin(triFrontRef + scaleFactor));
//    CGPoint triTopVert = CGPointMake(triCentX + radius*cos(triTopRef + scaleFactor), triCentY + radius*sin(triTopRef + scaleFactor));
//    CGPoint triBottomVert = CGPointMake(triCentX + radius*cos(triBottomRef + scaleFactor), triCentY + radius*sin(triBottomRef + scaleFactor));
//    CGPoint vertices2[] = {triFontVert, triTopVert, triBottomVert};
//    ccDrawSolidPoly(vertices2, 3, ccc4f(1, 0, 1, 1));
    
//    for (int i = 0; i < 6; i++) {
//        ccDrawSolidRect(ccp(WINDOW_WIDTH*5/6, WINDOW_HEIGHT * i/6), ccp(WINDOW_WIDTH,WINDOW_HEIGHT * (i+1)/6), ccc4f(1, 1, 1, 1));
//    }
    

    
//}


@end
