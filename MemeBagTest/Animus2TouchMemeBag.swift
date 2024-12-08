//
//  Animus2TouchMemeBag.swift
//  Jiggle3
//
//  Created by Nicky Taylor on 12/8/24.
//

import Foundation

//     This is a slippery slope.
//     Consider this scenario
//
//     Snapshot: TouchA (50, 50)
//     Reconcile TouchA(60, 50), TouchB(100, 50)
//
//     In this scenario, we would want to
//       1.) Register the movement of TouchA, ignoring TouchB
//       2.) Re-align for TouchA and TouchB "starting" with new TuchA. (in that order)
//     This we call "Add Touch Flow" (This is a common event...)


//     Snapshot: TouchA (50, 50), TouchB (100, 50), TouchC (150, 50)
//     Reconcile TouchB(110, 50), TouchA(60, 50)
//     In this scenario, we would want to
//       1.) Remove touch C, re-align from TouchA and TouchB previous locations.
//       2.) Register the movement of TouchA and TouchB (in that order)
//     This we call "Remove Touch Flow" (This is a common event...)

//     Snapshot: TouchA (50, 50), TouchB (100, 50)
//     Reconcile TouchA(60, 50), TouchC (150, 50)
//     In this scenario, we would want to
//       1.) Remove touch B, re-align from TouchA previous locations.
//       2.) Register the movement of TouchA, ignoring TouchB and TouchC
//       3.) Re-align for TouchA and TouchC "starting" with new TouchA. (in that order)
//     This we call "Add And Remove Touch Flow" (This is a 1 in 10000 event...)

class Animus2TouchMemeBag {
    
    let format: AnimusTouchFormat
    init(format: AnimusTouchFormat) {
        self.format = format
    }
    
    var beforeMemes = [Animus2TouchMeme]()
    var beforeMemeCount = 0
    
    var afterMemes = [Animus2TouchMeme]()
    var afterMemeCount = 0
    
    var memeCommands = [Animus2TouchMemeCommand]()
    var memeCommandCount = 0
    
    
    
    func bussOutCommandz() {
        
        for commandIndex in 0..<memeCommandCount {
            let command = memeCommands[commandIndex]
            
            
            //Animus2PartsFactory.shared.depositAnimusTouchMemeCommand(command)
        }
        memeCommandCount = 0
        
        
        // First we do removes. That means:
        // It exists in before, not in after.
        
        var isRemoveCommandNeeded = false
        for beforeMemeIndex in 0..<beforeMemeCount {
            let beforeMeme = beforeMemes[beforeMemeIndex]
            if afterMemesContains(touchID: beforeMeme.touchID) == false {
                isRemoveCommandNeeded = true
                break
            }
        }
        if isRemoveCommandNeeded {
            let newCommand = Animus2TouchMemeCommand()
            newCommand.chunkCount = 0
            newCommand.type = .remove
            addMemeCommand(memeCommand: newCommand)
            
            for beforeMemeIndex in 0..<beforeMemeCount {
                let beforeMeme = beforeMemes[beforeMemeIndex]
                if afterMemesContains(touchID: beforeMeme.touchID) == false {
                    let chunk = Animus2TouchMemeCommandChunk.remove(beforeMeme.touchID)
                    newCommand.addChunk(chunk: chunk)
                }
            }
            
        }
        
        var isMoveCommandNeeded = false
        for beforeMemeIndex in 0..<beforeMemeCount {
            let beforeMeme = beforeMemes[beforeMemeIndex]
            var isMoved = false
            
            for afterMemeIndex in 0..<afterMemeCount {
                let afterMeme = afterMemes[afterMemeIndex]
                if beforeMeme.touchID == afterMeme.touchID {
                    if beforeMeme.x != afterMeme.x || beforeMeme.y != afterMeme.y {
                        isMoved = true
                    }
                }
            }
            if isMoved {
                isMoveCommandNeeded = true
                break
            }
        }
        
        if isMoveCommandNeeded {
            
            var afterX = Float(0.0)
            var afterY = Float(0.0)
            let newCommand = Animus2TouchMemeCommand()
            newCommand.chunkCount = 0
            newCommand.type = .move
            addMemeCommand(memeCommand: newCommand)
            
            
            for beforeMemeIndex in 0..<beforeMemeCount {
                let beforeMeme = beforeMemes[beforeMemeIndex]
                var isMoved = false
                for afterMemeIndex in 0..<afterMemeCount {
                    let afterMeme = afterMemes[afterMemeIndex]
                    if beforeMeme.touchID == afterMeme.touchID {
                        if beforeMeme.x != afterMeme.x || beforeMeme.y != afterMeme.y {
                            isMoved = true
                            afterX = afterMeme.x
                            afterY = afterMeme.y
                        }
                    }
                }
                if isMoved {
                    let chunk = Animus2TouchMemeCommandChunk.move(beforeMeme.touchID,
                                                                  beforeMeme.x,
                                                                  beforeMeme.y,
                                                                  afterX,
                                                                  afterY)
                    newCommand.addChunk(chunk: chunk)
                }
            }
        }
        
        var isAddCommandNeeded = false
        for afterMemeIndex in 0..<afterMemeCount {
            let afterMeme = afterMemes[afterMemeIndex]
            if !beforeMemesContains(touchID: afterMeme.touchID) {
                isAddCommandNeeded = true
                break
            }
        }
        
        if isAddCommandNeeded {
            let newCommand = Animus2TouchMemeCommand()
            newCommand.chunkCount = 0
            newCommand.type = .add
            addMemeCommand(memeCommand: newCommand)
            
            for afterMemeIndex in 0..<afterMemeCount {
                let afterMeme = afterMemes[afterMemeIndex]
                if !beforeMemesContains(touchID: afterMeme.touchID) {
                    let chunk = Animus2TouchMemeCommandChunk.add(afterMeme.touchID,
                                                                 afterMeme.x,
                                                                 afterMeme.y)
                    newCommand.addChunk(chunk: chunk)
                }
            }
        }
    }
    
