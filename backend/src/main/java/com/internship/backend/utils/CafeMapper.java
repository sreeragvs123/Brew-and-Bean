package com.internship.backend.utils;


import com.internship.backend.dto.MenuItemDto;
import com.internship.backend.dto.OrderDto;
import com.internship.backend.dto.OrderLineDto;
import com.internship.backend.entities.CafeOrder;
import com.internship.backend.entities.MenuItem;
import com.internship.backend.entities.OrderItem;

import java.util.List;

public final class CafeMapper {

    private CafeMapper() {
    }

    public static MenuItemDto toMenuItemDto(MenuItem item) {
        return new MenuItemDto(item.getId(), item.getName(), item.getCategory(),
                item.getPrice(), item.isAvailable());
    }

    public static OrderLineDto toOrderLineDto(OrderItem item) {
        return new OrderLineDto(item.getMenuItemId(), item.getName(), item.getQuantity(), item.getPrice());
    }

    public static OrderDto toOrderDto(CafeOrder order) {
        List<OrderLineDto> lines = order.getItems().stream()
                .map(CafeMapper::toOrderLineDto)
                .toList();
        return new OrderDto(order.getId(), order.getCustomerName(), lines,
                order.getTotal(), order.getStatus().name(), order.getCreatedAt());
    }
}
