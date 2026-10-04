package com.internship.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/** Used both as the request body and as the pushed event payload. */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class AnnouncementDto {

    private String message;


}
