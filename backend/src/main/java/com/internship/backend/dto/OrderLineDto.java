package com.internship.backend.dto;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class OrderLineDto {

    private Long menuItemId;
    private String name;
    private int quantity;
    private double price;


}
