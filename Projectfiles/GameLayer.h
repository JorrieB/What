//
//  GameLayer.h
//  DoodleDrop
//
//  Created by Jorrie Brettin on 2/26/14.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameLayer : CCLayer
{
    //the portal sprites are declared here so we can use them globally
    CCSprite* portal1;
    CCSprite* topPillar1;
    CCSprite* bottomPillar1;
    CCSprite* portal2;
    CCSprite* topPillar2;
    CCSprite* bottomPillar2;
    
    CCLabelTTF* score;
    
    CCSprite* visibleShip;
    
    CCSprite* purpleTri;
    CCSprite* blueTri;
    CCSprite* yellowTri;
    CCSprite* orangeTri;
    CCSprite* pinkTri;
    CCSprite* greenTri;
    NSMutableArray *colorObjects;
}

+(id) scene;

@end