    func printMemes() {
        for memeIndex in 0..<beforeMemeCount {
            let meme = beforeMemes[memeIndex]
            print("BeforeMeme[\(memeIndex)] => \(meme.touchID), \(meme.x), \(meme.y)")
        }
        
        for memeIndex in 0..<afterMemeCount {
            let meme = afterMemes[memeIndex]
            print("AfterMeme[\(memeIndex)] => \(meme.touchID), \(meme.x), \(meme.y)")
        }
        
    }
    
    func printCommands() {
        for commandIndex in 0..<memeCommandCount {
            let command = memeCommands[commandIndex]
            print("Command[\(commandIndex)] => \(command.type)")
            for chunkIndex in 0..<command.chunkCount {
                let chunk = command.chunks[chunkIndex]
                switch chunk {
                    
                case .add(let oid, let x, let y):
                    print("\tChunk[\(chunkIndex)] Add(\(oid)) @ [\(x), \(y)]")
                case .remove(let oid):
                    print("\tChunk[\(chunkIndex)] Remove(\(oid))")
                case .move(let oid, let x1, let y1, let x2, let y2):
                    print("\tChunk[\(chunkIndex)] Move(\(oid)) [\(x1), \(y1)] => [\(x2), \(y2)]")
                }
            }
        }
    }
    
    
    
    func addMemeCommand(memeCommand: Animus2TouchMemeCommand) {
        if true {
            for checkIndex in 0..<memeCommandCount {
                if memeCommands[checkIndex] === memeCommand {
                    print("FATAL!!! The same MemeCommand was added to Animus2PartsFactory twice...")
                    fatalError("WOWOWOWOWOW????")
                }
            }
        }
        
        while memeCommands.count <= memeCommandCount {
            memeCommands.append(memeCommand)
        }
        memeCommands[memeCommandCount] = memeCommand
        memeCommandCount += 1
    }
    ///
    ///
    ////////////////
    
    
    
    func beforeMemesAdd(_ meme: Animus2TouchMeme) {
        
        
        if true {
            if beforeMemesContains(meme) {
                print("FATAL ERROR: We're adding the same purgatory touch which is in regular touches...")
            }
        }
        
        while beforeMemes.count <= beforeMemeCount {
            beforeMemes.append(meme)
        }
        beforeMemes[beforeMemeCount] = meme
        beforeMemeCount += 1
    }
    
    // [Touch Routes Verify] 12-7-2024
    //
    // Seems correct; I don't see any possible
    // Chance that this could screw up!!!!!!!!!
    //
    func beforeMemesContains(_ meme: Animus2TouchMeme) -> Bool {
        for memeIndex in 0..<beforeMemeCount {
            if beforeMemes[memeIndex] === meme {
                return true
            }
        }
        return false
    }
    
    // [Touch Routes Verify] 12-7-2024
    //
    // Seems correct; I don't see any possible
    // Chance that this could screw up!!!!!!!!!
    //
    func beforeMemesContains(touchID: ObjectIdentifier) -> Bool {
        for memeIndex in 0..<beforeMemeCount {
            if beforeMemes[memeIndex].touchID == touchID {
                return true
            }
        }
        return false
    }
    
