package com.internship.backend.services;

import com.internship.backend.dto.OrderDto;
import com.internship.backend.dto.OrderLineRequest;
import com.internship.backend.dto.PlaceOrderRequest;
import com.internship.backend.entities.CafeOrder;
import com.internship.backend.entities.MenuItem;
import com.internship.backend.entities.OrderItem;
import com.internship.backend.entities.OrderStatus;
import com.internship.backend.repositories.MenuItemRepository;
import com.internship.backend.repositories.OrderRepository;
import com.internship.backend.utils.CafeMapper;
import com.internship.backend.utils.SseEvents;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.Instant;
import java.util.List;

@Service
public class OrderService {

    private final OrderRepository orderRepository;
    private final MenuItemRepository menuItemRepository;
    private final EventBroadcaster eventBroadcaster;

    public OrderService(OrderRepository orderRepository,
                        MenuItemRepository menuItemRepository,
                        EventBroadcaster eventBroadcaster) {
        this.orderRepository = orderRepository;
        this.menuItemRepository = menuItemRepository;
        this.eventBroadcaster = eventBroadcaster;
    }

    @Transactional(readOnly = true)
    public List<OrderDto> getOrders() {
        return orderRepository.findAllByOrderByCreatedAtDesc().stream()
                .map(CafeMapper::toOrderDto)
                .toList();
    }

    @Transactional
    public OrderDto placeOrder(PlaceOrderRequest request) {
        if (request.getItems() == null || request.getItems().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Your cart is empty");
        }

        CafeOrder order = new CafeOrder();
        order.setCustomerName(cleanName(request.getCustomerName()));
        order.setStatus(OrderStatus.PLACED);
        order.setCreatedAt(Instant.now());

        double total = 0;
        for (OrderLineRequest line : request.getItems()) {
            MenuItem menuItem = findAvailableItem(line);
            order.addItem(new OrderItem(menuItem.getId(), menuItem.getName(),
                    line.getQuantity(), menuItem.getPrice()));
            total += menuItem.getPrice() * line.getQuantity();
        }
        order.setTotal(total);

        OrderDto dto = CafeMapper.toOrderDto(orderRepository.save(order));
        eventBroadcaster.publish(SseEvents.ORDER, dto);
        return dto;
    }

    @Transactional
    public OrderDto updateStatus(Long id, OrderStatus status) {
        CafeOrder order = orderRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Order not found"));

        order.setStatus(status);
        OrderDto dto = CafeMapper.toOrderDto(orderRepository.save(order));

        eventBroadcaster.publish(SseEvents.ORDER, dto);
        return dto;
    }

    private MenuItem findAvailableItem(OrderLineRequest line) {
        if (line.getMenuItemId() == null || line.getQuantity() < 1) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid order line");
        }
        return menuItemRepository.findById(line.getMenuItemId())
                .filter(MenuItem::isAvailable)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.BAD_REQUEST, "An item in your cart is no longer available"));
    }

    private String cleanName(String name) {
        return (name == null || name.isBlank()) ? "Guest" : name.trim();
    }
}
