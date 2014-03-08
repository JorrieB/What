//
//  GameLayer.m
//  DoodleDrop
//
//  Created by Jorrie Brettin on 2/27/14.
//
//
#import "GameLayer.h"
#import "SimpleAudioEngine.h"
#import "HeyaldaGLDrawNode.h"


NSMutableArray* buttonColors;
NSMutableArray* randomizationArray; //randomization array is a reshuffled ordered array. This is used to color the buttons
NSMutableArray* orderedArray; //holds the button colors
NSArray *purpleA,*redA,*blueA,*fadedBlueA,*greenA; //each array is a color
NSInteger* temp; //temporarily holds values for button randomization purposes
NSNumber* tester;
int temp1, temp2, temp3, temp4, temp5; //these are the button randomization variables
int portalPosition1 = 0; //this keeps track of where the first portal strip is
int portalPosition2 = 240; //this keeps track of where the second portal strip is
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
float static triFrontRef = 0, triTopRef = 3*M_PI/4, triBottomRef = 5*M_PI/4; //variables that we will base the tilt of the triangle on
CGPoint* triFontVert, triTopVert, triBottomVert; //the actual vertex values
CGPoint* triCenter;
int triCentX,triCentY;
float scaleFactor;
int globalPosMov;
int radius = 27;




int numColors = 12;
int stepSize;
NSMutableArray* colors;

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
    globalPosMov = posMove.x;
    //CGPoint triCenter = CGPointMake(triCentX, triCentY);
    
    scaleFactor = .01*(posMove.y - triCentY); //scaling factor
    triCentY = triCentY + .15*(posMove.y - triCentY);
    
    if (posMove.x < WINDOW_WIDTH/6) {
    //moves the penguin if you touch the screen in the appropriate place
        if (posMove.x != 0 && posMove.y != 0) {
            
//            CGPoint triFontVert = CGPointMake(triCentX + 30*cos(triFrontRef + scaleFactor), triCentY + 30*sin(triFrontRef + scaleFactor));
//            CGPoint triTopVert = CGPointMake(triCentX + 30*cos(triTopRef + scaleFactor), triCentY + 30*sin(triTopRef + scaleFactor));
//            CGPoint triBottomVert = CGPointMake(triCentX + 30*cos(triBottomRef + scaleFactor), triCentY + 30*sin(triBottomRef + scaleFactor));
//            CGPoint vertices2[] = {triFontVert, triTopVert,triBottomVert};
            
            //penguin.position = CGPointMake(penguin.position.x, penguin.position.y + .1*(-penguin.position.y+posMove.y));
            //glClearColor(0.f, 1.0f, 1.0f, 1.0f);
        }
    }
    else if (posMove.x > WINDOW_WIDTH*5/6){
        [self backgroundSwitch:posMove];
    }

    //The strips that move across the screen are defined here.
    if (portalPosition1 < 0) {
        portalPosition1 = WINDOW_WIDTH;
        portalHeight1 = arc4random() % (WINDOW_HEIGHT - portalSize);
    }
    //first if will be run on the collision event. it will give the player enough time to reorient
    if (portalPosition1 > WINDOW_WIDTH) {
        portalPosition1 = portalPosition1 - portalSpeed;
    } else {
        portalPosition1 = ((portalPosition1 - portalSpeed) % WINDOW_WIDTH);
    }
    
    if (portalPosition2 < 0) {
        portalPosition2 = WINDOW_WIDTH;
        portalHeight2 = arc4random() % (WINDOW_HEIGHT - portalSize);
    }
    //first if will be run on the collision event. it will give the player enough time to reorient
    if (portalPosition2 > WINDOW_WIDTH) {
        portalPosition2 = portalPosition2 - portalSpeed;
        
    } else {
        portalPosition2 = ((portalPosition2 - portalSpeed) % WINDOW_WIDTH);
    }
    
    if (penguin.position.x == portalPosition1 || penguin.position.x == portalPosition2){
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
        for (int k = 0; k < numColors; ++ k) //rows
        {
            if (posMove.y < stepSize*k) {
                NSArray *thiscolor = [colors objectAtIndex:k];
                float r = [[thiscolor objectAtIndex:0] floatValue]/255;
                float g = [[thiscolor objectAtIndex:1] floatValue]/255;
                float b = [[thiscolor objectAtIndex:2] floatValue]/255;
                glClearColor(r, g, b, ab4);
                currentTouch = k;
                break;
            }
        }

    }
}

