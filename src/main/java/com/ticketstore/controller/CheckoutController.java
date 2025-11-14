package com.ticketstore.controller;

import java.util.Map;
import java.util.UUID;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ticketstore.service.CheckoutService;

@RestController
@RequestMapping("/api/checkout")
@CrossOrigin
public class CheckoutController {

	private final CheckoutService checkoutService;

	public CheckoutController(CheckoutService checkoutService) {
		this.checkoutService = checkoutService;
	}

	@PostMapping
	public boolean checkout(@RequestBody Map<String, Object> payload) {
		UUID eventId = UUID.fromString(payload.get("eventId").toString());
		Integer quantity = Integer.parseInt(payload.get("quantity").toString());
		return checkoutService.checkout(eventId, quantity);
	}
}
