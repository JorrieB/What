//
//  HelloWorldLayer.h
//  HeyaldaOpenGLCustomDraw
//
//  Created by Jim Range on 8/10/12.
//  Copyright Heyalda Corporation 2012. All rights reserved.
//
/*
 
 Copyright 2012 Heyalda Corporation. All rights reserved.
 
 You may use this source code in personal or commercial projects without attribution to the copyright 
 owner of this source code as long as no significant portion of this source code is distributed with
 the work product. 
 
 All digital image media included in this sample project that were created by Heyalda Corporation 
 must not be redistributed in any way; no license to do so is granted.
 
 For example, this source code can be used to create a compiled application that can be sold in the 
 Apple App Store under the condition that none of the digital images created by Heyalda Corporation 
 are included in the application and the application must not include the source code text.
 
 If you publish, distribute, or otherwise make available a significant portion of this source code, 
 you must first receive permission from Heyalda Corporation to do so.
 
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT 
 NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
 NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
 DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@class HeyaldaGLDrawNode;

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer 
{
    
    float waveTime;
    
    // A CCNode subclass that simplifies drawing lines, points, triangle strips, and triangle fan geometery.
    HeyaldaGLDrawNode* glWaveNode;
    
    // Properties of the sinusoidal wave that is created to simulate something like an audio signa.
    NSUInteger         waveVertCount;
    float              wavefrequency;
    float              waveAmplitude;
    float              wavePhase;
    ccColor4B          waveColor;

    // Values used to changed in the update: method to alter the shape of the siusoidal wave that is drawn.
    float               variableFrequency;
    float               variableAmplitude;
    float               amplitudeDirection;
    float               frequencyDirection;
    
    GLbyte              red;
    GLbyte              green;
    GLbyte              blue;
}


@property (nonatomic, retain)  HeyaldaGLDrawNode* glWaveNode;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;


@end
