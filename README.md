# Go and C++ FFI Example

This repository demonstrates how to call C++ code from Go using Foreign Function Interface (FFI) with cgo. The project includes a simple C++ library that performs addition, which is then called from a Go program.

## Directory Structure

```
go-cpp-ffi/
├── cpp/
│   ├── libmath.h
│   └── libmath.cpp
├── shared/
│   └── (shared library files will be placed here)
├── main.go
└── Makefile
```

## Prerequisites

- Go (1.16 or later)
- C++ compiler (g++ or clang++)
- Make

## Setup

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/go-cpp-ffi.git
   cd go-cpp-ffi
   ```

2. Install dependencies (if needed):
   ```bash
   # For Ubuntu/Debian
   sudo apt-get install g++ make

   # For macOS (using Homebrew)
   brew install g++ make
   ```

## Build and Run

Build: 
```bash
make
```

Run: 
```bash
make run
```

## Code Explanation

### C++ Library (cpp/libmath.h and cpp/libmath.cpp)

The C++ library provides a simple `add` adn `sub` function that takes two integers and returns int. The `extern "C"` block ensures that the function names are not mangled, making them accessible from Go.

```cpp
// cpp/libmath.h
#ifndef LIBMATH_H
#define LIBMATH_H

#ifdef __cplusplus
extern "C" {
#endif

int add(int a, int b);
int sub(int a, int b);

#ifdef __cplusplus
}
#endif

#endif // LIBMATH_H
```

```cpp
// cpp/libmath.cpp
#include "libmath.h"

int add(int a, int b) {
    return a + b;
}

int sub(int a, int b) P
    return a - b;
}
```

### Go Program (main.go)

The Go program uses cgo to link against the C++ library and call the `add` and `sub` function.

```go
package main

/*
#cgo LDFLAGS: -L./shared -lmath

#include "cpp/libmath.h"
*/
import "C"
import "fmt"

func main() {
	a := C.int(5)
	b := C.int(4)

	add := int(C.add(a, b))
	fmt.Printf("%d + %d = %d\n", a, b, add)

	sub := int(C.sub(a, b))
	fmt.Printf("%d - %d = %d\n", a, b, sub)
}
```

### Makefile

The Makefile automates the build process for both the C++ library and the Go program.

```makefile
CC := g++
GO := go
LIBDIR := shared
SRCDIR := cpp

LIBRARY := $(LIBDIR)/libmath.so
CXX_SOURCES := $(wildcard $(SRCDIR)/*.cpp)
CXX_OBJECTS := $(patsubst $(SRCDIR)/%.cpp,$(LIBDIR)/%.o,$(CXX_SOURCES))

GO_BINARY := go-cpp-ffi

all: build-cpp build-go

build-cpp: $(LIBDIR) $(LIBRARY)

$(LIBDIR):
	mkdir -p $(LIBDIR)

$(LIBRARY): $(CXX_OBJECTS)
	$(CC) -shared -o $@ $^

$(LIBDIR)/%.o: $(SRCDIR)/%.cpp
	$(CC) -fPIC -c $< -o $@

build-go: $(GO_BINARY)

$(GO_BINARY): main.go
	$(GO) build -o $@ ./main.go

clean:
	rm -rf $(LIBDIR) $(GO_BINARY)

run: build-go
	./$(GO_BINARY)

.PHONY: all build-cpp build-go clean run
```
