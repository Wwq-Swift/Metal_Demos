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
    var quad: Plane!
    override init(device: MTLDevice, size: CGSize) {
        quad = Plane(device: device, imageName: "picture.png", maskImageName: "picture-frame-mask.png")
        super.init(device: device, size: size)
        addChildNode(quad)
    }
}
