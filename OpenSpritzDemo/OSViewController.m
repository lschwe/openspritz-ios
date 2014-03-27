//
//  OSViewController.m
//  OpenSpritzDemo
//
//  Created by Francesco Mattia on 07/03/14.
//  Copyright (c) 2014 Fr4ncis. All rights reserved.
//

#import "OSViewController.h"
#import "OSSpritzLabel.h"

@interface OSViewController () {
    OSSpritzLabel *osLabel;
    IBOutlet UILabel *wpmLabel;
    __weak IBOutlet UITextView *textView;
}

@end

@implementation OSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    osLabel = [[OSSpritzLabel alloc] initWithFrame:CGRectMake(0, 50, 320.0f, 40)];
    osLabel.text = textView.text;
    [self.view addSubview:osLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startButtonPressed:(id)sender {
    osLabel.text = textView.text;
    [osLabel start];
}
- (IBAction)stopButtonPressed:(id)sender {
    [osLabel pause];
}

- (IBAction)sliderValue:(UISlider*)sender {
    [osLabel setWordsPerMinute:round(sender.value)];
    wpmLabel.text = [@(osLabel.wordsPerMinute) stringValue];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if ([textView isFirstResponder]) {
        if (!CGRectContainsPoint(textView.frame, [touch locationInView:self.view])) {
            [textView resignFirstResponder];
        }
    }
}


@end
