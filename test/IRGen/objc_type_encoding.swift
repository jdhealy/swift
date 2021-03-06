// RUN: rm -rf %t && mkdir %t
// RUN: %build-irgen-test-overlays
// RUN: %target-swift-frontend(mock-sdk: -sdk %S/Inputs -I %t) %s -emit-ir -disable-objc-attr-requires-foundation-module | FileCheck %s -check-prefix=CHECK-%target-os

// REQUIRES: CPU=x86_64
// REQUIRES: objc_interop

import ObjectiveC
import Foundation
import gizmo

@objc protocol P1 {}
@objc protocol P2 {}
@objc protocol P3 {}

@objc class Methods {
  @objc func testSizedUnsignedTypes(_ a: UInt8, b: UInt16, c: UInt32, d: UInt64) {}
// CHECK-macosx: private unnamed_addr constant [20 x i8] c"v36@0:8C16S20I24Q28\00"
// CHECK-ios: private unnamed_addr constant [20 x i8] c"v36@0:8C16S20I24Q28\00"
// CHECK-tvos: private unnamed_addr constant [20 x i8] c"v36@0:8C16S20I24Q28\00"

  @objc func testSizedFloats(_ a: Float32, b: Float64) {}
// CHECK-macosx: private unnamed_addr constant [14 x i8] c"v28@0:8f16d20\00"
// CHECK-ios: private unnamed_addr constant [14 x i8] c"v28@0:8f16d20\00"
// CHECK-tvos: private unnamed_addr constant [14 x i8] c"v28@0:8f16d20\00"

  @objc func testParens(_ a: ((Int))) {}
// CHECK-macosx: private unnamed_addr constant [11 x i8] c"v24@0:8q16\00"
// CHECK-ios: private unnamed_addr constant [11 x i8] c"v24@0:8q16\00"
// CHECK-tvos: private unnamed_addr constant [11 x i8] c"v24@0:8q16\00"

  @objc func testPrimitives(_ b: CBool, i: Int, f: Float, d: Double)
    -> OpaquePointer { return nil }
// CHECK-macosx: private unnamed_addr constant [21 x i8] c"^v40@0:8c16q20f28d32\00"
// CHECK-ios: private unnamed_addr constant [21 x i8] c"^v40@0:8B16q20f28d32\00"
// CHECK-tvos: private unnamed_addr constant [21 x i8] c"^v40@0:8B16q20f28d32\00"

  @objc func testCSignedTypes(_ a: CSignedChar, b: CShort, c: CInt, d: CLong, e: CLongLong) {}
// CHECK-macosx: private unnamed_addr constant [23 x i8] c"v44@0:8c16s20i24q28q36\00"
// CHECK-ios: private unnamed_addr constant [23 x i8] c"v44@0:8c16s20i24q28q36\00"
// CHECK-tvos: private unnamed_addr constant [23 x i8] c"v44@0:8c16s20i24q28q36\00"

  @objc func testCUnsignedTypes(_ a: CUnsignedChar, b: CUnsignedShort, c: CUnsignedInt, d: CUnsignedLong, e: CUnsignedLongLong) {}
// CHECK-macosx: private unnamed_addr constant [23 x i8] c"v44@0:8C16S20I24Q28Q36\00"
// CHECK-ios: private unnamed_addr constant [23 x i8] c"v44@0:8C16S20I24Q28Q36\00"
// CHECK-tvos: private unnamed_addr constant [23 x i8] c"v44@0:8C16S20I24Q28Q36\00"

  @objc func testCChars(_ basic: CChar, wchar wide: CWideChar, char16: CChar16, char32: CChar32) {}
// CHECK-macosx: private unnamed_addr constant [20 x i8] c"v32@0:8c16i20S24i28\00"
// CHECK-ios: private unnamed_addr constant [20 x i8] c"v32@0:8c16i20S24i28\00"
// CHECK-tvos: private unnamed_addr constant [20 x i8] c"v32@0:8c16i20S24i28\00"

  @objc func testCBool(_ a: CBool) {}
// CHECK-macosx: private unnamed_addr constant [11 x i8] c"v20@0:8c16\00"
// CHECK-ios: private unnamed_addr constant [11 x i8] c"v20@0:8B16\00"
// CHECK-tvos: private unnamed_addr constant [11 x i8] c"v20@0:8B16\00"

  @objc func testSizedSignedTypes(_ a: Int8, b: Int16, c: Int32, d: Int64) {}
// CHECK-macosx: private unnamed_addr constant [20 x i8] c"v36@0:8c16s20i24q28\00"
// CHECK-ios: private unnamed_addr constant [20 x i8] c"v36@0:8c16s20i24q28\00"
// CHECK-tvos: private unnamed_addr constant [20 x i8] c"v36@0:8c16s20i24q28\00"

  @objc class func getSelf() -> Methods.Type { return self }
  // CHECK-macosx: private unnamed_addr constant [8 x i8] c"#16@0:8\00"
  // CHECK-ios: private unnamed_addr constant [8 x i8] c"#16@0:8\00"
  // CHECK-tvos: private unnamed_addr constant [8 x i8] c"#16@0:8\00"

