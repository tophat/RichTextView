//
//  RichWebViewGeneratorSpec.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-19.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import Quick
import Nimble

@testable import RichTextView

class RichWebViewGeneratorSpec: QuickSpec {
    override func spec() {
        describe("RichWebViewGenerator") {
            context("Memory leaks") {
                it("successfully deallocates without any retain cycles") {
                    class RichWebViewGeneratorWithMemoryLeakChecking: RichWebViewGenerator {
                        var deinitCalled: (() -> Void)?
                        deinit {
                            deinitCalled?()
                        }
                    }
                    var deinitCalled = false
                    
                    var instance: RichWebViewGeneratorWithMemoryLeakChecking? = RichWebViewGeneratorWithMemoryLeakChecking()
                    instance?.deinitCalled = {
                        deinitCalled = true
                    }
                    DispatchQueue.global(qos: .background).async {
                        instance = nil
                    }
                    
                    expect(deinitCalled).toEventually(beTrue(), timeout: 5)
                }
            }
        }
    }
}
