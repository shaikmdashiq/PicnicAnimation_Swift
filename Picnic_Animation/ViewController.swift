//
//  ViewController.swift
//  Picnic_Animation
//
//  Created by Shaik MD Ashiq on 25/10/14.
//  Copyright (c) 2014 ArtQueen. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var basketTop: UIImageView!
    @IBOutlet weak var basketBottom: UIImageView!
    @IBOutlet weak var fabricTop: UIImageView!
    @IBOutlet weak var fabricBottom: UIImageView!
    @IBOutlet weak var bug: UIImageView!
    
    var isBugDead = false //bool to check whether the bug is dead
    
    let squishPlayer : AVAudioPlayer //initialise the sqish player
    
    //to initialise the audio player and set the path of the file
    
    required init(coder aDecoder: NSCoder) {
        let squishPath = NSBundle.mainBundle().pathForResource("squish", ofType: "caf")
        let squishURL = NSURL(fileURLWithPath: squishPath!)
        squishPlayer = AVAudioPlayer(contentsOfURL: squishURL, error: nil)
        squishPlayer.prepareToPlay()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //to open the basket and the napkins
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.7, delay: 1.0, options: .CurveEaseOut, animations: {
            var basketTopFrame = self.basketTop.frame
            basketTopFrame.origin.y -= basketTopFrame.size.height
            
            var basketBottomFrame = self.basketBottom.frame
            basketBottomFrame.origin.y += basketBottomFrame.size.height
            
            self.basketTop.frame = basketTopFrame
            self.basketBottom.frame = basketBottomFrame
            }, completion: { finished in
                println("Basket doors opened!")
        })
        
        
        UIView.animateWithDuration(1.0, delay: 1.2, options: .CurveEaseOut, animations: {
            var fabricTopFrame=self.fabricTop.frame
            fabricTopFrame.origin.y -= fabricTopFrame.size.height
            
            var fabricBottomFrame = self.fabricBottom.frame
            fabricBottomFrame.origin.y += fabricBottomFrame.size.height
            
            self.fabricTop.frame = fabricTopFrame
            self.fabricBottom.frame=fabricBottomFrame
            }, completion: { finished in println("Napkins opened !")})
        
        moveBugLeft() // to call the chaining animation
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        view.addGestureRecognizer(tap) // to recognize the tap and to call the handleTap func
    }
    
    //chaining animation starts with this..
    //to move the bug in the frame
    
    func moveBugLeft() {
        if isBugDead { return }
        
        UIView.animateWithDuration(0.5,
            delay: 0,
            options: .CurveEaseInOut | .AllowUserInteraction,
            animations: {
                var a=arc4random_uniform(295)
                var b=arc4random_uniform(540)
                var c = CGFloat (a)
                var d =  CGFloat(b);
                self.bug.center = CGPoint(x: c, y: d)
            },
            completion: { finished in
                println("Bug moved left!")
                self.faceBugRight()
        })
    }
    
    func faceBugRight() {
        if isBugDead { return }
        
        UIView.animateWithDuration(0,
            delay: 0.0,
            options: .CurveEaseInOut | .AllowUserInteraction,
            animations: {
                self.bug.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            },
            completion: { finished in
                println("Bug faced right!")
                self.moveBugRight()
        })
    }
    
    
    func moveBugRight() {
        if isBugDead { return }
        UIView.animateWithDuration(0.5,
            delay: 0,
            options: .CurveEaseInOut | .AllowUserInteraction,
            animations: {
                var a=arc4random_uniform(295)
                var b=arc4random_uniform(540)
                var c = CGFloat (a)
                var d =  CGFloat(b);
                self.bug.center = CGPoint(x: c , y: d  )
            },
            completion: { finished in
                println("Bug moved right!")
                self.faceBugLeft()
        })
    }
    
    func faceBugLeft() {  // func to rotate the bug to face left
        if isBugDead { return }
        
        UIView.animateWithDuration(0,
            delay: 0.0,
            options: .CurveEaseInOut | .AllowUserInteraction,
            animations: {
                self.bug.transform = CGAffineTransformMakeRotation(0.0)
            },
            completion: { finished in
                println("Bug faced left!")
                self.moveBugLeft()
        })
    }
    
    //to check whether the bug is tapped ?
    
    func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.locationInView(bug.superview)
        if bug.layer.presentationLayer().frame.contains(tapLocation) {
            println("Bug tapped!")
            
            
            if isBugDead { return }
            isBugDead = true
            squishPlayer.play() // calls the audioplayer
            UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseOut, animations: {
                self.bug.transform = CGAffineTransformMakeScale(1.25, 0.75) // decrease the size of the bug
                }, completion: { finished in
                    UIView.animateWithDuration(1, delay: 1.0, options: nil, animations: {
                        self.bug.alpha = 0.0
                        }, completion: { finished in
                            self.bug.removeFromSuperview()  // remove the bug from the view
                    })
            })
        } else {
            println("Bug not tapped!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

