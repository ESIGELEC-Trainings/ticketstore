package com.ticketstore.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

public class EventDTO {
	private UUID id;
	private String title;
	private String description;
	private String imageUrl;
	private LocalDateTime date;
	private BigDecimal price;
	private Integer ticketsAvailable;

	public EventDTO() {
	}

	public EventDTO(UUID id, String title, String description, String imageUrl, 
	                LocalDateTime date, BigDecimal price, Integer ticketsAvailable) {
		this.id = id;
		this.title = title;
		this.description = description;
		this.imageUrl = imageUrl;
		this.date = date;
		this.price = price;
		this.ticketsAvailable = ticketsAvailable;
	}

	// Getters and Setters
	public UUID getId() {
		return id;
	}

	public void setId(UUID id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public LocalDateTime getDate() {
		return date;
	}

	public void setDate(LocalDateTime date) {
		this.date = date;
	}

	public BigDecimal getPrice() {
		return price;
	}

	public void setPrice(BigDecimal price) {
		this.price = price;
	}

	public Integer getTicketsAvailable() {
		return ticketsAvailable;
	}

	public void setTicketsAvailable(Integer ticketsAvailable) {
		this.ticketsAvailable = ticketsAvailable;
	}
}
