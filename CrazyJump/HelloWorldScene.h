//
//  HelloWorldScene.h
//  presentation
//
//  Created by Bogdan Vladu on 15.03.2011.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "LevelHelperLoader.h"
#import "LevelHelper.h"

// HelloWorld Layer
@interface HelloWorldScene : CCLayer
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    
	LevelHelperLoader* lh;   
    LHSprite *ladaClean;
    LHSprite *muffler;
    CCParticleSmoke *smoke;

    
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
-(void) retrieveRequiredObjects;


@end
