//
//  CAEAGLLayerViewController.m
//  CALayerSubclassTour
//
//  Created by Scott Gardner on 4/21/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//

#import "ObjC_CAEAGLLayerViewController.h"
@import GLKit;

@interface ObjC_CAEAGLLayerViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewForEAGLLayer;
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) CAEAGLLayer *eaglLayer;
@property (assign, nonatomic) GLuint framebuffer;
@property (assign, nonatomic) GLuint colorRenderBuffer;
@property (assign, nonatomic) GLint framebufferWidth;
@property (assign, nonatomic) GLint framebufferHeight;
@property (strong, nonatomic) GLKBaseEffect *effect;
@end

@implementation ObjC_CAEAGLLayerViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  [EAGLContext setCurrentContext:self.context];
  
  self.eaglLayer = [CAEAGLLayer layer];
  self.eaglLayer.frame = self.viewForEAGLLayer.bounds;
  self.eaglLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking : @NO,
                                        kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8};
  [self.viewForEAGLLayer.layer addSublayer:self.eaglLayer];
  
  self.effect = [GLKBaseEffect new];
  [self setupBuffers];
  [self render];
}

- (void)setupBuffers
{
  glGenFramebuffers(1, &_framebuffer);
  glBindFramebuffer(GL_FRAMEBUFFER, self.framebuffer);
  glGenRenderbuffers(1, &_colorRenderBuffer);
  glBindRenderbuffer(GL_RENDERBUFFER, self.colorRenderBuffer);
  [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.eaglLayer];
  glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_framebufferWidth);
  glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_framebufferHeight);
  glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, self.colorRenderBuffer);
}

- (void)render
{
  glBindFramebuffer(GL_FRAMEBUFFER, self.framebuffer);
  glViewport(0, 0, self.framebufferWidth, self.framebufferHeight);
  
  [self.effect prepareToDraw];
  
  glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT);
  
  GLfloat vertices[] = {
    0.0f, 0.0f, 0.0f,
    -0.5f, -1.0f, 0.0f,
    0.5f, -1.0f, 0.0f,
    0.0f, 0.0f, 0.0f,
    0.5f, -1.0f, 0.0f,
    1.0f, 0.0f, 0.0f,
    0.0f, 0.0f, 0.0f,
    1.0f, 0.0f, 0.0f,
    0.5f, 1.0f, 0.0f,
    0.0f, 0.0f, 0.0f,
    0.5f, 1.0f, 0.0f,
    -0.5f, 1.0f, 0.0f,
    0.0f, 0.0f, 0.0f,
    -0.5f, 1.0f, 0.0f,
    -1.0f, 0.0f, 0.0f,
    0.0f, 0.0f, 0.0f,
    -1.0f, 0.0f, 0.0f,
    -0.5f, -1.0f, 0.0f
  };
  
  GLfloat colors[] = {
    1.0f, 0.0f, 0.0f, 1.0f,
    1.0f, 0.0f, 0.0f, 1.0f,
    1.0f, 0.0f, 0.0f, 1.0f,
    1.0f, 0.0f, 0.0f, 1.0f,
    1.0f, 0.0f, 0.0f, 1.0f,
    1.0f, 0.0f, 0.0f, 1.0f,
    0.0f, 1.0f, 0.0f, 1.0f,
    0.0f, 1.0f, 0.0f, 1.0f,
    0.0f, 1.0f, 0.0f, 1.0f,
    0.0f, 1.0f, 0.0f, 1.0f,
    0.0f, 1.0f, 0.0f, 1.0f,
    0.0f, 1.0f, 0.0f, 1.0f,
    0.0f, 0.0f, 1.0f, 1.0f,
    0.0f, 0.0f, 1.0f, 1.0f,
    0.0f, 0.0f, 1.0f, 1.0f,
    0.0f, 0.0f, 1.0f, 1.0f,
    0.0f, 0.0f, 1.0f, 1.0f,
    0.0f, 0.0f, 1.0f, 1.0f
  };
  
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glEnableVertexAttribArray(GLKVertexAttribColor);
  glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, vertices);
  glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, colors);
  glDrawArrays(GL_TRIANGLES, 0, 18);
  
  glBindRenderbuffer(GL_RENDERBUFFER, self.colorRenderBuffer);
  [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

@end
