package com.internship.backend.controllers;

import com.internship.backend.dto.OrderDto;
import com.internship.backend.dto.PlaceOrderRequest;
import com.internship.backend.entities.OrderStatus;

import com.internship.backend.services.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/orders")
public class OrderController {

    private final OrderService orderService;


    @GetMapping
    public List<OrderDto> getOrders() {
        return orderService.getOrders();
    }

    @PostMapping
    public OrderDto placeOrder(@RequestBody PlaceOrderRequest request) {
        return orderService.placeOrder(request);
    }

    @PatchMapping("/{id}/status")
    public OrderDto updateStatus(@PathVariable Long id, @RequestParam OrderStatus status) {
        return orderService.updateStatus(id, status);
    }
}