// detect for collisions and run collision if one occurs
-(void) collisionDetection
{
    
    if ((penguin.position.x+spriteWidth > portalPosition1 && penguin.position.x+spriteWidth < (portalPosition1+32)) || (penguin.position.x +spriteWidth > portalPosition1 && penguin.position.x + spriteWidth < (portalPosition1+32))) {
        if (((penguin.position.y + spriteHeight) > (portalHeight1 + portalSize)) || ((penguin.position.y - spriteHeight) < portalHeight1)) {
            collisionHappened = true;
        } else if (!(currentTouch == bluePortal)) {
            collisionHappened = true;
        }
    }

    if ((penguin.position.x+spriteWidth > portalPosition2 && penguin.position.x+spriteWidth < (portalPosition2+32)) || (penguin.position.x +spriteWidth > portalPosition2 && penguin.position.x + spriteWidth < (portalPosition2+32))) {
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
    portalPosition1 = WINDOW_WIDTH * 1.5;
    portalPosition2 = WINDOW_WIDTH * 2;
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
        penguin.position = CGPointMake(screenSize.width / 6, imageHeight / 2);\
        
        triCentX = WINDOW_WIDTH/6; // setting initial points
        triCentY = WINDOW_HEIGHT/2;
       
        [self buttonRecolor];
        [self createGradient];
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

-(void) createGradient
{
    // Create an instance of the HeyaldaGLDrawNode class and add it to this layer.
    HeyaldaGLDrawNode* glDrawNode = [[HeyaldaGLDrawNode alloc] init];
    [self addChild:glDrawNode];
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    stepSize = screenSize.height/(numColors-1);
    colors = [[NSMutableArray alloc] init];
    for (int k = 0; k < numColors; ++ k) //rows
    {
        CGPoint thisLeftCorner = ccp(screenSize.width*5/6, stepSize*k);
        CGPoint thisRightCorner = ccp(screenSize.width, stepSize*k);
        float r = (arc4random() % 255);
        float b = (arc4random() % 255);
        float g = (arc4random() % 255);
        NSArray* thiscolor = [NSArray arrayWithObjects:[NSNumber numberWithFloat:r],
                              [NSNumber numberWithFloat:g],
                              [NSNumber numberWithFloat:b], nil];
        [colors addObject:thiscolor];
        [glDrawNode addToDynamicVerts2D:thisLeftCorner withColor:ccc4(r,g,b, 255)];
        [glDrawNode addToDynamicVerts2D:thisRightCorner withColor:ccc4(r,g,b, 255)];

    }
    
    
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
    
    // Rednudant because the defualt is kDrawTriangleStrip, but setting it here for this example.
    glDrawNode.glDrawMode = kDrawTriangleStrip;
    
    // Tell the HeyaldaGLDrawNode that it is ready to draw when it's draw method is called.
    [glDrawNode setReadyToDrawDynamicVerts:YES];

}


-(void) draw
{
//    glClearColor(red, blue, green, alpha);
//    
//    ccDrawSolidRect(ccp(portalPosition1-32, 0), ccp(portalPosition1, WINDOW_HEIGHT), ccc4f(white, white, white, 1));
//    ccDrawSolidRect(ccp(portalPosition1-32, portalHeight1), ccp(portalPosition1, portalHeight1+portalSize), ccc4f(0, 1, 1, 1.0));
//    ccDrawSolidRect(ccp(portalPosition2-32, 0), ccp(portalPosition2, WINDOW_HEIGHT), ccc4f(white, white, white, 1));
//    ccDrawSolidRect(ccp(portalPosition2-32, portalHeight2), ccp(portalPosition2, portalHeight2+portalSize), ccc4f(1, 0, 1, 1.0));

    
    if (globalPosMov != 0) {
        CGPoint triFontVert = CGPointMake(triCentX + radius*cos(triFrontRef + scaleFactor), triCentY + radius*sin(triFrontRef + scaleFactor));
        CGPoint triTopVert = CGPointMake(triCentX + radius*cos(triTopRef + scaleFactor), triCentY + radius*sin(triTopRef + scaleFactor));
        CGPoint triBottomVert = CGPointMake(triCentX + radius*cos(triBottomRef + scaleFactor), triCentY + radius*sin(triBottomRef + scaleFactor));
        CGPoint vertices2[] = {triFontVert, triTopVert,triBottomVert};
        ccDrawSolidPoly(vertices2, 3, ccc4f(0, 1, 1, 1));
    } else {
        CGPoint triFontVert = CGPointMake(triCentX + radius*cos(triFrontRef + scaleFactor), triCentY + radius*sin(triFrontRef + scaleFactor));
        CGPoint triTopVert = CGPointMake(triCentX + radius*cos(triTopRef + scaleFactor), triCentY + radius*sin(triTopRef + scaleFactor));
        CGPoint triBottomVert = CGPointMake(triCentX + radius*cos(triBottomRef + scaleFactor), triCentY + radius*sin(triBottomRef + scaleFactor));
        CGPoint vertices2[] = {triFontVert, triTopVert,triBottomVert};
        ccDrawSolidPoly(vertices2, 3, ccc4f(0, 1, 1, 1));
    }
    
    
    ccDrawColor4F(0, 1, 1, 1);
    //CGPoint vertices2[] = {ccp(150, 120), ccp(180, 120), ccp(165, 150)};
    //CGPoint vertices2[] = { ccp(0,0), ccp(0,screenSize.height*0.5), ccp(screenSize.width*0.5,screenSize.height*0.5), ccp(screenSize.width*0.5,0) };
    //(vertices2, 3, true);
//
//    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
}


@end
