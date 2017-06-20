//
//  ViewController.m
//  Runloop
//
//  Created by cuzZLYues on 2017/6/20.
//  Copyright © 2017年 cuzZLYues. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (assign,nonatomic)BOOL finished;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    
    _finished = NO;
    //开辟子线程来添加timer
    NSThread * thread = [[NSThread alloc]initWithBlock:^{
        
        
        NSTimer * timer= [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
        //将timer 添加到Runloop里面！
        //    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
        //    [[NSRunLoop currentRunLoop]addTimer:timer forMode:UITrackingRunLoopMode];
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes]; //占位模式
        //        [[NSRunLoop currentRunLoop]run];\
        
        //获取当前的Runloop
        CFRunLoopRef runloop = CFRunLoopGetCurrent();
        
        //定义context runloop 上下文里面的参数 &CFRetain,&CFRelease是因为runloop不遵循ARC所以要进行retain 和relaese
        
        CFRunLoopObserverContext context  =  {
            0,
            (__bridge void *)(self),
            &CFRetain,
            &CFRelease,
            NULL
        };
        
        // 定义观察者
        static CFRunLoopObserverRef defaultModeObserver;
        
        defaultModeObserver = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &callBack, &context);
        //添加当前的runloop的观察者
        CFRunLoopAddObserver(runloop, defaultModeObserver, kCFRunLoopCommonModes);
        
        
        while (!_finished) {
            
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0001]];
            
        }
        
        NSLog(@"子线程runloop结束了！！");
    }];
    
    [thread start];
    
}

//回调函数

static void callBack(){
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [NSThread exit];
    
    //    _finished = YES;
    
}


- (void)timerMethod{
    
    NSLog(@"come here");
    
    //耗时操作
    
    [NSThread sleepForTimeInterval:1.1];
    static int num = 0;
    
    NSLog(@"%d%@",num,[NSThread currentThread]);
    
    num ++;
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

