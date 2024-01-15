//
//  ContentView.swift
//  iuimport
//
//  Created by 神楽坂雅詩 on 2024/3/2.
//

// 匯入 SwiftUI 框架
import SwiftUI
import Photos

// 結構體 ContentView 繼承自 View 協定
struct ContentView: View {
    let mgr = DocumentsManager()
    let photoLibraryMgr = PhotoLibraryManager()
    let photoLibrary: PHPhotoLibrary = PHPhotoLibrary.shared()
    @State var files:[FileInfoModel] = [FileInfoModel]()
    @State var imagePaths:[String] = [String]()
    @State var savedStatus: [Int8] = []
    @State var savedStatusStr: [String] = []
    var body: some View {
        NavigationView {
            List($files, id: \.path) { $file in
                HStack {
                    let nowFile:FileInfoModel = $file.wrappedValue
                    let extName:String = mgr.getExtension(fromPath: nowFile.path)
                    let iconName:String = mgr.getIconName(extName: extName)
                    if (iconName == "photo") {
                        if let image = UIImage(named: file.path) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                        } else {
                            Image(systemName: iconName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                        }
                    } else if (iconName == "video") {
                        if let image = mgr.videoThumbnail(from: nowFile.path) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                        } else {
                            Image(systemName: iconName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                        }
                    } else {
                        Image(systemName: iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                    }
                    VStack(alignment: .leading) {
                        Text(file.name).font(.title2)
                        Text(mgr.formatFileSize(size: file.size)+" | "+mgr.dateToString(date: file.modification)).font(.caption)
                        HStack {
                            let index = mgr.indexFileInfoModel(fileInfos: files, path: nowFile.path)
                            if savedStatus[index] == 1 {
                                Image(systemName: "checkmark")
                            } else if savedStatus[index] == -1 {
                                Image(systemName: "exclamationmark.circle")
                            } else {
                                ProgressView()
                            }
                            Text(savedStatusStr[index]).font(.caption)
                        }
                    }
                }
            }
            .toolbar {
                Button(action: {
                    // TODO: 选择文件
                }) {
                    Text("选择文件")
                }
            }
            .navigationTitle("保存到相册")
        }
        .onAppear {
            photoLibraryMgr.saveToPhotoLibrary(view: self)
        }
    }
}

// 預覽
#Preview {
    // 顯示 ContentView 視圖
    ContentView()
}
