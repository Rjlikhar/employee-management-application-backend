package com.employeemanagement.company.service;

import com.employeemanagement.company.dto.CompanyRequest;
import com.employeemanagement.company.dto.CompanyResponse;

import java.util.List;
import java.util.UUID;

public interface CompanyService {

    CompanyResponse createCompany(CompanyRequest request);

    CompanyResponse getCompanyById(UUID companyId);

    List<CompanyResponse> getAllCompanies();

    CompanyResponse updateCompany(UUID companyId, CompanyRequest request);

    void deleteCompany(UUID companyId);
}