  @objc func getDynamicSelf() -> Self { return self }
  // CHECK-macosx: private unnamed_addr constant [8 x i8] c"@16@0:8\00"
  // CHECK-ios: private unnamed_addr constant [8 x i8] c"@16@0:8\00"
  // CHECK-tvos: private unnamed_addr constant [8 x i8] c"@16@0:8\00"

func testId(_ s: AnyObject) -> AnyObject { return self }
// CHECK-macosx: private unnamed_addr constant [11 x i8] c"@24@0:8@16\00"
// CHECK-ios: private unnamed_addr constant [11 x i8] c"@24@0:8@16\00"
// CHECK-tvos: private unnamed_addr constant [11 x i8] c"@24@0:8@16\00"

@objc func comp1(_ a: protocol<P1, P2>, b: protocol<P1, P2, P3>) -> protocol<P1,P2> { return a }
// CHECK-macosx: private unnamed_addr constant [14 x i8] c"@32@0:8@16@24\00"
// CHECK-ios: private unnamed_addr constant [14 x i8] c"@32@0:8@16@24\00"
// CHECK-tvos: private unnamed_addr constant [14 x i8] c"@32@0:8@16@24\00"

@objc func returnsBool(_ b : Bool) -> Bool { return b }
// CHECK-macosx: private unnamed_addr constant [11 x i8] c"c20@0:8c16\00"
// CHECK-ios: private unnamed_addr constant [11 x i8] c"B20@0:8B16\00"
// CHECK-tvos: private unnamed_addr constant [11 x i8] c"B20@0:8B16\00"

@objc func comp1(_ a: Methods, b: Methods, c: Methods) -> Methods { return a }
// CHECK-macosx: private unnamed_addr constant [17 x i8] c"@40@0:8@16@24@32\00"
// CHECK-ios: private unnamed_addr constant [17 x i8] c"@40@0:8@16@24@32\00"
// CHECK-tvos: private unnamed_addr constant [17 x i8] c"@40@0:8@16@24@32\00"

 @objc func passSelector(_ aSelector : Selector) {}
// CHECK-macosx: private unnamed_addr constant [11 x i8] c"v24@0:8:16\00"
// CHECK-ios: private unnamed_addr constant [11 x i8] c"v24@0:8:16\00"
// CHECK-tvos: private unnamed_addr constant [11 x i8] c"v24@0:8:16\00"

@objc func copyUnsafeMutablePointer(_ p: UnsafeMutablePointer<Int32>) -> UnsafeMutablePointer<Int32> { return p }
// CHECK-macosx: private unnamed_addr constant [13 x i8] c"^i24@0:8^i16\00"
// CHECK-ios: private unnamed_addr constant [13 x i8] c"^i24@0:8^i16\00"
// CHECK-tvos: private unnamed_addr constant [13 x i8] c"^i24@0:8^i16\00"

@objc func copyUnsafeMutablePointerInt(_ p: UnsafeMutablePointer<Int>) -> UnsafeMutablePointer<Int> { return p }
// CHECK-macosx: private unnamed_addr constant [13 x i8] c"^q24@0:8^q16\00"
// CHECK-ios: private unnamed_addr constant [13 x i8] c"^q24@0:8^q16\00"
// CHECK-tvos: private unnamed_addr constant [13 x i8] c"^q24@0:8^q16\00"

func testArchetype(_ work: P3) {
}
// CHECK-macosx: private unnamed_addr constant [11 x i8] c"v24@0:8@16\00"
// CHECK-ios: private unnamed_addr constant [11 x i8] c"v24@0:8@16\00"
// CHECK-tvos: private unnamed_addr constant [11 x i8] c"v24@0:8@16\00"

@objc func foo(_ x: Int -> Int) -> Int {
  return 1
}
// CHECK-macosx: private unnamed_addr constant [12 x i8] c"q24@0:8@?16\00"
// CHECK-ios: private unnamed_addr constant [12 x i8] c"q24@0:8@?16\00"
// CHECK-tvos: private unnamed_addr constant [12 x i8] c"q24@0:8@?16\00"

@objc func returnNSRadixedOptions() -> NSRadixedOptions {
    return .octal
  }
// CHECK-macosx: [[ENUMENCODING:@.*]] = private unnamed_addr constant [8 x i8] c"i16@0:8\00"
// CHECK-ios: [[ENUMENCODING:@.*]] = private unnamed_addr constant [8 x i8] c"i16@0:8\00"
// CHECK-tvos: [[ENUMENCODING:@.*]] = private unnamed_addr constant [8 x i8] c"i16@0:8\00"
@objc func returnChoseNSRadixedOptions(_ choice: NSRadixedOptions) -> NSRadixedOptions {
    switch choice {
      case .octal: return .hex
      case .hex: return .octal
    }
  }
// CHECK-macosx: private unnamed_addr constant [11 x i8] c"i20@0:8i16\00"
// CHECK-ios: private unnamed_addr constant [11 x i8] c"i20@0:8i16\00"
// CHECK-tvos: private unnamed_addr constant [11 x i8] c"i20@0:8i16\00"

@objc func getRawEnumInGizmo() -> RawEnumInGizmo {
    return InGizmoTwo
  }
// CHECK-macosx: { i8* getelementptr inbounds ([18 x i8], [18 x i8]* @"\01L_selector_data(getRawEnumInGizmo)", i64 0, i64 0),
// CHECK-macosx: i8* getelementptr inbounds ([8 x i8], [8 x i8]* [[ENUMENCODING]], i64 0, i64 0)
// CHECK-ios: { i8* getelementptr inbounds ([18 x i8], [18 x i8]* @"\01L_selector_data(getRawEnumInGizmo)", i64 0, i64 0),
// CHECK-ios: i8* getelementptr inbounds ([8 x i8], [8 x i8]* [[ENUMENCODING]], i64 0, i64 0)
// CHECK-tvos: { i8* getelementptr inbounds ([18 x i8], [18 x i8]* @"\01L_selector_data(getRawEnumInGizmo)", i64 0, i64 0),
// CHECK-tvos: i8* getelementptr inbounds ([8 x i8], [8 x i8]* [[ENUMENCODING]], i64 0, i64 0)

}

