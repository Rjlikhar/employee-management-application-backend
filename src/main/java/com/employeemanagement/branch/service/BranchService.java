package com.employeemanagement.branch.service;

import com.employeemanagement.branch.dto.BranchRequest;
import com.employeemanagement.branch.dto.BranchResponse;

import java.util.List;
import java.util.UUID;

public interface BranchService {

    BranchResponse createBranch(
            UUID companyId,
            BranchRequest request
    );

    BranchResponse getBranchById(UUID branchId);

    List<BranchResponse> getBranchesByCompanyId(UUID companyId);

    BranchResponse updateBranch(
            UUID branchId,
            BranchRequest request
    );

    void deleteBranch(UUID branchId);
}