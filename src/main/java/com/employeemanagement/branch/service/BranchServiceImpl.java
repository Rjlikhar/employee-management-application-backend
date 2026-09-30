package com.employeemanagement.branch.service;

import com.employeemanagement.branch.dto.BranchRequest;
import com.employeemanagement.branch.dto.BranchResponse;
import com.employeemanagement.branch.entity.Branch;
import com.employeemanagement.branch.repository.BranchRepository;
import com.employeemanagement.company.entity.Company;
import com.employeemanagement.company.repository.CompanyRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@Transactional
public class BranchServiceImpl implements BranchService {

    private final BranchRepository branchRepository;
    private final CompanyRepository companyRepository;

    public BranchServiceImpl(
            BranchRepository branchRepository,
            CompanyRepository companyRepository
    ) {
        this.branchRepository = branchRepository;
        this.companyRepository = companyRepository;
    }

    @Override
    public BranchResponse createBranch(
            UUID companyId,
            BranchRequest request
    ) {

        // 1. Verify parent company exists
        Company company = companyRepository.findById(companyId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Company not found: " + companyId
                        )
                );

        // 2. Check duplicate branch code inside company
        if (branchRepository.existsByCompanyIdAndBranchCode(
                companyId,
                request.getBranchCode()
        )) {
            throw new RuntimeException(
                    "Branch code already exists: "
                            + request.getBranchCode()
            );
        }

        // 3. Create branch
        Branch branch = new Branch();

        branch.setCompanyId(company.getCompanyId());
        branch.setBranchCode(request.getBranchCode());
        branch.setBranchName(request.getBranchName());
        branch.setAddressLine1(request.getAddressLine1());
        branch.setAddressLine2(request.getAddressLine2());
        branch.setCity(request.getCity());
        branch.setState(request.getState());
        branch.setPostalCode(request.getPostalCode());
        branch.setCountry(request.getCountry());
        branch.setPhone(request.getPhone());
        branch.setEmail(request.getEmail());

        if (request.getStatus() != null) {
            branch.setStatus(request.getStatus());
        }

        // 4. Save
        Branch savedBranch = branchRepository.save(branch);

        // 5. Convert Entity -> Response
        return mapToResponse(savedBranch);
    }

    @Override
    @Transactional(readOnly = true)
    public BranchResponse getBranchById(UUID branchId) {

        Branch branch = branchRepository.findById(branchId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Branch not found: " + branchId
                        )
                );

        return mapToResponse(branch);
    }

    @Override
    @Transactional(readOnly = true)
    public List<BranchResponse> getBranchesByCompanyId(
            UUID companyId
    ) {

        // Verify company exists
        companyRepository.findById(companyId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Company not found: " + companyId
                        )
                );

        return branchRepository
                .findAllByCompanyId(companyId)
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    @Override
    public BranchResponse updateBranch(
            UUID branchId,
            BranchRequest request
    ) {

        Branch branch = branchRepository.findById(branchId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Branch not found: " + branchId
                        )
                );

        // Check duplicate code only when code is changed
        if (!branch.getBranchCode()
                .equals(request.getBranchCode())
                && branchRepository.existsByCompanyIdAndBranchCode(
                        branch.getCompanyId(),
                        request.getBranchCode()
                )) {

            throw new RuntimeException(
                    "Branch code already exists: "
                            + request.getBranchCode()
            );
        }

        branch.setBranchCode(request.getBranchCode());
        branch.setBranchName(request.getBranchName());
        branch.setAddressLine1(request.getAddressLine1());
        branch.setAddressLine2(request.getAddressLine2());
        branch.setCity(request.getCity());
        branch.setState(request.getState());
        branch.setPostalCode(request.getPostalCode());
        branch.setCountry(request.getCountry());
        branch.setPhone(request.getPhone());
        branch.setEmail(request.getEmail());

        if (request.getStatus() != null) {
            branch.setStatus(request.getStatus());
        }

        Branch updatedBranch = branchRepository.save(branch);

        return mapToResponse(updatedBranch);
    }

    @Override
    public void deleteBranch(UUID branchId) {

        Branch branch = branchRepository.findById(branchId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Branch not found: " + branchId
                        )
                );

        branchRepository.delete(branch);
    }

    private BranchResponse mapToResponse(Branch branch) {

        BranchResponse response = new BranchResponse();

        response.setBranchId(branch.getBranchId());
        response.setCompanyId(branch.getCompanyId());
        response.setBranchCode(branch.getBranchCode());
        response.setBranchName(branch.getBranchName());
        response.setAddressLine1(branch.getAddressLine1());
        response.setAddressLine2(branch.getAddressLine2());
        response.setCity(branch.getCity());
        response.setState(branch.getState());
        response.setPostalCode(branch.getPostalCode());
        response.setCountry(branch.getCountry());
        response.setPhone(branch.getPhone());
        response.setEmail(branch.getEmail());
        response.setStatus(branch.getStatus());
        response.setCreatedAt(branch.getCreatedAt());
        response.setUpdatedAt(branch.getUpdatedAt());

        return response;
    }
}