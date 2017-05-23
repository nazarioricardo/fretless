//
//  KeyBoardViewController.swift
//  Fretless
//
//  Created by Ricardo Nazario on 2/22/17.
//  Copyright © 2017 Ricardo Nazario. All rights reserved.
//

import UIKit
import AudioKit

class KeyBoardViewController: UIViewController, KeyBoardDelegate {
    
    let whiteKeyColor = UIColor(red: 225/255, green: 240/255, blue: 239/255, alpha: 1)
    let blackKeyColor = UIColor(red: 18/255, green: 65/255, blue: 62/255, alpha: 1)
    
    let a0 = 27.5
    var attack: Float!
    var release: Float!
    
    var keys: [KeyView] = []
    
    var noteColorIndex: Int = 0
    
    var chosenOctave: Int!
    var chosenNoteInterval: Int!
    
    var selectedIndex: Int!
    var numberOfKeys: Int!
    var maxCutoff: Double!
    var minCutoff: Double!
    
    var waveform: AKTable!
    var oscillator: AKOscillator!
    var peakLimiter: AKPeakLimiter!
    var lowPassFilter: AKKorgLowPassFilter!
    var highPassFilter: AKHighPassFilter!
    var envelope: AKAmplitudeEnvelope!
    
    var lowestFrequency: Float {
        get {
            return calculateFreq(root: Float(a0) * calculateOctave(octave: chosenOctave), halfSteps: Float(chosenNoteInterval))
        }
    }
    
    var keyBoardHeight: CGFloat {
        get {
            return self.view.bounds.height
        }
    }
    
    var endZoneHeight: CGFloat! {
        get {
            return keyBoardHeight / 5
        }
    }
    
    var midZoneHeight: CGFloat! {
        get {
            return keyBoardHeight - endZoneHeight
        }
    }

    // Private
    
    func setUpViews() {
        
        let keyColors: [UIColor] = [
            whiteKeyColor,
            blackKeyColor,
            whiteKeyColor,
            whiteKeyColor,
            blackKeyColor,
            whiteKeyColor,
            blackKeyColor,
            whiteKeyColor,
            whiteKeyColor,
            blackKeyColor,
            whiteKeyColor,
            blackKeyColor
        ]
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let screenXOrigin = screenSize.origin.x
        
        let keyWidth = screenWidth / CGFloat(numberOfKeys)
        let keyHeight = screenHeight
        var xOrigin: CGFloat = screenXOrigin
        
        let keyBoardView = KeyBoardView.init(frame: self.view.frame)
        
        for keyIndex in Int(xOrigin)..<numberOfKeys {
            
            let color = keyColors[noteColorIndex % keyColors.count]
            
            let keyView = KeyView(frame: CGRect(x: xOrigin, y: 0, width: keyWidth, height: keyHeight))
            
            keyView.keyIndex = keyIndex
            keyView.backgroundColor = color
            
            self.view.addSubview(keyView)
            
            noteColorIndex += 1
            xOrigin += keyWidth
        }
                
        keyBoardView.touchViewWidth = keyWidth
        keyBoardView.frequency = lowestFrequency
        keyBoardView.attackTime = Double(attack)
        keyBoardView.releaseTime = Double(release)
        self.view.addSubview(keyBoardView)
        keyBoardView.delegate = self
    }
    
    func calculateFreq(root: Float, halfSteps: Float) -> Float {
        let twelfth = Float(pow(2, 1/Float(12)))
        return root * pow(twelfth, halfSteps)
    }
    
    func calculateOctave(octave: Int) -> Float {
        return Float(pow(Double(2), Double(octave)))
    }
    
    // AudioKit Setup
    
    func setUpSound() {
        
        maxCutoff = 880
        minCutoff = 0
        
        let tableCount: Int = 32768 * 2
                
        switch selectedIndex {
        case 0:
            self.waveform = AKTable(.sine, phase: 0, count: tableCount)
        case 1:
            self.waveform = AKTable(.square, phase: 0, count: tableCount)
        case 2:
            self.waveform = AKTable(.triangle, phase: 0, count: tableCount)
        case 3:
            self.waveform = AKTable(.sawtooth, phase: 0, count: tableCount)
        default:
            self.waveform = AKTable(.sawtooth, phase: 0, count: tableCount)
        }
        
        oscillator = AKOscillator(waveform: waveform)
        oscillator.amplitude = 1
        oscillator.frequency = 440
        
        oscillator.start()
        
        lowPassFilter = AKKorgLowPassFilter(oscillator)
        lowPassFilter.cutoffFrequency = minCutoff
//        lowPassFilter.dryWetMix = 100
        lowPassFilter.start()
        
    
        highPassFilter = AKHighPassFilter(lowPassFilter)
        highPassFilter.cutoffFrequency = oscillator.frequency
        highPassFilter.dryWetMix = 100
        highPassFilter.start()
        
        envelope = AKAmplitudeEnvelope(highPassFilter)
        envelope.attackDuration = Double(attack)
        envelope.decayDuration = 0.1
        envelope.sustainLevel = 1.0
        envelope.releaseDuration = Double(release)

        peakLimiter = AKPeakLimiter(envelope)
        
        peakLimiter.attackTime = 0.001 // Secs
        peakLimiter.decayTime = 0.01 // Secs
         peakLimiter.preGain = -10 // dB
        
        AudioKit.output = peakLimiter

        AudioKit.start()
    }
    
    func endSound() {
        lowPassFilter.stop()
        oscillator.stop()
        AudioKit.stop()
        AudioKit.output = nil
    }
    
    
    // Key Delegate
    
    func xAxis(keyFreq: Float, x: Float) {
        oscillator.frequency = Double(calculateFreq(root: keyFreq, halfSteps: x))
        highPassFilter.cutoffFrequency = oscillator.frequency - 50
        envelope.start()
    }
    
    func yAxis(y: Float) {
        if y > Float(midZoneHeight) {
            lowPassFilter.cutoffFrequency = maxCutoff
        } else {
            lowPassFilter.cutoffFrequency = ((y * (maxCutoff - minCutoff) / Double(midZoneHeight)) + minCutoff)
        }
    }
    
    func stoppedPlaying() {
        envelope.stop()
    }
    
    // Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.gray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        switch chosenNoteInterval {
            case -9:
                noteColorIndex = 3
            case -7:
                noteColorIndex = 5
            case -5:
                noteColorIndex = 7
            case -4:
                noteColorIndex = 8
            case -2:
                noteColorIndex = 10
            case 0:
                noteColorIndex = 0
            case 2:
                noteColorIndex = 2
            default:
                noteColorIndex = 0
        }
        
        setUpViews()
        setUpSound()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for key in keys {
            key.removeFromSuperview()
        }
        endSound()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

