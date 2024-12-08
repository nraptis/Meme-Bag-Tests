//
//  MemeBagTestTests.swift
//  MemeBagTestTests
//
//  Created by Nicky Taylor on 12/8/24.
//

import Testing
@testable import MemeBagTest

struct MemeBagTestTests {
    
    class Objeqt {
        let value: Int
        init(value: Int) {
            self.value = value
        }
        
    }

    @Test func testCaseB_1() {
        
        //     Snapshot: TouchA (50, 50), TouchB (100, 50), TouchC (150, 50)
        //     Reconcile TouchB(110, 50), TouchA(60, 50)
        //     In this scenario, we would want to
        //       1.) Remove touch C, re-align from TouchA and TouchB previous locations.
        //       2.) Register the movement of TouchA and TouchB (in that order)
        //     This we call "Remove Touch Flow" (This is a common event...)
        
        let memeBag = Animus2TouchMemeBag(format: .grab)
        
        let objectA = Objeqt(value: 0)
        let objectB = Objeqt(value: 0)
        let objectC = Objeqt(value: 0)
        
        let fakeIdA = ObjectIdentifier(objectA)
        let fakeIdB = ObjectIdentifier(objectB)
        let fakeIdC = ObjectIdentifier(objectC)
        
        
        let memeBeforeA = Animus2TouchMeme(x: 50, y: 50, touchID: fakeIdA)
        memeBag.beforeMemesAdd(memeBeforeA)
        
        let memeBeforeB = Animus2TouchMeme(x: 100, y: 50, touchID: fakeIdB)
        memeBag.beforeMemesAdd(memeBeforeB)
        
        let memeBeforeC = Animus2TouchMeme(x: 150, y: 50, touchID: fakeIdC)
        memeBag.beforeMemesAdd(memeBeforeC)
        
        let memeAfterA = Animus2TouchMeme(x: 60, y: 50, touchID: fakeIdA)
        memeBag.afterMemesAdd(memeAfterA)
        
        let memeAfterB = Animus2TouchMeme(x: 110, y: 50, touchID: fakeIdB)
        memeBag.afterMemesAdd(memeAfterB)
        
        memeBag.bussOutCommandz()
        
        print("====== B-1 ======")
        
        memeBag.printCommands()
    }
    
    @Test func testCaseB_2() {
        
        //     Snapshot: TouchA (50, 50), TouchB (100, 50), TouchC (150, 50)
        //     Reconcile TouchB(110, 50), TouchA(60, 50)
        //     In this scenario, we would want to
        //       1.) Remove touch C, re-align from TouchA and TouchB previous locations.
        //       2.) Register the movement of TouchA and TouchB (in that order)
        //     This we call "Remove Touch Flow" (This is a common event...)
        
        let memeBag = Animus2TouchMemeBag(format: .grab)
        
        let objectA = Objeqt(value: 0)
        let objectB = Objeqt(value: 0)
        let objectC = Objeqt(value: 0)
        
        let fakeIdA = ObjectIdentifier(objectA)
        let fakeIdB = ObjectIdentifier(objectB)
        let fakeIdC = ObjectIdentifier(objectC)
        
        
        let memeAfterB = Animus2TouchMeme(x: 110, y: 50, touchID: fakeIdB)
        memeBag.afterMemesAdd(memeAfterB)
        
        let memeAfterA = Animus2TouchMeme(x: 60, y: 50, touchID: fakeIdA)
        memeBag.afterMemesAdd(memeAfterA)
        
        let memeBeforeB = Animus2TouchMeme(x: 100, y: 50, touchID: fakeIdB)
        memeBag.beforeMemesAdd(memeBeforeB)
        
        let memeBeforeC = Animus2TouchMeme(x: 150, y: 50, touchID: fakeIdC)
        memeBag.beforeMemesAdd(memeBeforeC)
        
        let memeBeforeA = Animus2TouchMeme(x: 50, y: 50, touchID: fakeIdA)
        memeBag.beforeMemesAdd(memeBeforeA)
        
        memeBag.bussOutCommandz()
        
        print("====== B-2 ======")
        
        memeBag.printCommands()
    }
    
    @Test func testCaseA_1() {
        
        //     Snapshot: TouchA (50, 50)
        //     Reconcile TouchA(60, 50), TouchB(100, 50)
        //
        //     In this scenario, we would want to
        //       1.) Register the movement of TouchA, ignoring TouchB
        //       2.) Re-align for TouchA and TouchB "starting" with new TuchA. (in that order)
        //     This we call "Add Touch Flow" (This is a common event...)
        
        let memeBag = Animus2TouchMemeBag(format: .grab)
        
        let objectA = Objeqt(value: 0)
        let objectB = Objeqt(value: 0)
        
        let fakeIdA = ObjectIdentifier(objectA)
        let fakeIdB = ObjectIdentifier(objectB)
        
        let memeBeforeA = Animus2TouchMeme(x: 50, y: 50, touchID: fakeIdA)
        memeBag.beforeMemesAdd(memeBeforeA)
        
        let memeAfterA = Animus2TouchMeme(x: 60, y: 50, touchID: fakeIdA)
        memeBag.afterMemesAdd(memeAfterA)
        
        let memeAfterB = Animus2TouchMeme(x: 100, y: 50, touchID: fakeIdB)
        memeBag.afterMemesAdd(memeAfterB)
        
        memeBag.bussOutCommandz()
        
        print("====== A-1 ======")
        
        memeBag.printCommands()
    }
    
    @Test func testCaseA_2() {
        
        //     Snapshot: TouchA (50, 50)
        //     Reconcile TouchA(60, 50), TouchB(100, 50)
        //
        //     In this scenario, we would want to
        //       1.) Register the movement of TouchA, ignoring TouchB
        //       2.) Re-align for TouchA and TouchB "starting" with new TuchA. (in that order)
        //     This we call "Add Touch Flow" (This is a common event...)
        
        let memeBag = Animus2TouchMemeBag(format: .grab)
        
        let objectA = Objeqt(value: 0)
        let objectB = Objeqt(value: 0)
        
        let fakeIdA = ObjectIdentifier(objectA)
        let fakeIdB = ObjectIdentifier(objectB)
        
        let memeBeforeA = Animus2TouchMeme(x: 50, y: 50, touchID: fakeIdA)
        memeBag.beforeMemesAdd(memeBeforeA)
        
        let memeAfterB = Animus2TouchMeme(x: 100, y: 50, touchID: fakeIdB)
        memeBag.afterMemesAdd(memeAfterB)
        
        let memeAfterA = Animus2TouchMeme(x: 60, y: 50, touchID: fakeIdA)
        memeBag.afterMemesAdd(memeAfterA)
        
        memeBag.bussOutCommandz()
        
        print("====== A-2 ======")
        memeBag.printCommands()
    }

}
