import UIKit

// Queue - Main, Global, Custom

// - Main
DispatchQueue.main.async {
    // UI update
    let view = UIView()
    view.backgroundColor = .white
}

// - Global
DispatchQueue.global(qos: .userInteractive).async {
    // 진짜 완전중요, 지금 당장 해야하는것
}

DispatchQueue.global(qos: .userInitiated).async {
    // 거의 바로 해줘야 할 것, 사용자가 결과를 기다리는중
}

DispatchQueue.global(qos: .default).async {
    // 이건 굳이?
}

DispatchQueue.global(qos: .utility).async {
    // 시간이 좀 걸리는 일들, 사용자가 당장 기다리지 않는것, 네트워킹, 큰파일 불러올 때
}

DispatchQueue.global(qos: .background).async {
    // 사용자한테 당장 인식될 필요가 없는 것들, 뉴스데이터 미리 받기, 위치 나 모르게 업데이트 되기, 영상 다운받기 등
}

// - Custom Queue
let concurrentQueue = DispatchQueue(label: "concurrent",qos: .background, attributes: .concurrent)
let serialQueue = DispatchQueue(label: "serial", qos: .background)

// 복합적인 상황

func downloadImageFromServer() -> UIImage {
    // Heavy Task
    return UIImage()
}

func updateUI(image : UIImage) {
    
}

DispatchQueue.global(qos: .background).async {
    // download
    let image = downloadImageFromServer()
    DispatchQueue.main.async {
        // update UI
        updateUI(image: image)
    }
}


// Sync, Async
DispatchQueue.global(qos: .background).sync {
    for i in 0...5 {
        print("🤢\(i)")
    }
}


DispatchQueue.global(qos: .userInteractive).sync {
    for i in 0...5 {
        print("🎃\(i)")
    }
}
DispatchQueue.global(qos: .background).async {
    for i in 0...5 {
        print("👿\(i)")
    }
}


DispatchQueue.global(qos: .userInteractive).async {
    for i in 0...5 {
        print("😵‍💫\(i)")
    }
}

