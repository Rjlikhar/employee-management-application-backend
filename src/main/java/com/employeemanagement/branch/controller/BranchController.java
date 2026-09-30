package com.employeemanagement.branch.controller;

import com.employeemanagement.branch.dto.BranchRequest;
import com.employeemanagement.branch.dto.BranchResponse;
import com.employeemanagement.branch.service.BranchService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1")
public class BranchController {

    private final BranchService branchService;

    public BranchController(BranchService branchService) {
        this.branchService = branchService;
    }

    // =========================================================
    // CREATE BRANCH
    // =========================================================

    @PostMapping("/companies/{companyId}/branches")
    public ResponseEntity<BranchResponse> createBranch(
            @PathVariable UUID companyId,
            @Valid @RequestBody BranchRequest request
    ) {

        BranchResponse response =
                branchService.createBranch(companyId, request);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(response);
    }

    // =========================================================
    // GET BRANCH BY ID
    // =========================================================

    @GetMapping("/branches/{branchId}")
    public ResponseEntity<BranchResponse> getBranchById(
            @PathVariable UUID branchId
    ) {

        return ResponseEntity.ok(
                branchService.getBranchById(branchId)
        );
    }

    // =========================================================
    // GET ALL BRANCHES OF COMPANY
    // =========================================================

    @GetMapping("/companies/{companyId}/branches")
    public ResponseEntity<List<BranchResponse>> getBranchesByCompanyId(
            @PathVariable UUID companyId
    ) {

        return ResponseEntity.ok(
                branchService.getBranchesByCompanyId(companyId)
        );
    }

    // =========================================================
    // UPDATE BRANCH
    // =========================================================

    @PutMapping("/branches/{branchId}")
    public ResponseEntity<BranchResponse> updateBranch(
            @PathVariable UUID branchId,
            @Valid @RequestBody BranchRequest request
    ) {

        return ResponseEntity.ok(
                branchService.updateBranch(branchId, request)
        );
    }

    // =========================================================
    // DELETE BRANCH
    // =========================================================

    @DeleteMapping("/branches/{branchId}")
    public ResponseEntity<Void> deleteBranch(
            @PathVariable UUID branchId
    ) {

        branchService.deleteBranch(branchId);

        return ResponseEntity.noContent().build();
    }
}