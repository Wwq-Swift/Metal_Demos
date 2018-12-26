//
//  Camera.swift
//  Metal_3D_Camera
//
//  Created by 王伟奇 on 2018/12/26.
//  Copyright © 2018 王伟奇. All rights reserved.
//

import MetalKit

class Camera: Node {
    
    // 相机矩阵，   视口矩阵
    var viewMartrix: matrix_float4x4 {
        return modelMatrix
    }
    /// 视角 角度
    var fovDegrees: Float = 65
    /// 角度转弧度
    var fovRadians: Float {
        return radians(fromDegrees: fovDegrees)
    }
    
    var aspect: Float = 1
    var nearZ: Float = 0.1
    var farZ: Float = 100.0
    
    var projectionMatrix: matrix_float4x4{
        
        return matrix_float4x4(projectionFov: fovRadians,
                               aspect: aspect,
                               nearZ: nearZ,
                               farZ: farZ
        )
    }
}
