package com.ticketstore.dto;

import java.util.UUID;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public class CheckoutRequest {
	
	@NotNull
	private UUID eventId;
	
	@NotNull
	@Min(1)
	private Integer quantity;

	public CheckoutRequest() {
	}

	public CheckoutRequest(UUID eventId, Integer quantity) {
		this.eventId = eventId;
		this.quantity = quantity;
	}

	public UUID getEventId() {
		return eventId;
	}

	public void setEventId(UUID eventId) {
		this.eventId = eventId;
	}

	public Integer getQuantity() {
		return quantity;
	}

	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}
}
