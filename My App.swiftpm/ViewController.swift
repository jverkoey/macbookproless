import AVFAudio
import SwiftUI
import UIKit

final class ViewController: UICollectionViewController {
    let audioEngine = AVAudioEngine()
    let playerNode = AVAudioPlayerNode()
    
    init() {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        super.init(collectionViewLayout: UICollectionViewCompositionalLayout.list(using: config))
        
        title = "Hello world"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(organizeDirectory))
        
        audioEngine.attach(playerNode)
    }
    
    var selectedUrl: URL? = nil

    var dataSource: UICollectionViewDiffableDataSource<URL, URL>? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, URL> { cell, indexPath, url in
            var config = cell.defaultContentConfiguration()
            config.text = url.lastPathComponent
            cell.contentConfiguration = config
        }
        dataSource = UICollectionViewDiffableDataSource<URL, URL>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: fileRegistration, for: indexPath, item: itemIdentifier)
        }
        collectionView.dataSource = dataSource
    }
    
    // MARK: - Unsupported but required to build
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedUrl = selectedUrl else {
            return
        }
        guard let url = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        guard selectedUrl.startAccessingSecurityScopedResource() else {
            // Handle the failure here.
            return
        }
        defer { selectedUrl.stopAccessingSecurityScopedResource() }
        
        let audioFile = try! AVAudioFile(forReading: url)
        audioEngine.connect(playerNode, 
                            to: audioEngine.outputNode, 
                            format: audioFile.processingFormat)
        playerNode.scheduleFile(audioFile, 
                                at: nil, 
                                completionCallbackType: .dataPlayedBack) { _ in
            print("finished")
        }
        do {
            try audioEngine.start()
            playerNode.play()
        } catch {
            /* Handle the error. */
        }
    }
}

// MARK: - Directory organization
extension ViewController: UIDocumentPickerDelegate {
    @objc func organizeDirectory() {
        let documentPicker =
        UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
        documentPicker.delegate = self
        present(documentPicker, animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first, urls.count == 1 else {
            return
        }
        selectedUrl = url
        
        guard url.startAccessingSecurityScopedResource() else {
            // Handle the failure here.
            return
        }
        defer { url.stopAccessingSecurityScopedResource() }
        
        var snapshot = NSDiffableDataSourceSnapshot<URL, URL>()
        snapshot.appendSections([url])
        
        var error: NSError? = nil
        NSFileCoordinator().coordinate(readingItemAt: url, error: &error) { (url) in
            let keys : [URLResourceKey] = [.nameKey, .isDirectoryKey]
            guard let fileList =
                    FileManager.default.enumerator(at: url, includingPropertiesForKeys: keys) else {
                        Swift.debugPrint("*** Unable to access the contents of \(url.path) ***\n")
                        return
                    }
            
            var urls: [URL] = []
            for case let file as URL in fileList {
                guard url.startAccessingSecurityScopedResource() else {
                    // Handle the failure here.
                    continue
                }
                urls.append(file)
                url.stopAccessingSecurityScopedResource()
            }
            snapshot.appendItems(urls, toSection: url)
            dataSource?.apply(snapshot)
        }
    }
}
