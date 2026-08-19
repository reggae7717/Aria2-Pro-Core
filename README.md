# Aria2 Pro Core

[![LICENSE](https://img.shields.io/github/license/P3TERX/Aria2-Pro-Core?style=flat-square)](https://github.com/P3TERX/Aria2-Pro-Core/blob/master/LICENSE)
![GitHub All Releases](https://img.shields.io/github/downloads/P3TERX/Aria2-Pro-Core/total?label=Downlaods&style=flat-square&color=red)
[![GitHub Stars](https://img.shields.io/github/stars/P3TERX/Aria2-Pro-Core.svg?style=flat-square&label=Stars&logo=github)](https://github.com/P3TERX/Aria2-Pro-Core/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/P3TERX/Aria2-Pro-Core.svg?style=flat-square&label=Forks&logo=github)](https://github.com/P3TERX/Aria2-Pro-Core/fork)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/P3TERX/Aria2-Pro-Core/Aria2%20Builder?label=Actions&logo=github&style=flat-square)

Aria2 static binaries for GNU/Linux with some powerful feature patches.
The original Autotools build remains available, and the repository also
provides a CMake build path for [aria2-next](https://github.com/AnInsomniacy/aria2-next) —
a maintained aria2 fork with extensive bug fixes, ED2K support, and modernized
architecture.

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/P3TERX/Aria2-Pro-Core?style=for-the-badge)](https://github.com/P3TERX/Aria2-Pro-Core/releases/latest)

## Changes

### aria2 (upstream)

* option `max-connection-per-server`: change maximum value to `∞`
* option `min-split-size`: change minimum value to `1K`
* option `piece-length`: change minimum value to `1K`
* download: retry on slow speed (`lowest-speed-limit`) and connection close
* download: add option `retry-on-400` to retry on http 400 bad request, which only effective if `retry-wait` > 0
* download: add option `retry-on-403` to retry on http 403 forbidden, which only effective if `retry-wait` > 0
* download: add option `retry-on-406` to retry on http 406 not acceptable, which only effective if `retry-wait` > 0
* download: add option `retry-on-unknown` to retry on unknown status code, which only effective if `retry-wait` > 0
* http: add option `http-want-digest` to choose whether to send the generated `Want-Digest` HTTP header or not (Not send by default)

### aria2-next

aria2-next is a maintained fork of aria2 with a modern CMake build system,
extensive bug fixes, and native ED2K/eMule support. The same feature patches
are applied to aria2-next via `patch/aria2-next/`:

* `0001` — unlock connection-per-server limit, lower min-split-size, disable Want-Digest by default
* `0002` — retry on slow speed and connection close
* `0003` — retry on HTTP 400/403/406/unknown status codes
* `0004` — lower piece-length minimum to 1 KiB
* `0005` — CMake: filter implicit `-R` rpath flags from pkg-config imported targets

## Installing

### Automatic script
```shell
curl -fsSL git.io/aria2c.sh | bash
```

### Manual installation
```shell
wget https://github.com/P3TERX/Aria2-Pro-Core/releases/download/[version]/aria2-[version]-static-linux-[arch].tar.gz
tar zxvf aria2-[version]-static-linux-[arch].tar.gz
sudo mv aria2c /usr/local/bin
```

### Uninstall
```shell
sudo rm -f /usr/local/bin/aria2c
```

## Building

### aria2 (autotools, dynamic)

Build the upstream aria2 with Autotools. Output is a dynamically linked
`aria2c` binary.

```shell
DOCKER_BUILDKIT=1 docker build \
    -o type=local,dest=. \
    github.com/P3TERX/Aria2-Pro-Core
```

Cross build for other platforms, e.g.:
```shell
DOCKER_BUILDKIT=1 docker build \
    --build-arg BUILDER_IMAGE=ubuntu:14.04 \
    --build-arg BUILD_SCRIPT=aria2-gnu-linux-cross-build-armhf.sh \
    -o type=local,dest=. \
    github.com/P3TERX/Aria2-Pro-Core
```

### aria2-next (CMake, dynamic)

Build aria2-next with CMake and dynamically linked OpenSSL/glibc.
Output is a PIE executable, approximately 6 MB.

```shell
DOCKER_BUILDKIT=1 docker build \
    --build-arg BUILDER_IMAGE=ubuntu:24.04 \
    --build-arg BUILD_SCRIPT=aria2-next-gnu-linux-build.sh \
    -o type=local,dest=. \
    .
```

The source and ref can be overridden without changing the script:
```shell
DOCKER_BUILDKIT=1 docker build \
    --build-arg BUILDER_IMAGE=ubuntu:24.04 \
    --build-arg BUILD_SCRIPT=aria2-next-gnu-linux-build.sh \
    --build-arg ARIA2_REPOSITORY=https://github.com/AnInsomniacy/aria2-next.git \
    --build-arg ARIA2_REF=main \
    -o type=local,dest=. \
    .
```

### aria2-next (CMake, static)

Build aria2-next with CMake and fully static linking (glibc, OpenSSL, etc.).
Output is a statically linked executable, approximately 14 MB.

```shell
DOCKER_BUILDKIT=1 docker build \
    --build-arg BUILDER_IMAGE=ubuntu:24.04 \
    --build-arg BUILD_SCRIPT=aria2-next-gnu-linux-build.sh \
    --build-arg ARIA2_BUILD_SYSTEM=cmake \
    --build-arg ARIA2_REPOSITORY=https://github.com/AnInsomniacy/aria2-next.git \
    --build-arg ARIA2_REF=main \
    -o type=local,dest=. \
    .
```

The output binary is fully static and can be verified with `file`:
```text
ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked
```

For a local checkout, mount the source and set `ARIA2_SOURCE_DIR`:
```shell
docker run --rm -v /path/to/aria2-next:/src:ro \
    -e ARIA2_SOURCE_DIR=/src \
    ...
```

## External links

### Aria2

* [Aria2 homepage](https://aria2.github.io/)
* [Aria2 documentation](https://aria2.github.io/manual/en/html/)
* [Aria2 source code (Github)](https://github.com/aria2/aria2)

### aria2-next

* [aria2-next source code (GitHub)](https://github.com/AnInsomniacy/aria2-next)
* [aria2-next releases](https://github.com/AnInsomniacy/aria2-next/releases)

### Used external libraries

* [zlib](http://www.zlib.net/)
* [Expat](https://libexpat.github.io/)
* [c-ares](http://c-ares.haxx.se/)
* [SQLite](http://www.sqlite.org/)
* [OpenSSL](http://www.openssl.org/)
* [libssh2](http://www.libssh2.org/)
* [jemalloc](http://jemalloc.net/)

### Credits

* [q3aql/aria2-static-builds](https://github.com/q3aql/aria2-static-builds)
* [myfreeer/aria2-build-msys2](https://github.com/myfreeer/aria2-build-msys2)

## Licence

[![GPLv3](https://www.gnu.org/graphics/gplv3-127x51.png)](https://github.com/P3TERX/Aria2-Pro-Core/blob/master/LICENSE)