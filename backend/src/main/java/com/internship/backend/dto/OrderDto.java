package com.internship.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.Instant;
import java.util.List;


@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class OrderDto {

    private Long id;
    private String customerName;
    private List<OrderLineDto> items;
    private double total;
    private String status;
    private Instant createdAt;


}
