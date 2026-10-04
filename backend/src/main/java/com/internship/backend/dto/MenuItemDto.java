package com.internship.backend.dto;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MenuItemDto {

    private Long id;
    private String name;
    private String category;
    private double price;
    private boolean available;


}
