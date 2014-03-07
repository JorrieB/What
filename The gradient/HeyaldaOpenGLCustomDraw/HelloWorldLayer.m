//
//  HelloWorldLayer.m
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

// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "HeyaldaGLDrawNode.h"


@interface HelloWorldLayer ()  

-(void) createBackground;
-(void) createWave;

@end

// HelloWorldLayer implementation
@implementation HelloWorldLayer

@synthesize glWaveNode;


// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
        // Moved init to onEnter in case this is the first node that is run due to the bug with winSize being inaccurate on init.
        
        
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    self.glWaveNode = nil;
    
	[super dealloc];
}

-(void) onEnter {
    [super onEnter];
 
    [self createBackground];
    
    [self createWave];
    
    [self scheduleUpdate];

}

// Creates a simple background gradient.
// This is just a simple example of frawing with OpenGL ES 2.0.
// In one HeyaldaGLDrawNode it is possible to have 10's of thousands of 
// verticies defined and still get good performance. 
-(void)createBackground {

    // Create an instance of the HeyaldaGLDrawNode class and add it to this layer.
    HeyaldaGLDrawNode* glDrawNode = [[[HeyaldaGLDrawNode alloc] init] autorelease];
    [self addChild:glDrawNode];
    
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    NSLog(@"WinSize:%.2f,%.2f", s.width, s.height);
    
#define kShowTriangleStripSkip 0
    
#if kShowTriangleStripSkip

    CGPoint p0 = ccp(0,s.height);
    CGPoint p1 = ccp(0,0);
    CGPoint p2 = ccp(s.width * 0.33, s.height);
    
    // Define the last point twice.
    CGPoint p3 = ccp(s.width * 0.33, 0);
    CGPoint p4 = ccp(s.width * 0.33, 0);
    
    // Define the first point of the next draw object twice to invisibally skip to the next object.
    // This enables batching many objects in one OpenGL ES 2.0 draw call.
    CGPoint p5 = ccp(s.width * 0.66, s.height);
    CGPoint p6 = ccp(s.width * 0.66, s.height);
    
    CGPoint p7 = ccp(s.width * 0.66, 0);
    CGPoint p8 = ccp(s.width, s.height);
    CGPoint p9 = ccp(s.width, 0);

    [glDrawNode addToDynamicVerts2D:p0 withColor:ccc4(0, 100, 200, 255)];
    [glDrawNode addToDynamicVerts2D:p1 withColor:ccc4(0, 100, 200, 255)];
    [glDrawNode addToDynamicVerts2D:p2 withColor:ccc4(0, 100, 200, 255)];
    [glDrawNode addToDynamicVerts2D:p3 withColor:ccc4(0, 100, 200, 255)];
    [glDrawNode addToDynamicVerts2D:p4 withColor:ccc4(0, 100, 200, 255)];
    [glDrawNode addToDynamicVerts2D:p5 withColor:ccc4(0, 100, 200, 255)];
    [glDrawNode addToDynamicVerts2D:p6 withColor:ccc4(0, 100, 200, 255)];
    [glDrawNode addToDynamicVerts2D:p7 withColor:ccc4(0, 100, 200, 255)];
    [glDrawNode addToDynamicVerts2D:p8 withColor:ccc4(0, 100, 200, 255)];
    [glDrawNode addToDynamicVerts2D:p9 withColor:ccc4(0, 100, 200, 255)];

    
#else

    // Define the four corners of the screen
    CGPoint upperLeftCorner = ccp(s.width*5/6, s.height);
    CGPoint lowerLeftCorner = ccp(s.width*5/6, 0);
    CGPoint upperRightCorner = ccp(s.width, s.height);
    CGPoint lowerRightCorner = ccp(s.width,0);
    
    // Create a triangle strip with a counter-clockwise winding.
    [glDrawNode addToDynamicVerts2D:upperLeftCorner withColor:ccc4(0, 100, 200, 255)];
    [glDrawNode addToDynamicVerts2D:lowerLeftCorner withColor:ccc4(0, 200, 100, 255)];
    [glDrawNode addToDynamicVerts2D:upperRightCorner withColor:ccc4(0,100, 200, 255)];
    [glDrawNode addToDynamicVerts2D:lowerRightCorner withColor:ccc4(0,200, 100, 255)];

#endif
    
    // Rednudant because the defualt is kDrawTriangleStrip, but setting it here for this example.
    glDrawNode.glDrawMode = kDrawTriangleStrip; 
    
    // Tell the HeyaldaGLDrawNode that it is ready to draw when it's draw method is called.  
    [glDrawNode setReadyToDrawDynamicVerts:YES];


    CCLabelTTF* heyaldaLabel = [CCLabelTTF labelWithString:@"Heyalda" fontName:@"Helvetica" fontSize:20];
    heyaldaLabel.position = ccp(s.width * 0.5, 20);
    [self addChild:heyaldaLabel z:10];
}

