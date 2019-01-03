////
////  Shader.metal
////  Metal_animate
////
////  Created by kris.wang on 2018/12/17.
////  Copyright © 2018年 王伟奇. All rights reserved.
////
//
//#include <metal_stdlib>
//using namespace metal;
//
//struct ModelContants {
//    float4x4 modelViewMatrix;
//};
//
////跟 Renderer 里结构体的命名要一致
//struct Constants {
//    float animateBy;
//};
//
///// 顶点输入和输出，  和 外部写的结构保持一致
//struct VertexIn {
//    float4 position [[ attribute(0) ]];
//    float4 color [[ attribute(1) ]];
//    float2 textureCoordinates [[ attribute(2) ]];
//};
//
//struct VertexOut {
//    float4 position [[ position ]];
//    float4 color;
//    float2 textureCoordinates;
//};
//
////处理顶点， 两个参数 一个是顶点个数， 一个是顶点id
////constant 告诉 CPU 现在这个数据是恒定的空间
//vertex VertexOut vertex_shader(const VertexIn vertexIn [[ stage_in ]],
//                               constant ModelContants &modelContants [[buffer(1)]]){
//
//    VertexOut vertexOut;
//    vertexOut.position = modelContants.modelViewMatrix * vertexIn.position;
//    vertexOut.color = vertexIn.color;
//    vertexOut.textureCoordinates = vertexIn.textureCoordinates;
//
//    return vertexOut;
//}
//
//// 上色
//fragment half4 fragment_shader(VertexOut vertexIn [[ stage_in ]]) {
//    return half4(vertexIn.color);
//}
///// 纹理处理
//fragment half4 textured_fragment(VertexOut vertexIn [[ stage_in ]],
//                                 texture2d<float> texture [[texture(0)]],
//                                 sampler sampler2d [[sampler(0)]]) {
//
////    constexpr sampler defaultSampler;
////    float4 color = texture.sample(defaultSampler, vertexIn.textureCoordinates);
//    /// 设置我们自定义的采样器
//    float4 color = texture.sample(sampler2d, vertexIn.textureCoordinates);
//    if (color.a == 0) {
//        discard_fragment();
//    }
//    return half4(color.r, color.g, color.b, 1);
//
//}
//
//
////处理遮罩方法
//fragment half4 textured_mask_fragment(VertexOut vertexIn [[ stage_in ]],
//                                      texture2d<float> texture [[texture(0)]],
//                                      texture2d<float> maskTexture [[texture(1)]],
//                                      sampler sampler2d [[sampler(0)]]) {
//
//    float4 color = texture.sample(sampler2d, vertexIn.textureCoordinates);
//    float4 maskColor = maskTexture.sample(sampler2d, vertexIn.textureCoordinates);
//
//    //    用透明度来处理遮罩效果 （为什么呢）
//    //    遮罩的图片，大小以外的区域是透明度为 0 ，让渲染的图跳过纹理的处理 产生遮罩的效果。
//    float maskOpcity = maskColor.a;
//    if(maskOpcity == 0)
//        discard_fragment();
//
//    return half4(color.r, color.g, color.b, 1);
//
//}
#include <metal_stdlib>
using namespace metal;

struct ModelConstants {
    float4x4 modelViewMatrix;
    float4 materialColor;
};

struct SceneConstants {
    float4x4 projectionMatrix;
};

struct VertexIn {
    float4 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float2 textureCoordinates [[ attribute(2) ]];
};

struct VertexOut {
    float4 position [[ position ]];
    float4 color;
    float2 textureCoordinates;
    
    float4 materialColor;
};

vertex VertexOut vertex_shader(const VertexIn vertexIn [[ stage_in ]],
                               constant ModelConstants &modelConstants [[ buffer(1) ]],
                               constant SceneConstants &sceneConstants [[ buffer(2) ]]) {
    VertexOut vertexOut;
    float4x4 matrix = sceneConstants.projectionMatrix * modelConstants.modelViewMatrix;
    vertexOut.position = matrix * vertexIn.position;
    vertexOut.color = vertexIn.color;
    vertexOut.materialColor = modelConstants.materialColor;
    vertexOut.textureCoordinates = vertexIn.textureCoordinates;
    return vertexOut;
}

fragment half4 fragment_shader(VertexOut vertexIn [[ stage_in ]]) {
    return half4(vertexIn.color);
}

fragment half4 textured_fragment(VertexOut vertexIn [[ stage_in ]],
                                 sampler sampler2d [[ sampler(0) ]],
                                 texture2d<float> texture [[ texture(0) ]] ) {
    float4 color = texture.sample(sampler2d, vertexIn.textureCoordinates);
    //把顏色上在我們所輸入的模型上
    color = color * vertexIn.materialColor;
    if (color.a == 0.0)
        discard_fragment();
    return half4(color.r, color.g, color.b, 1);
}

fragment half4 textured_mask_fragment(VertexOut vertexIn [[ stage_in ]],
                                      texture2d<float> texture [[ texture(0) ]],
                                      texture2d<float> maskTexture [[ texture(1) ]],
                                      sampler sampler2d [[ sampler(0) ]] ) {
    float4 color = texture.sample(sampler2d, vertexIn.textureCoordinates);
    float4 maskColor = maskTexture.sample(sampler2d, vertexIn.textureCoordinates);
    float maskOpacity = maskColor.a;
    if (maskOpacity < 0.5)
        discard_fragment();
    return half4(color.r, color.g, color.b, 1);
}

fragment half4 fragment_color(VertexOut vertexIn [[ stage_in ]]) {
    return half4(vertexIn.materialColor);
}
