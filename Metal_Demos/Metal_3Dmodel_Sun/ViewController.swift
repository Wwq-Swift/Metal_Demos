//
//  ViewController.swift
//  Metal_3Dmodel_Sun
//
//  Created by kris.wang on 2019/1/3.
//  Copyright © 2019年 王伟奇. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
    private var metalView: MTKView!
    private var renderer: Renderer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let mView = view as? MTKView else {
            return
        }
        metalView = mView
        metalView.device = MTLCreateSystemDefaultDevice()
        renderer = Renderer(device: metalView.device!)
        metalView.delegate = renderer
        metalView.clearColor = MTLClearColor(red: 0.0, green: 0.4, blue: 0.0, alpha: 1.0)
        /// XCOde 9 之后一定要写对应的单位，否则直接d闪退
        metalView.depthStencilPixelFormat = .depth32Float
        
        renderer?.scene = LandscapeScene(device: metalView.device!, size: view.bounds.size)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