// rdar://16308986
@objc class MyCustomObject {
}

@objc protocol MyProtocol {
	func myMethod2(_ arg : protocol<NSRuncing, NSFunging>)
        func readWithAuthorization(_ authData : Gizmo, reply : (NSView, NSSpoon) -> Void)
        func doSomething(_ context: MyCustomObject)
}

// CHECK-macosx: [[ENC1:@.*]] = private unnamed_addr constant [35 x i8] c"v24@0:8@\22<NSFunging><NSRuncing>\2216\00"
// CHECK-macosx: [[ENC2:@.*]] = private unnamed_addr constant [46 x i8] c"v32@0:8@\22Gizmo\2216@?<v@?@\22NSView\22@\22NSSpoon\22>24\00"
// CHECK-macosx: [[ENC3:@.*]] = private unnamed_addr constant [53 x i8] c"v24@0:8@\22_TtC18objc_type_encoding14MyCustomObject\2216\00"
// CHECK-macosx: @_PROTOCOL_METHOD_TYPES__TtP18objc_type_encoding10MyProtocol_ = private constant { [3 x i8*] } { [3 x i8*] [i8* getelementptr inbounds ([35 x i8], [35 x i8]* [[ENC1]], i64 0, i64 0), i8* getelementptr inbounds ([46 x i8], [46 x i8]* [[ENC2]], i64 0, i64 0), i8* getelementptr inbounds ([53 x i8], [53 x i8]* [[ENC3]], i64 0, i64 0)] }
// CHECK-ios: [[ENC1:@.*]] = private unnamed_addr constant [35 x i8] c"v24@0:8@\22<NSFunging><NSRuncing>\2216\00"
// CHECK-ios: [[ENC2:@.*]] = private unnamed_addr constant [46 x i8] c"v32@0:8@\22Gizmo\2216@?<v@?@\22NSView\22@\22NSSpoon\22>24\00"
// CHECK-ios: [[ENC3:@.*]] = private unnamed_addr constant [53 x i8] c"v24@0:8@\22_TtC18objc_type_encoding14MyCustomObject\2216\00"
// CHECK-ios: @_PROTOCOL_METHOD_TYPES__TtP18objc_type_encoding10MyProtocol_ = private constant { [3 x i8*] } { [3 x i8*] [i8* getelementptr inbounds ([35 x i8], [35 x i8]* [[ENC1]], i64 0, i64 0), i8* getelementptr inbounds ([46 x i8], [46 x i8]* [[ENC2]], i64 0, i64 0), i8* getelementptr inbounds ([53 x i8], [53 x i8]* [[ENC3]], i64 0, i64 0)] }
// CHECK-tvos: [[ENC1:@.*]] = private unnamed_addr constant [35 x i8] c"v24@0:8@\22<NSFunging><NSRuncing>\2216\00"
// CHECK-tvos: [[ENC2:@.*]] = private unnamed_addr constant [46 x i8] c"v32@0:8@\22Gizmo\2216@?<v@?@\22NSView\22@\22NSSpoon\22>24\00"
// CHECK-tvos: [[ENC3:@.*]] = private unnamed_addr constant [53 x i8] c"v24@0:8@\22_TtC18objc_type_encoding14MyCustomObject\2216\00"
// CHECK-tvos: @_PROTOCOL_METHOD_TYPES__TtP18objc_type_encoding10MyProtocol_ = private constant { [3 x i8*] } { [3 x i8*] [i8* getelementptr inbounds ([35 x i8], [35 x i8]* [[ENC1]], i64 0, i64 0), i8* getelementptr inbounds ([46 x i8], [46 x i8]* [[ENC2]], i64 0, i64 0), i8* getelementptr inbounds ([53 x i8], [53 x i8]* [[ENC3]], i64 0, i64 0)] }
