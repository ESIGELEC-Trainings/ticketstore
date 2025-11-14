package com.ticketstore;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@SpringBootApplication
@EnableCaching
public class TicketStoreApplication {

	public static void main(String[] args) {
		SpringApplication.run(TicketStoreApplication.class, args);
	}
}
