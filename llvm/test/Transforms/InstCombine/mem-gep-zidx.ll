; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=instcombine < %s | FileCheck %s
target datalayout = "E-m:e-i64:64-n32:64"
target triple = "powerpc64-unknown-linux-gnu"

@f.a = private unnamed_addr constant [1 x i32] [i32 12], align 4
@f.b = private unnamed_addr constant [1 x i32] [i32 55], align 4
@f.c = linkonce unnamed_addr alias [1 x i32], ptr @f.b

define signext i32 @test1(i32 signext %x) #0 {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret i32 12
;
  %idxprom = sext i32 %x to i64
  %arrayidx = getelementptr inbounds [1 x i32], ptr @f.a, i64 0, i64 %idxprom
  %r = load i32, ptr %arrayidx, align 4
  ret i32 %r
}

declare void @foo(ptr %p)
define void @test2(i32 signext %x, i64 %v) #0 {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[P:%.*]] = alloca i64, align 8
; CHECK-NEXT:    store i64 [[V:%.*]], ptr [[P]], align 8
; CHECK-NEXT:    call void @foo(ptr nonnull [[P]]) #1
; CHECK-NEXT:    ret void
;
  %p = alloca i64
  %idxprom = sext i32 %x to i64
  %arrayidx = getelementptr inbounds i64, ptr %p, i64 %idxprom
  store i64 %v, ptr %arrayidx
  call void @foo(ptr %p)
  ret void
}

define signext i32 @test3(i32 signext %x, i1 %y) #0 {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[R:%.*]] = select i1 [[Y:%.*]], i32 12, i32 55
; CHECK-NEXT:    ret i32 [[R]]
;
  %idxprom = sext i32 %x to i64
  %p = select i1 %y, ptr @f.a, ptr @f.b
  %arrayidx = getelementptr inbounds [1 x i32], ptr %p, i64 0, i64 %idxprom
  %r = load i32, ptr %arrayidx, align 4
  ret i32 %r
}

define signext i32 @test4(i32 signext %x, i1 %y) #0 {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[IDXPROM:%.*]] = sext i32 [[X:%.*]] to i64
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [1 x i32], ptr @f.c, i64 0, i64 [[IDXPROM]]
; CHECK-NEXT:    [[R:%.*]] = load i32, ptr [[ARRAYIDX]], align 4
; CHECK-NEXT:    ret i32 [[R]]
;
  %idxprom = sext i32 %x to i64
  %arrayidx = getelementptr inbounds [1 x i32], ptr @f.c, i64 0, i64 %idxprom
  %r = load i32, ptr %arrayidx, align 4
  ret i32 %r
}

attributes #0 = { nounwind readnone }