    // [Touch Routes Verify] 12-7-2024
    //
    // Seems correct; I don't see any possible
    // TODO: We don't even need this
    //
    func beforeMemesCount(_ meme: Animus2TouchMeme) -> Int {
        var result = 0
        for memeIndex in 0..<beforeMemeCount {
            if meme === beforeMemes[memeIndex] {
                result += 1
            }
        }
        return result
    }
    
    // [Touch Routes Verify] 12-8-2024
    //
    // Seems correct; I don't see any possible
    //
    func beforeMemesRemove(_ meme: Animus2TouchMeme) -> Bool {
        
        if true {
            
            let touchCount = beforeMemesCount(meme)
            
            if touchCount > 1 {
                print("FATAL: We have a Purgatory touch more than once...")
            }
            
            if touchCount <= 0 {
                print("FATAL: We are removing a Purgatory touch that's not in the list?!?!")
                return false
            }
        }
        
        var numberRemoved = 0
        var removeLoopIndex = 0
        while removeLoopIndex < beforeMemeCount {
            if beforeMemes[removeLoopIndex] === meme {
                break
            } else {
                removeLoopIndex += 1
            }
        }
        while removeLoopIndex < beforeMemeCount {
            if beforeMemes[removeLoopIndex] === meme {
                numberRemoved += 1
            } else {
                beforeMemes[removeLoopIndex - numberRemoved] = beforeMemes[removeLoopIndex]
            }
            removeLoopIndex += 1
        }
        beforeMemeCount -= numberRemoved
        
        if numberRemoved > 0 {
            //Animus2PartsFactory.shared.depositAnimusTouchMeme(meme)
            
            return true
        } else {
            return false
        }
    }
    
    
    
    func afterMemesAdd(_ meme: Animus2TouchMeme) {
        
        
        if true {
            if afterMemesContains(meme) {
                print("FATAL ERROR: We're adding the same purgatory touch which is in regular touches...")
            }
        }
        
        while afterMemes.count <= afterMemeCount {
            afterMemes.append(meme)
        }
        afterMemes[afterMemeCount] = meme
        afterMemeCount += 1
    }
    
    // [Touch Routes Verify] 12-7-2024
    //
    // Seems correct; I don't see any possible
    // Chance that this could screw up!!!!!!!!!
    //
    func afterMemesContains(_ meme: Animus2TouchMeme) -> Bool {
        for memeIndex in 0..<afterMemeCount {
            if afterMemes[memeIndex] === meme {
                return true
            }
        }
        return false
    }
    
    // [Touch Routes Verify] 12-7-2024
    //
    // Seems correct; I don't see any possible
    // Chance that this could screw up!!!!!!!!!
    //
    func afterMemesContains(touchID: ObjectIdentifier) -> Bool {
        for memeIndex in 0..<afterMemeCount {
            if afterMemes[memeIndex].touchID == touchID {
                return true
            }
        }
        return false
    }
    
    // [Touch Routes Verify] 12-7-2024
    //
    // Seems correct; I don't see any possible
    // TODO: We don't even need this
    //
    func afterMemesCount(_ meme: Animus2TouchMeme) -> Int {
        var result = 0
        for memeIndex in 0..<afterMemeCount {
            if meme === afterMemes[memeIndex] {
                result += 1
            }
        }
        return result
    }
    
    // [Touch Routes Verify] 12-8-2024
    //
    // Seems correct; I don't see any possible
    //
    func afterMemesRemove(_ meme: Animus2TouchMeme) -> Bool {
        
        if true {
            
            let touchCount = afterMemesCount(meme)
            
            if touchCount > 1 {
                print("FATAL: We have a Purgatory touch more than once...")
            }
            
            if touchCount <= 0 {
                print("FATAL: We are removing a Purgatory touch that's not in the list?!?!")
                return false
            }
        }
        
        var numberRemoved = 0
        var removeLoopIndex = 0
        while removeLoopIndex < afterMemeCount {
            if afterMemes[removeLoopIndex] === meme {
                break
            } else {
                removeLoopIndex += 1
            }
        }
        while removeLoopIndex < afterMemeCount {
            if afterMemes[removeLoopIndex] === meme {
                numberRemoved += 1
            } else {
                afterMemes[removeLoopIndex - numberRemoved] = afterMemes[removeLoopIndex]
            }
            removeLoopIndex += 1
        }
        afterMemeCount -= numberRemoved
        
        if numberRemoved > 0 {
            //Animus2PartsFactory.shared.depositAnimusTouchMeme(meme)
            
            return true
        } else {
            return false
        }
    }
    
    
    
}
