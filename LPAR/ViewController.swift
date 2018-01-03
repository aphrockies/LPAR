//
//  ViewController.swift
//  LPAR
//
//  Created by Allan Hull on 12/23/17.
//  Copyright © 2017 Allan Hull. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

enum menuButtonState: String {
    case start = "Tap hereto start AR"
    case stop = "Stop tracking more planes"
    case select = "Tap plane to select"
    case reset = "Reset"
}

class ViewController: UIViewController {

   
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    var arState = menuButtonState.start
    var scene = SCNScene()
    var configuration = ARWorldTrackingConfiguration()
    
    var planeIdentifiers = [UUID]()
    var anchors = [ARAnchor]()
    var nodes = [SCNNode]()
    var planeNodesCount = 0
    var planeHeight: CGFloat = 0.01
    var disableTracking = false
    var isPlaneSelected = false
    
    var lampNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
 //       let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        self.sceneView.scene = scene
        self.sceneView.autoenablesDefaultLighting = true
        
        // misc scene setup
        self.sceneView.showsStatistics = true
        self.sceneView.autoenablesDefaultLighting = true
        
        // menuButton initialize
        menuButton.setTitle(arState.rawValue , for: .normal)
        
        // coordinate functions & methods
        setUpScenesAndNodes()
    }
    
    //
    // setUp functions
    //
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

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
