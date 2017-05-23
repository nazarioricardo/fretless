//
//  BaseViewController.swift
//  Fretless
//
//  Created by Ricardo Nazario on 2/24/17.
//  Copyright © 2017 Ricardo Nazario. All rights reserved.
//

import UIKit
import AudioKit

class BaseViewController: UIViewController {
    
    var keyboardVC: KeyBoardViewController!
    
    @IBOutlet weak var waveformPicker: SegmentedController!
    @IBOutlet weak var notePicker: SegmentedController!
    @IBOutlet weak var octavePicker: SegmentedController!
    
    @IBOutlet weak var rangeSlider: UISlider!
    @IBOutlet weak var attackSlider: UISlider!
    @IBOutlet weak var releaseSlider: UISlider!

    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var rangeIndicatorLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    
    var octaveMultiplier: Int!
    var keys: Int {
        get {
            return Int(rangeSlider.value)
        }
    }
    
    var notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    
    var lowest: String {
        get {
            return notePicker.items[notePicker.selectedIndex]
        }
    }
    var octave: String {
        get {
            return octavePicker.items[octavePicker.selectedIndex]
        }
    }
    var highest: String {
        get {
            return notes[((notes.index(of: notePicker.items[notePicker.selectedIndex])! + (keys - 1)) % notes.count)]
        }
    }
    var highOct: String {
        get {
            return String(octavePicker.selectedIndex + (keys/12) % notes.count)
        }
    }
    
    @IBAction func notePickerChanged(_ sender: Any) {
        updateRangeIndicator()
    }
    
    @IBAction func octaveSliderChanged(_ sender: Any) {
        octaveMultiplier = Int(self.octavePicker.selectedIndex)
        updateRangeIndicator()
    }
    
    @IBAction func rangeSliderChanged(_ sender: Any) {
        rangeLabel.text = String(keys)
        updateRangeIndicator()
    }
    
    @IBAction func attackSliderChanged(_ sender: Any) {
        attackLabel.text = String(attackSlider.value)
    }
    
    @IBAction func releaseSliderChanged(_ sender: Any) {
        releaseLabel.text = String(releaseSlider.value)
    }
    
    func updateRangeIndicator() {
        
        rangeIndicatorLabel.text = "\(lowest)\(octave) - \(highest)\(highOct)"
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition:
            {(context: UIViewControllerTransitionCoordinatorContext) in
            
            if UIDevice.current.orientation.isPortrait {
                self.keyboardVC.dismiss(animated: true, completion: nil)
            }
        },
                            completion:
            { (context: UIViewControllerTransitionCoordinatorContext) in
                
                self.keyboardVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "KeyBoardViewController") as! KeyBoardViewController
                
                if UIDevice.current.orientation.isLandscape {
                                    
                    self.keyboardVC.chosenOctave = self.octaveMultiplier
                                    
                    switch self.notePicker.selectedIndex {
                        case 0:
                            self.keyboardVC.chosenNoteInterval = -9
                        case 1:
                            self.keyboardVC.chosenNoteInterval = -7
                        case 2:
                            self.keyboardVC.chosenNoteInterval = -5
                        case 3:
                            self.keyboardVC.chosenNoteInterval = -4
                        case 4:
                            self.keyboardVC.chosenNoteInterval = -2
                        case 5:
                            self.keyboardVC.chosenNoteInterval = 0
                        case 6:
                            self.keyboardVC.chosenNoteInterval = 2
                        default:
                            self.keyboardVC.chosenNoteInterval = 0
                    }
                    
                    self.keyboardVC.modalTransitionStyle = .crossDissolve
                    self.keyboardVC.selectedIndex = self.waveformPicker.selectedIndex
                    self.keyboardVC.numberOfKeys = Int(self.rangeSlider.value)
                    self.keyboardVC.attack = self.attackSlider.value
                    self.keyboardVC.release = self.releaseSlider.value
                    
                    self.present(self.keyboardVC, animated: true, completion: nil)
                }
            })
    }
    
    func addGradient() {
        
        let gradient = CAGradientLayer()
        
        let topColor = UIColor.white.withAlphaComponent(0.0)
        let botColor = UIColor.white.withAlphaComponent(0.3)
        gradient.colors = [topColor.cgColor, botColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0)
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.bounds.height, height: self.view.bounds.height)
        
        self.view.layer.insertSublayer(gradient, above: self.view.layer.sublayers?.last)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 225/255, green: 240/255, blue: 239/255, alpha: 1)
        
        waveformPicker.items = ["Sine","Triangle","Square","Saw"]
        notePicker.items = ["C","D","E","F","G","A","B"]
        octavePicker.items = ["0", "1", "2", "3", "4", "5"]
        
        rangeIndicatorLabel.clipsToBounds = true
        rangeIndicatorLabel.layer.cornerRadius = rangeIndicatorLabel.frame.height / 2
        
        octaveMultiplier = Int(self.octavePicker.selectedIndex)
        attackLabel.text = String(self.attackSlider.value)
        releaseLabel.text = String(self.releaseSlider.value)
        waveformPicker.selectedIndex = 3
        notePicker.selectedIndex = 5
        octavePicker.selectedIndex = 3
        Audiobus.start()
        addGradient()
        updateRangeIndicator()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
