// RUN: %empty-directory(%t)
// RUN: %target-swift-frontend %s -typecheck -module-name Functions -verify -clang-header-expose-decls=has-expose-attr -disable-availability-checking -emit-clang-header-path %t/functions.h

// RUN: cat %s | grep -v _expose > %t/clean.swift
// RUN: %target-swift-frontend %t/clean.swift -typecheck -module-name Functions -clang-header-expose-decls=all-public -disable-availability-checking -emit-clang-header-path %t/header.h
// RUN: %FileCheck %s < %t/header.h

// REQUIRES: concurrency 

// CHECK-NOT: Unsupported
// CHECK: supported

public func supported() {}

@_expose(Cxx) // expected-error {{actor 'ActorClassUnsupported' can not be exposed to C++}}
public actor ActorClassUnsupported {
    public func test() {}
}
