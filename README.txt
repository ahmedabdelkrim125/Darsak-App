Darsak update package
=====================
1. Extract this zip INTO the root of your Flutter project (the folder with pubspec.yaml), overwrite when asked.
2. Open a terminal in the project root and run:
     powershell -ExecutionPolicy Bypass -File .\apply_patch.ps1
   (it patches a few existing files, adds packages, and runs build_runner)
3. Stop the app completely and run it again (not hot reload).
