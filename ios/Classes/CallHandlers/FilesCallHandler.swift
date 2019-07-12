//
//  FilesCallHandler.swift
//  Flutter-SDK
//
//  Created by Andrii Bodnar on 5/2/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation
import Flutter
import Backendless

class FilesCallHandler: FlutterCallHandlerProtocol {
    
    // MARK: -
    // MARK: - Constants
    private enum Methods {
        static let copyFile = "Backendless.Files.copyFile"
        static let exists = "Backendless.Files.exists"
        static let getFileCount = "Backendless.Files.getFileCount"
        static let listing = "Backendless.Files.listing"
        static let moveFile = "Backendless.Files.moveFile"
        static let remove = "Backendless.Files.remove"
        static let removeDirectory = "Backendless.Files.removeDirectory"
        static let renameFile = "Backendless.Files.renameFile"
        static let saveFile = "Backendless.Files.saveFile"
        static let upload = "Backendless.Files.upload"
    }
    
    private enum Args {
        static let sourcePathName = "sourcePathName"
        static let targetPath = "targetPath"
        static let path = "path"
        static let pattern = "pattern"
        static let recursive = "recursive"
        static let countDirectories = "countDirectories"
        static let pageSize = "pagesize"
        static let offset = "offset"
        static let fileUrl = "fileUrl"
        static let oldPathName = "oldPathName"
        static let newName = "newName"
        static let fileName = "fileName"
        static let fileContent = "fileContent"
        static let overwrite = "overwrite"
        static let directoryPath = "directoryPath"
        static let filePath = "filePath"
        static let filePathName = "filePathName"
    }
    
    // MARK: -
    // MARK: - FileService Reference
    private let fileService = SwiftBackendlessSdkPlugin.backendless.fileService
    
    // MARK: -
    // MARK: - Route Flutter Call
    func routeFlutterCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments: [String: Any] = call.arguments.flatMap(cast) ?? [:]
        
