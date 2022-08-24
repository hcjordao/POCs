# Test

## Overview
Studies of new Async & Await API from WWDC 2021

Testing basic functionalities from async sequence from WWDC 2021 talk: https://developer.apple.com/videos/play/wwdc2021/10058/

## Topics

### Introduction to Async Await (Look into Async Await folders)
- Removes the need of completions
- Reduces the need of delegates
- Some Apple APIs were already migrated to new async await syntax 

### AsyncSequence (Look into Async Sequence)
**What is AsyncSequence?**
- Same as regular sequences
- Each element is delivered asynchronously
- Each element fetched may *throw* an error
- May end at the end or at throw

**How it works?**
- Similar process of creating a new sequence type
  - We need the data and an iterator which will pass through the elements sending the next.
  - Usage through the IteratorProtocol
- To use it, we need to create a sequence using the AsyncSequence protocol
  - We also need to make an iterator.
- Useful for decoding data, performing sync operations and showing as decoded on the flight
- For stream observations we should use an AsyncStream 

### AsyncStream & AsyncThrowingStream
- Observing data changes
- The difference between the throwing version and the normal, is just that the Throwing will throw errors. Standard heh :)
- 
