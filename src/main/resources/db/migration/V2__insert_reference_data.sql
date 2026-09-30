-- ============================================================
-- V2__insert_reference_data.sql
-- Initial global/static reference data
-- ============================================================

-- -------------------------
-- Roles
-- -------------------------
INSERT INTO roles (role_code, role_name, description, is_active)
VALUES
('SUPER_ADMIN', 'Super Admin', 'Platform level administrator', TRUE),
('COMPANY_ADMIN', 'Company Admin', 'Administrator of a company', TRUE),
('HR', 'HR', 'Human Resources user', TRUE),
('MANAGER', 'Manager', 'Reporting manager', TRUE),
('PAYROLL', 'Payroll', 'Payroll processing user', TRUE),
('EMPLOYEE', 'Employee', 'Regular employee user', TRUE);


-- -------------------------
-- Employment Statuses
-- -------------------------
INSERT INTO employment_statuses
(status_code, status_name, description, is_active)
VALUES
('ACTIVE', 'Active', 'Employee is currently active', TRUE),
('PROBATION', 'Probation', 'Employee is under probation', TRUE),
('NOTICE_PERIOD', 'Notice Period', 'Employee is serving notice period', TRUE),
('RESIGNED', 'Resigned', 'Employee has resigned', TRUE),
('TERMINATED', 'Terminated', 'Employee employment was terminated', TRUE),
('INACTIVE', 'Inactive', 'Employee is inactive', TRUE);


-- -------------------------
-- Genders
-- -------------------------
INSERT INTO genders
(gender_code, gender_name, is_active)
VALUES
('MALE', 'Male', TRUE),
('FEMALE', 'Female', TRUE),
('OTHER', 'Other', TRUE),
('PREFER_NOT_TO_SAY', 'Prefer Not To Say', TRUE);


-- -------------------------
-- Contact Types
-- -------------------------
INSERT INTO contact_types
(contact_type_code, contact_type_name, is_active)
VALUES
('PERSONAL', 'Personal Contact', TRUE),
('EMERGENCY', 'Emergency Contact', TRUE);


-- -------------------------
-- Address Types
-- -------------------------
INSERT INTO address_types
(address_type_code, address_type_name, is_active)
VALUES
('CURRENT', 'Current Address', TRUE),
('PERMANENT', 'Permanent Address', TRUE);


-- -------------------------
-- Attendance Statuses
-- -------------------------
INSERT INTO attendance_statuses
(status_code, status_name, description, is_active)
VALUES
('PRESENT', 'Present', 'Employee was present', TRUE),
('ABSENT', 'Absent', 'Employee was absent', TRUE),
('HALF_DAY', 'Half Day', 'Employee worked half day', TRUE),
('LEAVE', 'Leave', 'Employee was on approved leave', TRUE),
('HOLIDAY', 'Holiday', 'Company holiday', TRUE),
('WEEK_OFF', 'Week Off', 'Scheduled weekly off', TRUE);


-- -------------------------
-- Leave Statuses
-- -------------------------
INSERT INTO leave_statuses
(status_code, status_name, description, is_active)
VALUES
('PENDING', 'Pending', 'Leave request is awaiting approval', TRUE),
('APPROVED', 'Approved', 'Leave request has been approved', TRUE),
('REJECTED', 'Rejected', 'Leave request has been rejected', TRUE),
('CANCELLED', 'Cancelled', 'Leave request was cancelled', TRUE);


-- -------------------------
-- Payroll Statuses
-- -------------------------
INSERT INTO payroll_statuses
(status_code, status_name, description, is_active)
VALUES
('DRAFT', 'Draft', 'Payroll is being prepared', TRUE),
('PROCESSED', 'Processed', 'Payroll calculation is completed', TRUE),
('PAID', 'Paid', 'Salary has been paid', TRUE),
('CANCELLED', 'Cancelled', 'Payroll was cancelled', TRUE);