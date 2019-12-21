import 'package:test/test.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'dart:typed_data';
import 'dart:io';

class TestFileService {
  static void start() {
    group("File Service Tests", () {
      final files = Backendless.files;

      final folder = "test_folder";
      final copyFolder = "copy_folder";
      final saveName = "save.txt";
      final uploadName = "upload.txt";

      group("Before Uploading", () {
        test("Exists", () async {
          final savedPath = folder + "/" + saveName;
          final uploadedPath = folder + "/" + uploadName;
          final isSavedFileExists = await files.exists(savedPath);
          final isUploadedFileExists = await files.exists(uploadedPath);

          expect(isSavedFileExists, false);
          expect(isUploadedFileExists, false);
        });
      });

      group("Uploading", () {
        test("Save File", () async {
          final textToSave = "Test of uploading new file";
          final contentToSave = Uint8List.fromList(textToSave.codeUnits);
          final savingPath = folder + "/" + saveName;
          final fileUrl =
              await files.saveFile(contentToSave, filePathName: savingPath);

          expect(fileUrl, isNotNull);
        });

        test("Upload File", () async {
          final path = join(
            (await getTemporaryDirectory()).path,
            uploadName,
          );
          final testFile =
              await File(path).writeAsString("Test string to save");
          final uploadPath = folder + "/" + uploadName;
          final fileUrl = await files.upload(testFile, uploadPath);

          expect(fileUrl, isNotNull);
        });
      });

      group("After Uploading", () {
        test("Exists", () async {
          final savedPath = folder + "/" + saveName;
          final uploadedPath = folder + "/" + uploadName;
          final isSavedFileExists = await files.exists(savedPath);
          final isUploadedFileExists = await files.exists(uploadedPath);

          expect(isSavedFileExists, true);
          expect(isUploadedFileExists, true);
        });

        test("Copy File", () async {
          final savedPath = folder + "/" + saveName;
          final copyPath = folder + "/" + copyFolder;
          final copyUrl = await files.copyFile(savedPath, copyPath);

          expect(copyUrl, isNotNull);
        });

        test("Move File", () async {
          final uploadedPath = folder + "/" + uploadName;
          final movePath = folder + "/" + copyFolder;
          final movedUrl = await files.moveFile(uploadedPath, movePath);

          expect(movedUrl, isNotNull);
        });

        test("Get File Count", () async {
          final copyPath = folder + "/" + copyFolder;
          final rootCount = await files.getFileCount(folder, "*", false, true);

          final copyCount = await files.getFileCount(copyPath, "*", false, true);

          expect(rootCount, 2);
          expect(copyCount, 2);
        });

        test("Listing", () async {
          final rootList = await files.listing(folder);
          final rootNames = rootList.map((file) => file.name).toList();

          final copyPath = folder + "/" + copyFolder;
          final copyList = await files.listing(copyPath);
          final copyNames = copyList.map((file) => file.name).toList();

          expect(rootNames.length, 2);
          expect(rootNames, contains(saveName));
          expect(rootNames, contains(copyFolder));

          expect(copyNames.length, 2);
          expect(copyNames, contains(saveName));
          expect(copyNames, contains(uploadName));
        });

        test("Remove Files", () async {
          final savePath = folder + "/" + saveName;
          final uploadPath = folder + "/" + copyFolder + "/" + uploadName;
          final removeSaved = await files.remove(savePath);
          final removeUploaded = await files.remove(uploadPath);

          expect(removeSaved, isNot(0));
          expect(removeUploaded, isNot(0));
        });

        test("Remove Directory", () async {
          final copyPath = folder + "/" + copyFolder;
          final removedCopyFolder = await files.removeDirectory(copyPath);
          final removedFolder = await files.removeDirectory(folder);

          expect(removedCopyFolder, isNot(0));
          expect(removedFolder, isNot(0));
        });
      });
    });
  }
}
