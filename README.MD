## CurseForge manifest downloader

Simple scripts, which will help you to download project files from `manifest.json`, which always used in projects published in `CurseForge`

### How to use

If you use Windows, you need `read_manifest.bat`, and use this like that:

```cmd
### Example
read_manifest.bat /path/to/manifest /path/to/upload_folder

### Usage
read_manifest.bat .\manifest.json mods
```

Also if you use Linux or MacOS, you can use `read_manifest.sh` and use this like that:
```bash
sh read_manifest.sh /path/to/manifest /path/to/upload_folder
```