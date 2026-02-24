APP ICON MUST BE IN THIS FOLDER
================================

Xcode uses THIS asset catalog (NSBStudy/NSBStudy/Assets.xcassets).
The app icon image must be:

  • Filename: AppIcon.png
  • Location: this folder (AppIcon.appiconset)
  • Size: 1024×1024 pixels, PNG

WRONG: AppIcon.png in Assets.xcassets (parent folder)
RIGHT: AppIcon.png here, next to Contents.json

To generate the icon, from project root run:
  python3 scripts/generate_app_icon.py

Then clean build in Xcode, delete app from phone, and run again.
