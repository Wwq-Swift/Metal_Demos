//
//  Plane.swift
//  Metal_Colorful
//
//  Created by kris.wang on 2018/12/20.
//  Copyright © 2018年 王伟奇. All rights reserved.
//

import simd
// 平面几何
class Plane: Primitive {
    override func buildVertices() {
        vertices = [
            Vertex(position: float3( -1, 1, 0),
                   color: float4(1, 0, 0, 1),
                   texture: float2(0, 1)),
            Vertex(position: float3( -1, -1, 0),
                   color: float4(0, 1, 0, 1),
                   texture: float2(0, 0)),
            Vertex(position: float3( 1, -1, 0),
                   color: float4(0, 0, 1, 1),
                   texture: float2(1, 0)),
            Vertex(position: float3( 1, 1, 0),
                   color: float4(1, 0, 1, 1),
                   texture: float2(1, 1))
        ]
        
        indexs = [
            0,1,2,
            2,3,0
        ]
    }
}
