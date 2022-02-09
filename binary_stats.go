package main

import "fmt"

type BinaryStats struct {
	d0 int
	d1 int
}

func (bs *BinaryStats) Update(digit byte) {
	switch digit {
	case '0':
		bs.d0++
		break
	case '1':
		bs.d1++
		break
	}
}

func ComputeStats(n int) BinaryStats {
	var s = fmt.Sprintf("%b", n)
	var bs BinaryStats
	for i := 0; i < len(s); i++ {
		bs.Update(s[i])
	}
	return bs
}

func main() {
	const CHARS = "abcdefghijklmopqrstuvwyz"
	for i := 0; i < len(CHARS); i++ {
		c := int(CHARS[i])
		fmt.Printf("%c -> %b - %v\n", c, c, ComputeStats(c))
	}
}
