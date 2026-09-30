package com.employeemanagement.company.repository;

import com.employeemanagement.company.entity.Company;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface CompanyRepository extends JpaRepository<Company, UUID> {

    boolean existsByCompanyCode(String companyCode);

    Optional<Company> findByCompanyCode(String companyCode);
}