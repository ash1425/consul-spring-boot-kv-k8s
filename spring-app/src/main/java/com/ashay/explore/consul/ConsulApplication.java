package com.ashay.explore.consul;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class ConsulApplication {

    @Value("${message}")
    private String message;

    public static void main(String[] args) {
        SpringApplication.run(ConsulApplication.class, args);
    }

    @GetMapping("/message")
    public String getMessage() {
        return message;
    }
}
