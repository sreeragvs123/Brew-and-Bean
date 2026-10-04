package com.internship.backend.repositories;


import com.internship.backend.entities.CafeOrder;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface OrderRepository extends JpaRepository<CafeOrder, Long> {

    List<CafeOrder> findAllByOrderByCreatedAtDesc();
}
