package com.employeemanagement.branch.repository;

import com.employeemanagement.branch.entity.Branch;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface BranchRepository extends JpaRepository<Branch, UUID> {

    boolean existsByCompanyIdAndBranchCode(
            UUID companyId,
            String branchCode
    );

    List<Branch> findAllByCompanyId(UUID companyId);
}