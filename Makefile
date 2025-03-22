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
