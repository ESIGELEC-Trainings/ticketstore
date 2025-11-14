package com.ticketstore.service;

import org.springframework.stereotype.Service;

@Service
public class CheckoutService {

	private final OrderService orderService;

	public CheckoutService(OrderService orderService) {
		this.orderService = orderService;
	}

	public boolean checkout(java.util.UUID eventId, int quantity) {
		try {
			Thread.sleep(1500);
		} catch (InterruptedException ignored) {
		}

		return orderService.placeOrder(eventId, quantity);
	}
}
