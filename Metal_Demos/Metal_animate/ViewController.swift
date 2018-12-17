//
//  ViewController.swift
//  Metal_animate
//
//  Created by kris.wang on 2018/12/17.
//  Copyright © 2018年 王伟奇. All rights reserved.
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
