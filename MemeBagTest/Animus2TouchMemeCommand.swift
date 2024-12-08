//
//  Animus2TouchMemeCommand.swift
//  Jiggle3
//
//  Created by Nicky Taylor on 12/8/24.
//

import Foundation

class Animus2TouchMemeCommand {
    
    var type = Animus2TouchMemeCommandType.move
    
    var chunks = [Animus2TouchMemeCommandChunk]()
    var chunkCount = 0
    
    func addChunk(chunk: Animus2TouchMemeCommandChunk) {
        while chunks.count <= chunkCount {
            chunks.append(chunk)
        }
        chunks[chunkCount] = chunk
        chunkCount += 1
    }
    
}
