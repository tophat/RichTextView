//
//  RichLabelGeneratorSpec.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-19.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import Quick
import Nimble

@testable import RichTextView

class RichLabelGeneratorSpec: QuickSpec {
    override func spec() {
        describe("RichLabelGenerator") {
            context("Memory leaks") {
                it("successfully deallocates without any retain cycles") {
                    class RichLabelGeneratorWithMemoryLeakChecking: RichLabelGenerator {
                        var deinitCalled: (() -> Void)?
                        deinit {
                            deinitCalled?()
                        }
                    }
                    var deinitCalled = false
                    
                    var instance: RichLabelGeneratorWithMemoryLeakChecking? = RichLabelGeneratorWithMemoryLeakChecking()
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
