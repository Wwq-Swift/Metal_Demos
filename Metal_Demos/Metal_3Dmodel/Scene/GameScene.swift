//
//  GameScene.swift
//  Metal_Colorful
//
//  Created by kris.wang on 2018/12/20.
//  Copyright © 2018年 王伟奇. All rights reserved.
//

import UIKit
import MetalKit

class GameScene: Scene {
    var cube: Cube!
    var quad: Plane!
    let mushroom: Model
    override init(device: MTLDevice, size: CGSize) {
        mushroom = Model(device: device, modelName: "mushroom")
        cube = Cube(device: device)
        cube.scale = cube.scale * 0.5// = matrix_float4x4(scaleX: 0.5, y: 0.5, z: 0.5)
        quad = Plane(device: device, imageName: "picture.png")
        super.init(device: device, size: size)
//        addChildNode(quad)
        
//        addChildNode(quad)
//        addChildNode(cube)
        addChildNode(mushroom)
        
   
//        camera.position.y = -1
//        camera.position.x = 1
        camera.position.z = -6
//
//        camera.rotation.x = radians(fromDegrees: -45)
//        camera.rotation.y = radians(fromDegrees: -45)
        
        quad.position.z = -1.0
        quad.position.y = -0.5
    }
    
    override func update(deltaTime: Float) {
        cube.rotation.y += deltaTime
        mushroom.rotation.y += deltaTime
    }
}
