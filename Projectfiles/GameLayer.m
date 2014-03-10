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
int radius = 20;
float smoothTwist;


float r,g,b;

int numColors = 6;
int stepSize;

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
    
    
    if (posMove.x < WINDOW_WIDTH/6) {
    //moves the penguin if you touch the screen in the appropriate place
        if (posMove.x != 0 && posMove.y != 0) {
            scaleFactor = .005*(posMove.y - triCentY);
            triCentY = triCentY + .15*(posMove.y - triCentY);
            smoothTwist = (-posMove.y + penguin.position.y)* .5;
            penguin.position = CGPointMake(penguin.position.x, penguin.position.y + .1*(posMove.y - penguin.position.y));
            penguin.rotation = .5*(-posMove.y + penguin.position.y) - 90;
            //penguin.position = CGPointMake(penguin.position.x, penguin.position.y + .1*(-penguin.position.y+posMove.y));
            //glClearColor(0.f, 1.0f, 1.0f, 1.0f);
        } else {
            scaleFactor = scaleFactor*.9;
            penguin.rotation = smoothTwist - 90;
            smoothTwist = smoothTwist*.8;
        }
    }
    
    if (posMove.x > WINDOW_WIDTH*5/6){
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
        }
    

    [self collisionDetection];
}




-(void) backgroundSwitch: (CGPoint) posMove
{
    //currentTouch = 6;
//    if (posMove.y != 0)
//    {
//        for (int k = 0; k < numColors; ++ k) //rows
//        {
//            if (posMove.y < stepSize*k) {
//                NSArray *thiscolor = [colors objectAtIndex:k];
//                r = [[thiscolor objectAtIndex:0] floatValue]/255;
//                g = [[thiscolor objectAtIndex:1] floatValue]/255;
//                b = [[thiscolor objectAtIndex:2] floatValue]/255;
//                glClearColor(r, g, b, ab4);
//                
//                //glClearColor(1, 1, 1, 1);
//                currentTouch = k;
//                break;
//            }
//        }
//
//    }
    
    if (posMove.y != 0) {
        for (int i = 0; i < 6; i++){
            if (posMove.y < WINDOW_HEIGHT * (i+1) / 6) {
                [self shipSwitch: i];
                break;
            }
        }
    }
}

-(void) shipSwitch: (int) shipColor
{
//    purpleTri = [CCSprite spriteWithFile:@"purpleTri.png"];
//    blueTri = [CCSprite spriteWithFile:@"blueTri.png"];
//    orangeTri = [CCSprite spriteWithFile:@"orangeTri.png"];
//    yellowTri = [CCSprite spriteWithFile:@"yellowTri.png"];
//    pinkTri = [CCSprite spriteWithFile:@"pinkTri.png"];
//    greenTri = [CCSprite spriteWithFile:@"greenTri.png"];
//    
//    NSArray *colorObjects = @[purpleTri,blueTri,orangeTri,yellowTri,pinkTri,greenTri];
//    
//    for (CCSprite* triangle in colorObjects) {
//        triangle.scale = triangle.scale*.18;
//        triangle.position = CGPointMake(WINDOW_WIDTH / 6, WINDOW_HEIGHT / 2);
//        triangle.rotation = -90;
//    }
//    
//    for (int i = 0; i < 6; i++) {
//        [self addChild:[colorObjects objectAtIndex:i]];
//    }
//    
    for (CCSprite* ship in colorObjects) {
        ship.visible = false;
    }
    CCSprite* temp = [colorObjects objectAtIndex:shipColor];
    temp.visible = true;
}

