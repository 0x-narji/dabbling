package main

import (
	"fmt"
	"os"
	"os/signal"
	"time"
)

var (
	start = time.Now()
)

func setupCtrlC() {
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	go func(c chan os.Signal) {
		for sig := range c {
			fmt.Printf("\n\nSignal [%q] has been caught .. we exit !\n", sig)
			shutDown(-1)
		}
	}(c)
}

func shutDown(exitCode int) {
	var stop = time.Now()
	fmt.Printf("We stop (defer) @ %v ..\n", stop)
	os.Exit(exitCode)
}

func main() {
	setupCtrlC()
	fmt.Printf("We started @ %v !\n", start)
	defer shutDown(0)
	for range make([]int, 1000) {
		fmt.Printf("%v\r", time.Now().UnixNano())
		time.Sleep(3 * time.Millisecond)
	}
	fmt.Println()
}
