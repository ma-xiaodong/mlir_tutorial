A whole program that combine the 7 chapters of the mlir tutorials in llvm-project.
Directory content:
|- data. It contains test case of two file types: toy and mlir.
|
|- debug. Temp files used for debug.
|
|- include. All files are in the only sudirectory toy.
   |
   |- AST.h. Different types of AST used for parsing toy file, such as
   |  ExprAST, NumberExprAST, ...
   |
   |- Dialect.h. Define two class in the namespace of mlir::toy:
   |  ToyDialect and StructType. ToyDialect used to register custom
   |  attributes. StructType represents a collection of element types.
   |
   |- Lexer.h. Structures and functions used for parsing the characters in toy
   |  file. The inputs are characters and outputs are tokens.
   |
   |- MLIRGen.h. Declare a function that generating MLIR structure from AST.
   |  The function is defined in MLIRGen.cpp.
   |
   |- Ops.td and two files generated from it: Ops.cpp.inc and Ops.h.inc. Define
   |  different OPs and the arguments, methods of them.
   |
   |- Parser.h. Structures and functions used for parsing the tokens in toy
   |  file. The inputs are tokens and outputs are AST.
   |
   |- Passes.h. Declare two functions: createShapeInferencePass() and
   |  createLowerToAffinePass. The names imply their functionalities.
   |
   |- ShapeInferenceInterface.td and two files generated from it. Declare
   |  ShapeInferenceOpInterface that is a class inherits from Opinterface.
   |  It contains only a function inferShapes that can be implemented
   |  by several dialects.
|
|- mlir. Pargrams converse or transform between different MLIR dialect.
   |
   |- Dialect.cpp.
      |
      |- struct ToyInlinerInterface. Defines the interface for handling inling
      |  with Toy operations.
         |
	     |- Two function isLegalToInlines with different parameters. Both
	     |  return true.
	     |
	     |- handleTerminator. Deal with the return statement in the inlined
	     |  function. The returned values are replaced with some predefined values.
	     |
	     |- materializeCallConversion. Meterialize a conversion for a type
	     |  mismatch between a call and a callable region. The method generate a
	     |  cast op for an input and return a value of the resultType.
         |
      |
	  |- Construction function of class ToyDialect. Firstly add declarations
      |  of different operatons, such as ::mlir::toy::AddOp, ... Secondly,
      |  addInterfaces of ToyInlinerInterface. Thirdly, addTypes of StructType.
      |
      |- ToyDialect::materializeConstant. This function create a ConstantOp or
	  |  StructConstantOp according to the input type, that whether it is a
	  |  StructType.
	  |
	  |- parseBinaryOp. It is parser of AddOp or MulOp.
	  |

