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
    
}
