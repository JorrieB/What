//
//  StartMenu.m
//  TempWhat
//
//  Created by Jorrie Brettin on 3/23/14.
//
//

#import "StartMenu.h"
#import "GameLayer.h"
#import "SimpleAudioEngine.h"


int WINDOW_HEIGHT,WINDOW_WIDTH;
float jorrie = .030555555555555*2*M_PI;
double brettin = 0;

@implementation StartMenu

+(id) scene //you can initialize as many scenes as you want under the scene. this just intializes
//the GameLayer's scenes
{
    
    CCScene *scene = [CCScene node]; //We've initialized the scene. This needs to happen to
    CCLayer* layer = [StartMenu node]; // construct it as a ccscene
    [scene addChild:layer];
    return scene;
}

-(id) init //this is where you initialize all the objects in the screen; labels, sprites, etc.
{
    if ((self = [super init])) {
        
        
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        WINDOW_HEIGHT = screenSize.height;
        WINDOW_WIDTH = screenSize.width;
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"electronicFunky.mp3"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"straightBassLoop.wav" loop:true];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"snareTransition.wav"];
        
        playButton = [CCSprite spriteWithFile:@"neonPurpleTitle.png"];
        playButton.position = CGPointMake(WINDOW_WIDTH/2, WINDOW_HEIGHT*3/4);
        [self addChild:playButton];
        CCMenuItem* play = [CCMenuItemImage itemWithNormalImage:@"RedPlayButton.png" selectedImage:@"GreenPlayButton.png" target:self selector:@selector(goToGameLayer)];
        play.scale = .7;
        CCMenuItem* share = [CCMenuItemImage itemWithNormalImage:@"BlueShareButton.png" selectedImage:@"BlueShareButton.png" target:self selector:@selector(goToSettings)];
        share.scale = .7;
        CCMenuItem* credits = [CCMenuItemImage itemWithNormalImage:@"GreenCreditsButton.png" selectedImage:@"GreenCreditsButton.png" target:self selector:@selector(goToSettings)];
        credits.scale = .7;
        CCMenu* menu = [CCMenu menuWithItems:play,share, credits, nil];
        [menu alignItemsHorizontally];
        //menu.scale = .7;
        menu.position = CGPointMake(WINDOW_WIDTH/2, WINDOW_HEIGHT/3);
        [self addChild:menu];
        [self schedule:@selector(bouncingWhat:)];
        
        
    }
    
    return self;
}

-(void) bouncingWhat:(ccTime)delta
{
    playButton.scale = playButton.scale + .005*sin(brettin);
    brettin += jorrie;

}

-(void) goToGameLayer
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] playEffect:@"snareTransition.wav"];
    [self unschedule:@selector(bouncingWhat:)];
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.5f scene:[GameLayer scene]]];
    //[[CCDirector sharedDirector] : (CCScene*)[[GameLayer alloc] init]];
    //CCScene *gameplayScene = [CCBReader loadAsScene:@"GameLayer"];
   // [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void) goToSettings
{
    
}

@end
