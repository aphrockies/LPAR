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
    case start = "Tap here to start AR"
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
    
    
    //
    // Support Functions
    //
    

    @IBAction func menuButtonTapped(_ sender: Any) {
        
        print("menuButtonTapped")
        switch arState {
        case .start:
            disableTracking = false
            setSessionConfiguration(pd: ARWorldTrackingConfiguration.PlaneDetection.horizontal, runOPtions: ARSession.RunOptions.resetTracking)
            arState = .stop
            menuButton.setTitle(menuButtonState.stop.rawValue, for: .normal)
            
        case .stop:
            disableTracking = true
            arState = menuButtonState.select
            menuButton.setTitle(menuButtonState.select.rawValue, for: .normal)
            
        case .select:
            arState = menuButtonState.reset
            menuButton.setTitle(menuButtonState.reset.rawValue, for: .normal)
            break
        case .reset:
            disableTracking = false
            arState = .start
            menuButton.setTitle(menuButtonState.start.rawValue, for: .normal)
            resetTapped()
            configuration = ARWorldTrackingConfiguration()
            break
        }
        
    }
    
    func resetTapped() {
        if anchors.count > 0 {
            for index in 0...anchors.count - 1 {
                sceneView.node(for: anchors[index])?.removeFromParentNode()
            }
            anchors.removeAll()
        }
        
        for node in sceneView.scene.rootNode.childNodes {
            node.removeFromParentNode()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: sceneView)
        
        if arState == .select {
            selectExistinPlane(location: location)
        }
        if arState == .reset && anchors.count > 0 {
            let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
            if hitResults.count > 0 {
                let result: ARHitTestResult = hitResults.first!
                
                let newLocation = SCNVector3Make(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
                let newLampNode = lampNode?.clone()
                if let newLampNode = newLampNode {
                    newLampNode.position = newLocation
                    sceneView.scene.rootNode.addChildNode(newLampNode)
                }
            }
        }
    }
    
    func selectExistinPlane(location: CGPoint) {
        let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        if hitResults.count > 0 {
            let result: ARHitTestResult = hitResults.first!
            if let planeAnchor = result.anchor as? ARPlaneAnchor {
                for var index in 0...anchors.count - 1 {
                    if anchors[index].identifier != planeAnchor.identifier {
                        sceneView.node(for: anchors[index])?.removeFromParentNode()
                    }
                    index += 1
                }
                anchors = [planeAnchor]
                setPlaneTexture(node: sceneView.node(for: anchors[0])!)
            }
        }
        
    }
    
    func setPlaneTexture(node: SCNNode) {
        if let geometryNode = node.childNodes.first {
            if node.childNodes.count > 0 {
  //              geometryNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "./art.scnassets/wood.png")
                geometryNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "./art.scnassets/MessMtLion.png")
                
                geometryNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
                geometryNode.geometry?.firstMaterial?.diffuse.wrapS = SCNWrapMode.repeat
                geometryNode.geometry?.firstMaterial?.diffuse.wrapT = SCNWrapMode.repeat
                geometryNode.geometry?.firstMaterial?.diffuse.mipFilter = SCNFilterMode.linear
            }
            arState = menuButtonState.reset
            menuButton.setTitle(menuButtonState.reset.rawValue, for: .normal)
        }
    }
    
}
