# FootballiOS

#### Screenshots

Dark | Light
--- | ---
![](../Sources/dark_mode.gif) | ![](../Sources/light_mode.gif)

---

### Requirements
 Tool | Version 
--- | ---
XCode | 14.0.0
iOS | 16.0
Device | 14 Pro

### How to run FootballiOS test
- Keep in mind, my snapshot test run following the requirement, if you want to change, please record the new snapshot test, by changing the method into the test case
```
    // FROM:
    func test_emptyList() {
        let (sut, _) = makeSUT()
        sut.display([])

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "EMPTY_LIST_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "EMPTY_LIST_dark")
    }
    // TO
    func test_emptyList() {
        let (sut, _) = makeSUT()
        sut.display([])

        record(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "EMPTY_LIST_light")
        record(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "EMPTY_LIST_light")
    }
```
