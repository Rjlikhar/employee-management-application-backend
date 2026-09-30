package com.employeemanagement.company.controller;

import com.employeemanagement.company.dto.CompanyRequest;
import com.employeemanagement.company.dto.CompanyResponse;
import com.employeemanagement.company.service.CompanyService;

import jakarta.validation.Valid;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/companies")
public class CompanyController {

    private final CompanyService companyService;

    public CompanyController(CompanyService companyService) {
        this.companyService = companyService;
    }

    @PostMapping
    public ResponseEntity<CompanyResponse> createCompany(
            @Valid @RequestBody CompanyRequest request) {

        CompanyResponse response = companyService.createCompany(request);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(response);
    }

    @GetMapping("/{companyId}")
    public ResponseEntity<CompanyResponse> getCompanyById(
            @PathVariable UUID companyId) {

        return ResponseEntity.ok(
                companyService.getCompanyById(companyId)
        );
    }

    @GetMapping
    public ResponseEntity<List<CompanyResponse>> getAllCompanies() {

        return ResponseEntity.ok(
                companyService.getAllCompanies()
        );
    }

    @PutMapping("/{companyId}")
    public ResponseEntity<CompanyResponse> updateCompany(
            @PathVariable UUID companyId,
            @Valid @RequestBody CompanyRequest request) {

        return ResponseEntity.ok(
                companyService.updateCompany(companyId, request)
        );
    }

    @DeleteMapping("/{companyId}")
    public ResponseEntity<Void> deleteCompany(
            @PathVariable UUID companyId) {

        companyService.deleteCompany(companyId);

        return ResponseEntity.noContent().build();
    }
}