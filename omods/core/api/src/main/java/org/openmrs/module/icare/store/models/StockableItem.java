package org.openmrs.module.icare.store.models;

import org.openmrs.Location;
import org.openmrs.module.icare.core.Item;
import org.openmrs.module.icare.store.util.Stockable;

import java.util.Date;

public class StockableItem implements Stockable {
	
	private Item item;
	
	private String batch;
	
	private Date expiryDate;
	
	private Double quantity;
	
	private Location location;
	
	@Override
	public Item getItem() {
		return item;
	}
	
	@Override
	public String getBatchNo() {
		return batch;
	}
	
	@Override
	public Date getExpiryDate() {
		return expiryDate;
	}
	
	@Override
	public Double getQuantity() {
		return quantity;
	}
	
	@Override
	public Location getLocation() {
		return location;
	}
	
	public void setItem(Item item) {
		this.item = item;
	}
	
	public void setBatch(String batch) {
		this.batch = batch;
	}
	
	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}
	
	public void setQuantity(Double quantity) {
		this.quantity = quantity;
	}
	
	public void setLocation(Location location) {
		this.location = location;
	}
}
