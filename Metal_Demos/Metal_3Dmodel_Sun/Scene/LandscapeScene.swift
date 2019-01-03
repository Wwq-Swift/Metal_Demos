//
//  LandscapeScene.swift
//  Metal_3Dmodel
//
//  Created by kris.wang on 2019/1/3.
//  Copyright © 2019年 王伟奇. All rights reserved.
//

import UIKit

class LandscapeScene: Scene {

    let sun: Model
    
    override init(device: MTLDevice, size: CGSize) {
        
        sun = Model(device: device, modelName: "sun")
//        sun.materialColor = float4(1,1,0,1)
        super.init(device: device, size: size)
        addChildNode(sun)
    }
    
    override func update(deltaTime: Float) {
        
    }
}
