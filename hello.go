/*
 * hello.go
 *
 * print the sum of the squares, almost functional style -
 */

package main

import (
	"fmt"

	"github.com/choleraehyq/gofunctools/functools"
)

func square(a int) int {
	return a * a
}

func main() {
	numbers := []int{1, 2, 3, 4, 5, 6, 7, 8, 9}

	var s, _ = functools.Reduce(func(a int, b int) int { return a + square(b) }, numbers, 0)
	fmt.Println(s)
}
