SRC_DIR = `pwd`

INC_PATH = -I${LLVM_SRC}/build/include
INC_PATH += -I${LLVM_SRC}/llvm/include
INC_PATH += -I${LLVM_SRC}/mlir/include
INC_PATH += -I${LLVM_SRC}/build/tools/mlir/include
INC_PATH += -I${SRC_DIR}/include
#INC_PATH += -I${LLVM_SRC}/build/tools/mlir/examples/toy/Ch2/include

LIB_PATH = /home/mxd/github/llvm-project/build/lib

ShapeInferenceInterface.h.inc: include/toy/ShapeInferenceInterface.td
	mlir-tblgen -gen-op-interface-decls ${INC_PATH} include/toy/ShapeInferenceInterface.td --write-if-changed -o include/toy/ShapeInferenceOpInterface.h.inc
ShapeInferenceInterface.cpp.inc: include/toy/ShapeInferenceInterface.td
	mlir-tblgen -gen-op-interface-defs ${INC_PATH} include/toy/ShapeInferenceInterface.td --write-if-changed -o include/toy/ShapeInferenceOpInterface.cpp.inc
ToyCombine.inc: mlir/ToyCombine.td ShapeInferenceInterface.h.inc
	mlir-tblgen -gen-rewriters ${INC_PATH} mlir/ToyCombine.td --write-if-changed -o mlir/ToyCombine.inc
Ops.h.inc: include/toy/Ops.td
	mlir-tblgen -gen-op-decls ${INC_PATH} include/toy/Ops.td --write-if-changed -o include/toy/Ops.h.inc 
Ops.cpp.inc: include/toy/Ops.td
	mlir-tblgen -gen-op-defs ${INC_PATH} include/toy/Ops.td --write-if-changed -o include/toy/Ops.cpp.inc 
AST.o: parser/AST.cpp
	g++ -O0 -g ${INC_PATH} -c parser/AST.cpp -o parser/AST.o
Dialect.o: mlir/Dialect.cpp
	g++ -O0 -g ${INC_PATH} -fno-rtti -c mlir/Dialect.cpp -o mlir/Dialect.o
MLIRGen.o: mlir/MLIRGen.cpp Ops.h.inc
	g++ -O0 -g ${INC_PATH} -c mlir/MLIRGen.cpp -o mlir/MLIRGen.o
toyc.o: toyc.cpp Ops.cpp.inc
	g++ -O0 -g ${INC_PATH} -fno-rtti -c toyc.cpp -o toyc.o
ToyCombine.o: mlir/ToyCombine.cpp ToyCombine.inc Ops.h.inc
	g++ -O0 -g ${INC_PATH} -fno-rtti -c mlir/ToyCombine.cpp -o mlir/ToyCombine.o
ShapeInferenceInterface.o: ShapeInferenceInterface.cpp.inc ShapeInferenceInterface.h.inc
	g++ -O0 -g ${INC_PATH} -fno-rtti -c mlir/ShapeInferenceInterface.cpp -o mlir/ShapeInferenceInterface.o
LowerToAffineLoops.o : mlir/LowerToAffineLoops.cpp
	g++ -O0 -g ${INC_PATH} -fno-rtti -c mlir/LowerToAffineLoops.cpp -o mlir/LowerToAffineLoops.o

all: LowerToAffineLoops.o ToyCombine.o AST.o toyc.o Dialect.o MLIRGen.o ShapeInferenceInterface.o
	g++ -O0 -g -fPIC mlir/ShapeInferenceInterface.o mlir/LowerToAffineLoops.o mlir/ToyCombine.o toyc.o parser/AST.o mlir/Dialect.o mlir/MLIRGen.o -o bin/toyc ${LIB_PATH}/libLLVMSupport.a -lpthread ${LIB_PATH}/libMLIRIR.a  ${LIB_PATH}/libMLIRParser.a ${LIB_PATH}/libMLIRSideEffectInterfaces.a  ${LIB_PATH}/libMLIRTransforms.a  ${LIB_PATH}/libMLIRCopyOpInterface.a  ${LIB_PATH}/libMLIRTransformUtils.a  ${LIB_PATH}/libMLIRRewrite.a  ${LIB_PATH}/libMLIRPDLToPDLInterp.a  ${LIB_PATH}/libMLIRPass.a  ${LIB_PATH}/libMLIRAnalysis.a ${LIB_PATH}/libMLIRPDLInterp.a  ${LIB_PATH}/libMLIRPDL.a  ${LIB_PATH}/libMLIRVector.a  ${LIB_PATH}/libMLIRLinalg.a  ${LIB_PATH}/libMLIRParser.a  ${LIB_PATH}/libMLIRDialectUtils.a  ${LIB_PATH}/libMLIRLoopAnalysis.a  ${LIB_PATH}/libMLIRInferTypeOpInterface.a  ${LIB_PATH}/libMLIRSCF.a  ${LIB_PATH}/libMLIRPresburger.a  ${LIB_PATH}/libMLIRAffineEDSC.a  ${LIB_PATH}/libMLIRAffine.a  ${LIB_PATH}/libMLIRLoopLikeInterface.a  ${LIB_PATH}/libMLIRStandard.a  ${LIB_PATH}/libMLIRCallInterfaces.a  ${LIB_PATH}/libMLIRControlFlowInterfaces.a  ${LIB_PATH}/libMLIREDSC.a  ${LIB_PATH}/libMLIRViewLikeInterface.a  ${LIB_PATH}/libMLIRTensor.a  ${LIB_PATH}/libMLIRSideEffectInterfaces.a  ${LIB_PATH}/libLLVMCore.a  ${LIB_PATH}/libLLVMBinaryFormat.a  ${LIB_PATH}/libLLVMRemarks.a  ${LIB_PATH}/libLLVMBitstreamReader.a  ${LIB_PATH}/libMLIRCastInterfaces.a  ${LIB_PATH}/libMLIRVectorInterfaces.a  ${LIB_PATH}/libMLIRIR.a  ${LIB_PATH}/libMLIRSupport.a  ${LIB_PATH}/libLLVMSupport.a  -lrt  -ldl  -lm  ${LIB_PATH}/libLLVMDemangle.a
	rm toyc.o parser/AST.o mlir/*.o
