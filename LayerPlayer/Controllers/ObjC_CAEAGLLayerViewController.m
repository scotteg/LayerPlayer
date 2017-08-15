/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

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
