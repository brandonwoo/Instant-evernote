//
//  PostViewController.h
//
//  Created by Ng Brandon on 10/05/28.
//  Copyright 2010 Unoh. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PostViewController : UIViewController {
	UITextView *_body;
}

@property(nonatomic,retain) IBOutlet UITextView *body;

- (void submit:(id)sender;

@end