        switch call.method {
        case Methods.copyFile:
            copyFile(arguments, result)
        case Methods.exists:
            exists(arguments, result)
        case Methods.getFileCount:
            getFileCount(arguments, result)
        case Methods.listing:
            listing(arguments, result)
        case Methods.moveFile:
            moveFile(arguments, result)
        case Methods.remove:
            remove(arguments, result)
        case Methods.removeDirectory:
            removeDirectory(arguments, result)
        case Methods.renameFile:
            renameFile(arguments, result)
        case Methods.saveFile:
            saveFile(arguments, result)
        case Methods.upload:
            upload(arguments, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: -
    // MARK: - CopyFile
    private func copyFile(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard
            let sourcePath: String = arguments[Args.sourcePathName].flatMap(cast),
            let targetPath: String = arguments[Args.targetPath].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        fileService.copy(sourcePath: sourcePath, targetPath: targetPath,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - Exists
    private func exists(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let path: String = arguments[Args.path].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        fileService.exists(path: path,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - GetFileCount
    private func getFileCount(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let path: String = arguments[Args.path].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let pattern: String? = arguments[Args.pattern].flatMap(cast)
        let recursive: Bool? = arguments[Args.recursive].flatMap(cast)
        let countDirectories: Bool? = arguments[Args.countDirectories].flatMap(cast)
        
        if let pattern = pattern {
            if let recursive = recursive {
                if let countDirectories = countDirectories {
                    fileService.getFileCount(path: path, pattern: pattern, recursive: recursive, countDirectories: countDirectories,
                        responseHandler: {
                            result($0)
                        },
                        errorHandler: {
                            result(FlutterError($0))
                        })
                } else {
                    fileService.getFileCount(path: path, pattern: pattern, recursive: recursive,
                        responseHandler: {
                            result($0)
                        },
                        errorHandler: {
                            result(FlutterError($0))
                        })
                }
            } else {
                fileService.getFileCount(path: path, pattern: pattern,
                    responseHandler: {
                        result($0)
                    },
                    errorHandler: {
                        result(FlutterError($0))
                    })
            }
        } else {
            fileService.getFileCount(path: path,
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        }
    }
    
    // MARK: -
    // MARK: - Listing
    private func listing(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let path: String = arguments[Args.path].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let pattern: String? = arguments[Args.pattern].flatMap(cast)
        let recursive: Bool? = arguments[Args.recursive].flatMap(cast)
        let pageSize: Int? = arguments[Args.pageSize].flatMap(cast)
        let offset: Int? = arguments[Args.offset].flatMap(cast)
        
        if let pattern = pattern, let recursive = recursive {
            if let pageSize = pageSize, let offset = offset {
                fileService.listing(path: path, pattern: pattern, recursive: recursive, pageSize: pageSize, offset: offset,
                    responseHandler: {
                        result($0)
                    },
                    errorHandler: {
                        result(FlutterError($0))
                    })
            } else {
                fileService.listing(path: path, pattern: pattern, recursive: recursive,
                    responseHandler: {
                        result($0)
                    },
                    errorHandler: {
                        result(FlutterError($0))
                    })
            }
        } else {
            fileService.listing(path: path,
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
            }
    }
    
    // MARK: -
    // MARK: - MoveFile
    private func moveFile(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard
            let sourcePathName: String = arguments[Args.sourcePathName].flatMap(cast),
            let targetPath: String = arguments[Args.targetPath].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        fileService.move(sourcePath: sourcePathName, targetPath: targetPath,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - Remove
    private func remove(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let fileUrl: String = arguments[Args.fileUrl].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        fileService.remove(path: fileUrl,
            responseHandler: {
                result(nil)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - RemoveDirectory
    private func removeDirectory(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let directoryPath: String = arguments[Args.directoryPath].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let pattern: String? = arguments[Args.pattern].flatMap(cast)
        let recursive: Bool? = arguments[Args.recursive].flatMap(cast)
        
        if let pattern = pattern, let recursive = recursive {
            fileService.remove(path: directoryPath, pattern: pattern, recursive: recursive,
                responseHandler: {
                    result(nil)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        } else {
            fileService.remove(path: directoryPath, pattern: "*", recursive: true,
                responseHandler: {
                    result(nil)
                },
                    errorHandler: {
                result(FlutterError($0))
                })
        }
    }
    
    // MARK: -
    // MARK: - RenameFile
    private func renameFile(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard
            let path: String = arguments[Args.oldPathName].flatMap(cast),
            let newName: String = arguments[Args.newName].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        fileService.rename(path: path, newName: newName,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - SaveFile
    private func saveFile(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let flutterData: FlutterStandardTypedData = arguments[Args.fileContent].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let path: String? = arguments[Args.path].flatMap(cast)
        let fileName: String? = arguments[Args.fileName].flatMap(cast)
        let filePathName: String? = arguments[Args.filePathName].flatMap(cast)
        let overwrite: Bool? = arguments[Args.overwrite].flatMap(cast)
        
        let base64Content = flutterData.data.base64EncodedString()
        
        let pathToSend: String
        let nameToSend: String
        
        if let path = path, let fileName = fileName {
            pathToSend = path
            nameToSend = fileName
        } else if let filePathName = filePathName {
            if let lastSlashPos = filePathName.lastIndex(of: "/") {
                pathToSend = String(filePathName[..<lastSlashPos])
                nameToSend = String(filePathName[lastSlashPos...].dropFirst())
            } else {
                pathToSend = ""
                nameToSend = filePathName
            }
        } else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        if let overwrite = overwrite {
            fileService.saveFile(fileName: nameToSend, filePath: pathToSend, base64Content: base64Content, overwrite: overwrite,
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        } else {
            fileService.saveFile(fileName: nameToSend, filePath: pathToSend, base64Content: base64Content,
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        }
    }
    
    // MARK: -
    // MARK: - Upload
    private func upload(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard
            let filePath: String = arguments[Args.filePath].flatMap(cast),
            let path: String = arguments[Args.path].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let fileUrl = URL(fileURLWithPath: filePath)
        
        guard let fileContent = try? Data(contentsOf: fileUrl) else {
            result(FlutterError(code: "", message: "No such file", details: nil))
            
            return
        }
        
        let overwrite: Bool? = arguments[Args.overwrite].flatMap(cast)
        
        let pathToSend: String
        let nameToSend: String
        
        if let lastSlashPos = path.lastIndex(of: "/") {
            pathToSend = String(path[..<lastSlashPos])
            nameToSend = String(path[lastSlashPos...].dropFirst())
        } else {
            pathToSend = ""
            nameToSend = path
        }
        
        
        if let overwrite = overwrite {
            fileService.uploadFile(fileName: nameToSend, filePath: pathToSend, content: fileContent, overwrite: overwrite,
                responseHandler: { (file: BackendlessFile) in
                    file.fileUrl.map { result($0) }
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        } else {
            fileService.uploadFile(fileName: nameToSend, filePath: pathToSend, content: fileContent,
                responseHandler: { (file: BackendlessFile) in
                    file.fileUrl.map { result($0) }
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        }
    }
}
