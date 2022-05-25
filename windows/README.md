# Libmagic-Build

libmagic build script for windows

## Windows build with docker and llvm-mingw

```bash
// Available RIDs win-x64, win-x86, win-arm64
docker run --name libmagic-win libmagic-llvm bash /build/libmagic_win.sh --rid win-x64

// Copy result to host directory
docker cp libmagic-win:/build/dist /path/to/dist

// Remove container
docker rm -f libmagic-win
```
