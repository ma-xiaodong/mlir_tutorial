#include "mlir/IR/Matchers.h"
#include "mlir/IR/PatternMatch.h"
#include "toy/Dialect.h"
#include <iostream>
#include <numeric>

using namespace mlir;
using namespace toy;

namespace {
#include "ToyCombine.inc"
}

struct SimplifyRedundantTranspose : public mlir::OpRewritePattern<TransposeOp> {
  SimplifyRedundantTranspose(mlir::MLIRContext *context)
      : OpRewritePattern<TransposeOp>(context, 1) {}

  mlir::LogicalResult
  matchAndRewrite(TransposeOp op, mlir::PatternRewriter &rewriter) const override {
    mlir::Value transposeInput = op.getOperand();
    TransposeOp transposeInputOp = transposeInput.getDefiningOp<TransposeOp>();

    if (!transposeInputOp)
      return failure();

    rewriter.replaceOp(op, {transposeInputOp.getOperand()});
    return success();
  }
};

void TransposeOp::getCanonicalizationPatterns(OwningRewritePatternList &results,
		                              MLIRContext *context) {
  results.insert<SimplifyRedundantTranspose>(context);
}

void ReshapeOp::getCanonicalizationPatterns(OwningRewritePatternList &results,
                                            MLIRContext *context) {
  results.insert<ReshapeReshapeOptPattern, RedundantReshapeOptPattern,
                 FoldConstantReshapeOptPattern>(context);
}
