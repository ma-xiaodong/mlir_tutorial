
#ifndef SHAPE_INFERENCE_INTERFACE
#define SHAPE_INFERENCE_INTERFACE

include "mlir/IR/OpBase.td"

def ShapeInferenceOpInterface : OpInterface<"ShapeInference"> {
  let description = [{ShapeInferecneOpInterface description.}];
  let methods = [
    InterfaceMethod<"description string", "void", "inferShapes">
  ];
}

#endif
