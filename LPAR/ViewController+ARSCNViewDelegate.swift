//
//  ViewController+ARSCNViewDelegate.swift
//  LPAR
//
//  Created by Allan Hull on 1/2/18.
//  Copyright © 2018 Allan Hull. All rights reserved.
//

import ARKit

extension ViewController: ARSCNViewDelegate, ARSessionDelegate {
    
    func setUpScenesAndNodes() {
        
        let tempScene = SCNScene(named: "art.scnassets/cyclinder.scn")
        lampNode = tempScene?.rootNode.childNode(withName: "Cylinder", recursively: true)
        
    }
    
    //
    // session setup functions
    //
    
    func setSessionConfiguration(pd : ARWorldTrackingConfiguration.PlaneDetection,
                                 runOPtions: ARSession.RunOptions) {
        //currenly only planeDetection available is horizontal.
        configuration.planeDetection = pd
        sceneView.session.run(configuration, options: runOPtions)
    }
    
    //
    // AR render functions
    //
    
    /*Implement this to provide a custom node for the given anchor.
     
     @discussion This node will automatically be added to the scene graph.
     If this method is not implemented, a node will be automatically created.
     If nil is returned the anchor will be ignored.
     @param renderer The renderer that will render the scene.
     @param anchor The added anchor.
     @return Node that will be mapped to the anchor or nil.
     */
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if disableTracking {
            return nil
        }
        var node:  SCNNode?
        if let planeAnchor = anchor as? ARPlaneAnchor {
            node = SCNNode()
            //            let planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            let planeGeometry = SCNBox(width: CGFloat(planeAnchor.extent.x), height: planeHeight, length: CGFloat(planeAnchor.extent.z), chamferRadius: 0.0)
            planeGeometry.firstMaterial?.diffuse.contents = UIColor.green
            planeGeometry.firstMaterial?.specular.contents = UIColor.white
            let planeNode = SCNNode(geometry: planeGeometry)
            planeNode.position = SCNVector3Make(planeAnchor.center.x, Float(planeHeight / 2), planeAnchor.center.z)
            //            since SCNPlane is vertical, needs to be rotated -90 degress on X axis to make a plane
            //            planeNode.transform = SCNMatrix4MakeRotation(Float(-CGFloat.pi/2), 1, 0, 0)
            node?.addChildNode(planeNode)
            anchors.append(planeAnchor)
            
        } else {
            // haven't encountered this scenario yet
            print("not plane anchor \(anchor)")
        }
        return node
    }
    
    
    
    
    
    
}
