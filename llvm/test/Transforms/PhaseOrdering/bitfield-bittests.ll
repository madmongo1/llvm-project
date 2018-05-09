; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -O3 -S < %s                    | FileCheck %s
; RUN: opt -passes='default<O3>' -S < %s  | FileCheck %s

; These are tests that check for set/clear bits in a bitfield based on PR37098:
; https://bugs.llvm.org/show_bug.cgi?id=37098
;
; The initial IR from clang has been transformed by SROA, but no other passes
; have run yet. In all cases, we should reduce these to a mask and compare
; instead of shift/cast/logic ops.
;
; Currently, this happens mostly through a combination of instcombine and
; aggressive-instcombine. If pass ordering changes, we may have to adjust
; the pattern matching in 1 or both of those passes.

; Legal i32 is required to allow casting transforms that eliminate the zexts.
target datalayout = "n32"

define i32 @allclear(i32 %a) {
; CHECK-LABEL: @allclear(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[A:%.*]], 15
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq i32 [[TMP1]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = zext i1 [[TMP2]] to i32
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %a.sroa.0.0.trunc = trunc i32 %a to i8
  %a.sroa.5.0.shift = lshr i32 %a, 8
  %bf.clear = and i8 %a.sroa.0.0.trunc, 1
  %bf.cast = zext i8 %bf.clear to i32
  %bf.lshr = lshr i8 %a.sroa.0.0.trunc, 1
  %bf.clear2 = and i8 %bf.lshr, 1
  %bf.cast3 = zext i8 %bf.clear2 to i32
  %or = or i32 %bf.cast, %bf.cast3
  %bf.lshr5 = lshr i8 %a.sroa.0.0.trunc, 2
  %bf.clear6 = and i8 %bf.lshr5, 1
  %bf.cast7 = zext i8 %bf.clear6 to i32
  %or8 = or i32 %or, %bf.cast7
  %bf.lshr10 = lshr i8 %a.sroa.0.0.trunc, 3
  %bf.clear11 = and i8 %bf.lshr10, 1
  %bf.cast12 = zext i8 %bf.clear11 to i32
  %or13 = or i32 %or8, %bf.cast12
  %cmp = icmp eq i32 %or13, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @anyset(i32 %a) {
; CHECK-LABEL: @anyset(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[A:%.*]], 15
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i32 [[TMP1]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = zext i1 [[TMP2]] to i32
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %a.sroa.0.0.trunc = trunc i32 %a to i8
  %a.sroa.5.0.shift = lshr i32 %a, 8
  %bf.clear = and i8 %a.sroa.0.0.trunc, 1
  %bf.cast = zext i8 %bf.clear to i32
  %bf.lshr = lshr i8 %a.sroa.0.0.trunc, 1
  %bf.clear2 = and i8 %bf.lshr, 1
  %bf.cast3 = zext i8 %bf.clear2 to i32
  %or = or i32 %bf.cast, %bf.cast3
  %bf.lshr5 = lshr i8 %a.sroa.0.0.trunc, 2
  %bf.clear6 = and i8 %bf.lshr5, 1
  %bf.cast7 = zext i8 %bf.clear6 to i32
  %or8 = or i32 %or, %bf.cast7
  %bf.lshr10 = lshr i8 %a.sroa.0.0.trunc, 3
  %bf.clear11 = and i8 %bf.lshr10, 1
  %bf.cast12 = zext i8 %bf.clear11 to i32
  %or13 = or i32 %or8, %bf.cast12
  %cmp = icmp ne i32 %or13, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

; FIXME: aggressive-instcombine does not match this yet.

define i32 @allset(i32 %a) {
; CHECK-LABEL: @allset(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[A:%.*]], 15
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq i32 [[TMP1]], 15
; CHECK-NEXT:    [[TMP3:%.*]] = zext i1 [[TMP2]] to i32
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %a.sroa.0.0.trunc = trunc i32 %a to i8
  %a.sroa.5.0.shift = lshr i32 %a, 8
  %bf.clear = and i8 %a.sroa.0.0.trunc, 1
  %bf.cast = zext i8 %bf.clear to i32
  %bf.lshr = lshr i8 %a.sroa.0.0.trunc, 1
  %bf.clear2 = and i8 %bf.lshr, 1
  %bf.cast3 = zext i8 %bf.clear2 to i32
  %and = and i32 %bf.cast, %bf.cast3
  %bf.lshr5 = lshr i8 %a.sroa.0.0.trunc, 2
  %bf.clear6 = and i8 %bf.lshr5, 1
  %bf.cast7 = zext i8 %bf.clear6 to i32
  %and8 = and i32 %and, %bf.cast7
  %bf.lshr10 = lshr i8 %a.sroa.0.0.trunc, 3
  %bf.clear11 = and i8 %bf.lshr10, 1
  %bf.cast12 = zext i8 %bf.clear11 to i32
  %and13 = and i32 %and8, %bf.cast12
  %cmp = icmp ne i32 %and13, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

; FIXME: aggressive-instcombine does not match this yet.

define i32 @anyclear(i32 %a) {
; CHECK-LABEL: @anyclear(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[A:%.*]], 15
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i32 [[TMP1]], 15
; CHECK-NEXT:    [[TMP3:%.*]] = zext i1 [[TMP2]] to i32
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %a.sroa.0.0.trunc = trunc i32 %a to i8
  %a.sroa.5.0.shift = lshr i32 %a, 8
  %bf.clear = and i8 %a.sroa.0.0.trunc, 1
  %bf.cast = zext i8 %bf.clear to i32
  %bf.lshr = lshr i8 %a.sroa.0.0.trunc, 1
  %bf.clear2 = and i8 %bf.lshr, 1
  %bf.cast3 = zext i8 %bf.clear2 to i32
  %and = and i32 %bf.cast, %bf.cast3
  %bf.lshr5 = lshr i8 %a.sroa.0.0.trunc, 2
  %bf.clear6 = and i8 %bf.lshr5, 1
  %bf.cast7 = zext i8 %bf.clear6 to i32
  %and8 = and i32 %and, %bf.cast7
  %bf.lshr10 = lshr i8 %a.sroa.0.0.trunc, 3
  %bf.clear11 = and i8 %bf.lshr10, 1
  %bf.cast12 = zext i8 %bf.clear11 to i32
  %and13 = and i32 %and8, %bf.cast12
  %cmp = icmp eq i32 %and13, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

