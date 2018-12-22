//
//  Shader.metal
//  Metal_animate
//
//  Created by kris.wang on 2018/12/17.
//  Copyright © 2018年 王伟奇. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

//跟 Renderer 里结构体的命名要一致
struct Constants {
    float animateBy;
};

/// 顶点输入和输出，  和 外部写的结构保持一致
struct VertexIn {
    float4 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
};

struct VertexOut {
    float4 position [[ position ]];
    float4 color;
};

//处理顶点， 两个参数 一个是顶点个数， 一个是顶点id
//constant 告诉 CPU 现在这个数据是恒定的空间
vertex VertexOut vertex_shader(const VertexIn vertexIn [[ stage_in ]]){
    
    VertexOut vertexOut;
    vertexOut.position = vertexIn.position;
    vertexOut.color = vertexIn.color;
    
    return vertexOut;
}

// 上色
fragment half4 fragment_shader(VertexOut vertexIn [[ stage_in ]]) {
    return half4(vertexIn.color);
}