-(void) createWave {
    
    // Create an instance of the HeyaldaGLDrawNode class and add it to this layer.

    self.glWaveNode = [[[HeyaldaGLDrawNode alloc] init] autorelease];
    
    [self addChild:glWaveNode z:1];
    
    // Set parameters that are used to define the shape of the siunsoid wave.
    wavefrequency = 2;
    waveAmplitude = 0;
    wavePhase = 0;
    waveVertCount = 500;
    
    // Set the wave color.
    red = green = blue = 255;
    waveColor = ccc4(red, green,blue, 255);
    
    
    // Set the variables that are used to animate the wave in the update function.
    amplitudeDirection = 1;
    frequencyDirection = 1;
    variableFrequency = wavefrequency;
    variableAmplitude = waveAmplitude;
    

    
    CGSize s = [[CCDirector sharedDirector] winSize];

    // Space the verticies out evenly across the screen for the wave.
    float vertexHorizontalSpacing = s.width / (float)waveVertCount;
    
    // Used to increment to the next vertexX position.
    float currentWaveVertX = 0;
    
    for (NSInteger i=0; i<waveVertCount; i++) {
        
        float time = (float)i;

        float waveX, waveY;

        waveX = currentWaveVertX;
        
        // Create the default sinusoid wave that will be displayed if the wave is not animated.
        waveY = variableAmplitude * sinf(2 * M_PI / (float)waveVertCount * wavefrequency * time + wavePhase) + 0.5 * s.height;

        //NSLog(@"time:%.2f waveAmplitude:%.2f Wave:%.2f,%2.f wavefrequency:%.2f",time, waveAmplitude, waveX, waveY, wavefrequency);
        [glWaveNode addToDynamicVerts2D:ccp(waveX,waveY) withColor:waveColor];

        currentWaveVertX += vertexHorizontalSpacing;
    }


    // Try experimenting with different draw modes to see the effect.
//    glWaveNode.glDrawMode = kDrawPoints; 
    glWaveNode.glDrawMode = kDrawLines; 

    [glWaveNode setReadyToDrawDynamicVerts:YES];

}



-(void) update:(ccTime)dt {
    
    // Setting shouldVaryAmplitude, shouldVaryFrequency and shouldVaryPhase to NO will stop the animation of the wave.
    BOOL shouldVaryAmplitude = YES;
    
    BOOL shouldVaryFrequency = YES;
    
    BOOL shouldVaryPhase = YES;
    
    
    // Changes the wave frequency over time.
    if (shouldVaryFrequency) {
        
        if (frequencyDirection > 0) {
            if (variableFrequency < (wavefrequency+50)) {
                variableFrequency += .5;
            }else {
                frequencyDirection = -1;
            }
            
        }else {
            if (variableFrequency > (wavefrequency) ) {
                variableFrequency -= .1;
            }else {
                frequencyDirection = 1;
            }
        }

    }

    

    // Changes the wave amplitude over time.
    if (shouldVaryAmplitude == YES) {
        if (amplitudeDirection > 0) {
            if (variableAmplitude < 20) {
                variableAmplitude += .1;
            }else {
                amplitudeDirection = -1;
            }
            
        }else {
            if (variableAmplitude > (waveAmplitude + .2)) {
                variableAmplitude -= .1;
            }else {
                amplitudeDirection = 1;
            }
        }
    }

    // Change the wave phase over time.
    if (shouldVaryPhase == YES) {
        wavePhase += .01;
    }
    
    
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    // Space the verticies out evenly across the screen for the wave.
    float vertexHorizontalSpacing = s.width / (float)waveVertCount;
    
    // Used to increment to the next vertexX position.
    float currentWaveVertX = 0;

    for (NSInteger i=0; i<waveVertCount; i++) {

        
        float t = (float)i / (float)waveVertCount;
        float omega = 2 * M_PI * variableFrequency;
        float waveX, waveY;
            

        // For a sine wave, the formula is y(time) = magnitude x sin( 2 x Pi x frequency x time + phase).
        // The 2 x Pi x frequency can be replaced by the angular frequency, omega.
        // By dividing the time by waveVertCount and using the samples the wave is scaled to having the 
        // wavelength of a 1hz signal equal to the width of the screen.
        // Check out Wikipedia for more details on sinusoids http://en.wikipedia.org/wiki/Sinusoid
        waveX = currentWaveVertX;
        waveY = variableAmplitude * (
                                     sinf(omega * t   + wavePhase) 
                                     + sinf(omega * 0.5 * t + wavePhase * 2) 
                                     + sinf(omega * 0.25 * t + wavePhase * 4) 
                                     + sinf(omega * 0.125 * t + wavePhase * 8) 
                                     + sinf(omega * 0.0625 * t + wavePhase * 16) 
                                     + sinf(omega * 0.03125 * t + wavePhase * 32) 
                                     + sinf(omega * 0.015625 * t + wavePhase * 64) 
                                     + sinf(omega * 0.007831 * t + wavePhase * 128)) 
                                     + 0.5 * s.height;
                     
        HeyaldaPoint p = [HeyaldaGLDrawNode hp3x:waveX y:waveY z:0];
        glWaveNode.dynamicVerts[i] = p;
                
        currentWaveVertX += vertexHorizontalSpacing;

#define kWaveWithRandomColors 0 
        
#if kWaveWithRandomColors
        
        red = (GLbyte)(CCRANDOM_0_1() * 255);
        green = (GLbyte)(CCRANDOM_0_1() * 255);
        blue = (GLbyte)(CCRANDOM_0_1() * 255);
        
        glWaveNode.dynamicVertColors[i] = ccc4(red, green, blue, 255);
#endif
        
    }
    
}

@end