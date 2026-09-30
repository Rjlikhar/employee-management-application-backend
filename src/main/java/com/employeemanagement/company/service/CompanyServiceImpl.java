package com.employeemanagement.company.service;

import com.employeemanagement.company.dto.CompanyRequest;
import com.employeemanagement.company.dto.CompanyResponse;
import com.employeemanagement.company.entity.Company;
import com.employeemanagement.company.repository.CompanyRepository;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@Transactional
public class CompanyServiceImpl implements CompanyService {

    private final CompanyRepository companyRepository;

    public CompanyServiceImpl(CompanyRepository companyRepository) {
        this.companyRepository = companyRepository;
    }

    @Override
    public CompanyResponse createCompany(CompanyRequest request) {

        if (companyRepository.existsByCompanyCode(request.getCompanyCode())) {
            throw new RuntimeException(
                    "Company with code " + request.getCompanyCode() + " already exists"
            );
        }

        Company company = new Company();

        mapRequestToEntity(request, company);

        Company savedCompany = companyRepository.save(company);

        return mapEntityToResponse(savedCompany);
    }

    @Override
    @Transactional(readOnly = true)
    public CompanyResponse getCompanyById(UUID companyId) {

        Company company = companyRepository.findById(companyId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Company with id " + companyId + " not found"
                        )
                );

        return mapEntityToResponse(company);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CompanyResponse> getAllCompanies() {

        return companyRepository.findAll()
                .stream()
                .map(this::mapEntityToResponse)
                .collect(Collectors.toList());
    }

    @Override
    public CompanyResponse updateCompany(
            UUID companyId,
            CompanyRequest request
    ) {

        Company company = companyRepository.findById(companyId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Company with id " + companyId + " not found"
                        )
                );

        if (!company.getCompanyCode().equals(request.getCompanyCode())
                && companyRepository.existsByCompanyCode(request.getCompanyCode())) {

            throw new RuntimeException(
                    "Company with code " + request.getCompanyCode() + " already exists"
            );
        }

        mapRequestToEntity(request, company);

        Company updatedCompany = companyRepository.save(company);

        return mapEntityToResponse(updatedCompany);
    }

    @Override
    public void deleteCompany(UUID companyId) {

        Company company = companyRepository.findById(companyId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Company with id " + companyId + " not found"
                        )
                );

        companyRepository.delete(company);
    }

    private void mapRequestToEntity(
            CompanyRequest request,
            Company company
    ) {

        company.setCompanyCode(request.getCompanyCode());
        company.setCompanyName(request.getCompanyName());
        company.setLegalName(request.getLegalName());
        company.setEmail(request.getEmail());
        company.setPhone(request.getPhone());
        company.setWebsite(request.getWebsite());
        company.setRegistrationNumber(request.getRegistrationNumber());
        company.setTaxIdentifier(request.getTaxIdentifier());
        company.setCountry(request.getCountry());
        company.setTimezone(request.getTimezone());
        company.setCurrencyCode(request.getCurrencyCode());
        company.setStatus(request.getStatus());
    }

    private CompanyResponse mapEntityToResponse(Company company) {

        CompanyResponse response = new CompanyResponse();

        response.setCompanyId(company.getCompanyId());
        response.setCompanyCode(company.getCompanyCode());
        response.setCompanyName(company.getCompanyName());
        response.setLegalName(company.getLegalName());
        response.setEmail(company.getEmail());
        response.setPhone(company.getPhone());
        response.setWebsite(company.getWebsite());
        response.setRegistrationNumber(company.getRegistrationNumber());
        response.setTaxIdentifier(company.getTaxIdentifier());
        response.setCountry(company.getCountry());
        response.setTimezone(company.getTimezone());
        response.setCurrencyCode(company.getCurrencyCode());
        response.setStatus(company.getStatus());
        response.setCreatedAt(company.getCreatedAt());
        response.setUpdatedAt(company.getUpdatedAt());

        return response;
    }
}