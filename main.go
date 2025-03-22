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
