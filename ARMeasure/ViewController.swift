//
//  ViewController.swift
//  ARMeasure
//
//  Created by Syed Askari on 8/7/17.
//  Copyright © 2017 Syed Askari. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var notReadyLabel: UILabel!
    @IBOutlet weak var aimLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    
    let session: ARSession = ARSession()
    let vectorZero: SCNVector3 = SCNVector3()
    let sessionConfig: ARSessionConfiguration = ARWorldTrackingSessionConfiguration()
    var measuring = false
    var startValue = SCNVector3()
    var endValue = SCNVector3()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.session = session
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        session.run(sessionConfig, options: [.resetTracking, .removeExistingAnchors])
        
        resetValues()
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    func resetValues() {
        measuring = false
        startValue = SCNVector3()
        endValue =  SCNVector3()
        
        updateResultLabel(0.0)
    }
    
    func updateResultLabel(_ value: Float) {
        let cm = value * 100.0
        let inch = cm*0.3937007874
        resultLabel.text = String(format: "%.2f cm / %.2f\"", cm, inch)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.detectObjects()
        }
    }
    
    func detectObjects() {
        if let worldPos = sceneView.realWorldVector(screenPos: view.center) {
            aimLabel.isHidden = false
            notReadyLabel.isHidden = true
            if measuring {
                if startValue == vectorZero {
                    startValue = worldPos
                }
                
                endValue = worldPos
                updateResultLabel(startValue.distance(from: endValue))
            }
        }
    }
    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetValues()
        measuring = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        measuring = false
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
