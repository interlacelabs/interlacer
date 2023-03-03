package main

import (
	"io"
	"fmt"
	"net/http"
	"time"
)

func main() {

	fmt.Println("Starting...")
	var client http.Client
	resp, err := client.Get("http://myip.dnsomatic.com")
	if err == nil {
		defer resp.Body.Close()
		
		fmt.Println("HTTP Response Status:", resp.StatusCode, http.StatusText(resp.StatusCode))
		if resp.StatusCode == http.StatusOK {
			bodyBytes, err := io.ReadAll(resp.Body)
			if err != nil {
				fmt.Println(err)
			}
			bodyString := string(bodyBytes)
			fmt.Println(bodyString)
			time.Sleep(5 * time.Second)
		}
		
	}else{
		fmt.Println(err)
	}

	fmt.Println("Done.")

		
}