// detect for collisions and run collision if one occurs
-(void) collisionDetection
{
    
    if ((triCentX+spriteWidth > portalPosition1 && triCentX+spriteWidth < (portalPosition1+32)) || (triCentX +spriteWidth > portalPosition1 && triCentX + spriteWidth < (portalPosition1+32))) {
        if (((triCentY + spriteHeight) > (portalHeight1 + portalSize)) || ((triCentY - spriteHeight) < portalHeight1)) {
            collisionHappened = true;
        } else if (!(currentTouch == bluePortal)) {
            //collisionHappened = true;
        }
    }

    if ((triCentX+spriteWidth > portalPosition2 && triCentX+spriteWidth < (portalPosition2+32)) || (triCentX +spriteWidth > portalPosition2 && triCentX + spriteWidth < (portalPosition2+32))) {
        if (((triCentY + spriteHeight) > (portalHeight2 + portalSize)) || ((triCentY - spriteHeight) < portalHeight2)) {
            collisionHappened = true;
        } else if (!(currentTouch == pinkPortal)) {
            //collisionHappened = true;
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
    //[[SimpleAudioEngine sharedEngine] playEffect:@"explo2.wav"];
    
}



-(id) init //this is where you initialize all the objects in the screen; labels, sprites, etc.
{
    if ((self = [super init])) {
        
        //NSArray *colors = @[ccc4f(1, 0, 1, 1),ccc4f(1, 0, 0, 1),ccc4f(0, 0, 1, 1)];
        
        CCLabelTTF* jorrie = [CCLabelTTF labelWithString:@"JorrieB" fontName:@"AppleGothic" fontSize:48];
        jorrie.color = ccCYAN;
        jorrie.position = [CCDirector sharedDirector].screenCenter;
       // [self addChild:jorrie];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"explo2.wav"];
        
        //glClearColor(red, blue, green, alpha);
        
        purpleTri = [CCSprite spriteWithFile:@"purpleTri.png"];
        blueTri = [CCSprite spriteWithFile:@"blueTri.png"];
        orangeTri = [CCSprite spriteWithFile:@"orangeTri.png"];
        yellowTri = [CCSprite spriteWithFile:@"yellowTri.png"];
        pinkTri = [CCSprite spriteWithFile:@"pinkTri.png"];
        greenTri = [CCSprite spriteWithFile:@"greenTri.png"];
        
        NSArray *colors = @[purpleTri,blueTri,orangeTri,yellowTri,pinkTri,greenTri];

        NSMutableArray *colorObjects = [[NSMutableArray alloc] init];
        [colorObjects addObjectsFromArray:colors];
        //NSArray *colorObjects = @[purpleTri,blueTri,orangeTri,yellowTri,pinkTri,greenTri];
        
        for (int i = 0; i < 6; i++) {
            [self addChild:[colorObjects objectAtIndex:i]];
        }

        //penguin.visible = true;
        //penguin.position = CGPointMake(screenSize.width / 6, imageHeight / 2);
        //penguin.scale = penguin.scale*.17;
        //penguin.rotation = -90;
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        WINDOW_HEIGHT = screenSize.height;
        WINDOW_WIDTH = screenSize.width;
        portalSize = WINDOW_HEIGHT/5;
        
        
        for (CCSprite* triangle in colorObjects) {
            triangle.scale = triangle.scale*.18;
            triangle.position = CGPointMake(WINDOW_WIDTH / 6, WINDOW_HEIGHT / 2);
            triangle.rotation = -90;
        }
        
        
        triCentX = WINDOW_WIDTH/6; // setting initial points
        triCentY = WINDOW_HEIGHT/2;
       
        [self createGradient];
        [self scheduleUpdate];
    }
    
    return self;
}


-(void) createGradient
{
    // Create an instance of the HeyaldaGLDrawNode class and add it to this layer.
//    HeyaldaGLDrawNode* glDrawNode = [[HeyaldaGLDrawNode alloc] init];
//    [self addChild:glDrawNode];
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    
    
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


-(void) draw
{
//    glClearColor(red, blue, green, alpha);
//    
    //ccDrawSolidRect(ccp(portalPosition1-32, 0), ccp(portalPosition1, WINDOW_HEIGHT), ccc4f(white, white, white, 1));
    ccDrawSolidRect(ccp(portalPosition1-32, portalHeight1), ccp(portalPosition1, portalHeight1+portalSize), ccc4f(0, 1, 1, 1.0));
    //ccDrawSolidRect(ccp(portalPosition2-32, 0), ccp(portalPosition2, WINDOW_HEIGHT), ccc4f(white, white, white, 1));
    ccDrawSolidRect(ccp(portalPosition2-32, portalHeight2), ccp(portalPosition2, portalHeight2+portalSize), ccc4f(1, 0, 1, 1.0));

   // glClearColor(1, 1, 1, 1);
    
//    CGPoint triFontVert = CGPointMake(triCentX + radius*cos(triFrontRef + scaleFactor), triCentY + radius*sin(triFrontRef + scaleFactor));
//    CGPoint triTopVert = CGPointMake(triCentX + radius*cos(triTopRef + scaleFactor), triCentY + radius*sin(triTopRef + scaleFactor));
//    CGPoint triBottomVert = CGPointMake(triCentX + radius*cos(triBottomRef + scaleFactor), triCentY + radius*sin(triBottomRef + scaleFactor));
//    CGPoint vertices2[] = {triFontVert, triTopVert, triBottomVert};
//    ccDrawSolidPoly(vertices2, 3, ccc4f(1, 0, 1, 1));
    
    for (int i = 0; i < 6; i++) {
        ccDrawSolidRect(ccp(WINDOW_WIDTH*5/6, WINDOW_HEIGHT * i/6), ccp(WINDOW_WIDTH,WINDOW_HEIGHT * (i+1)/6), ccc4f(1, 1, 1, 1));
    }
    

    
}


@end
