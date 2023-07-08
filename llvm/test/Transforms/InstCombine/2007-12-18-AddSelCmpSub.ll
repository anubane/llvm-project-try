; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

define i32 @foo(i32 %a) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:    [[T15:%.*]] = sub i32 99, [[A:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.smax.i32(i32 [[T15]], i32 0)
; CHECK-NEXT:    [[T12:%.*]] = add i32 [[TMP1]], [[A]]
; CHECK-NEXT:    [[T13:%.*]] = add i32 [[T12]], 1
; CHECK-NEXT:    ret i32 [[T13]]
;
  %t15 = sub i32 99, %a
  %t16 = icmp slt i32 %t15, 0
  %smax = select i1 %t16, i32 0, i32 %t15
  %t12 = add i32 %smax, %a
  %t13 = add i32 %t12, 1
  ret i32 %t13
}

define i32 @bar(i32 %a) {
; CHECK-LABEL: @bar(
; CHECK-NEXT:    [[T15:%.*]] = sub i32 99, [[A:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.smax.i32(i32 [[T15]], i32 0)
; CHECK-NEXT:    [[T12:%.*]] = add i32 [[TMP1]], [[A]]
; CHECK-NEXT:    ret i32 [[T12]]
;
  %t15 = sub i32 99, %a
  %t16 = icmp slt i32 %t15, 0
  %smax = select i1 %t16, i32 0, i32 %t15
  %t12 = add i32 %smax, %a
  ret i32 %t12
}