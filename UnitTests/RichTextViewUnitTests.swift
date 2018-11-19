//
//  RichTextViewUnitTests.swift
//  RichTextViewUnitTests
//
//  Created by Ahmed Elkady on 2018-11-08.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import Quick
import Nimble

@testable import RichTextView

class RichTextViewSpec: QuickSpec {
    override func spec() {
        describe("RichTextView") {
            context("Memory leaks") {
                it("successfully deallocates without any retain cycles") {
                    class RichTextViewWithMemoryLeakChecking: RichTextView {
                        var deinitCalled: (() -> Void)?
                        deinit {
                            deinitCalled?()
                        }
                    }
                    var deinitCalled = false
                    
                    var instance: RichTextViewWithMemoryLeakChecking? = RichTextViewWithMemoryLeakChecking(frame: .zero)
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
