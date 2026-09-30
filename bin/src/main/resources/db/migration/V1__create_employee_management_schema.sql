-- ============================================================
-- V1__create_employee_management_schema.sql
-- Employee Management & Payroll Management System
--
-- ID strategy:
--   - Domain/business entities: UUID stored as BINARY(16)
--   - Java/JPA: java.util.UUID + GenerationType.UUID
--   - Static/global reference data: stable VARCHAR code as PK
--   - Foreign keys use the same physical type as their PK
--
-- Flyway owns the schema.
-- Hibernate should use: spring.jpa.hibernate.ddl-auto=validate
-- ============================================================

CREATE TABLE companies (
    company_id          BINARY(16) NOT NULL,
    company_code        VARCHAR(50) NOT NULL,
    company_name        VARCHAR(150) NOT NULL,
    legal_name          VARCHAR(200),
    email               VARCHAR(150),
    phone               VARCHAR(30),
    website             VARCHAR(255),
    registration_number VARCHAR(100),
    tax_identifier      VARCHAR(100),
    country             VARCHAR(100),
    timezone            VARCHAR(100),
    currency_code       VARCHAR(10),
    status              VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at          TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at          TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                         ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT pk_companies PRIMARY KEY (company_id),
    CONSTRAINT uk_companies_code UNIQUE (company_code)
);

CREATE TABLE branches (
    branch_id      BINARY(16) NOT NULL,
    company_id     BINARY(16) NOT NULL,
    branch_code    VARCHAR(50) NOT NULL,
    branch_name    VARCHAR(150) NOT NULL,
    address_line1  VARCHAR(255),
    address_line2  VARCHAR(255),
    city           VARCHAR(100),
    state          VARCHAR(100),
    postal_code    VARCHAR(20),
    country        VARCHAR(100),
    phone          VARCHAR(30),
    email          VARCHAR(150),
    status         VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at     TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at     TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                   ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT pk_branches PRIMARY KEY (branch_id),
    CONSTRAINT uk_branches_company_code UNIQUE (company_id, branch_code),
    CONSTRAINT fk_branches_company
        FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

CREATE TABLE departments (
    department_id   BINARY(16) NOT NULL,
    company_id      BINARY(16) NOT NULL,
    department_code VARCHAR(50) NOT NULL,
    department_name VARCHAR(150) NOT NULL,
    description     VARCHAR(500),
    status          VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at      TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at      TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                    ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT pk_departments PRIMARY KEY (department_id),
    CONSTRAINT uk_departments_company_code UNIQUE (company_id, department_code),
    CONSTRAINT fk_departments_company
        FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

CREATE TABLE designations (
    designation_id   BINARY(16) NOT NULL,
    company_id       BINARY(16) NOT NULL,
    designation_code VARCHAR(50) NOT NULL,
    designation_name VARCHAR(150) NOT NULL,
    description      VARCHAR(500),
    status           VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at       TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at       TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                     ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT pk_designations PRIMARY KEY (designation_id),
    CONSTRAINT uk_designations_company_code UNIQUE (company_id, designation_code),
    CONSTRAINT fk_designations_company
        FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

CREATE TABLE employment_types (
    employment_type_id   BINARY(16) NOT NULL,
    company_id           BINARY(16) NOT NULL,
    employment_type_code VARCHAR(50) NOT NULL,
    employment_type_name VARCHAR(100) NOT NULL,
    description          VARCHAR(500),
    status               VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at           TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at           TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                         ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT pk_employment_types PRIMARY KEY (employment_type_id),
    CONSTRAINT uk_employment_types_company_code
        UNIQUE (company_id, employment_type_code),
    CONSTRAINT fk_employment_types_company
        FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

-- ============================================================
-- Global/static reference data
-- Stable codes are used as natural primary keys.
-- These tables do not need generated UUIDs.
-- ============================================================

CREATE TABLE employment_statuses (
    status_code  VARCHAR(50) NOT NULL,
    status_name  VARCHAR(100) NOT NULL,
    description  VARCHAR(500),
    is_active    BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT pk_employment_statuses PRIMARY KEY (status_code)
);

CREATE TABLE roles (
    role_code    VARCHAR(50) NOT NULL,
    role_name    VARCHAR(100) NOT NULL,
    description  VARCHAR(500),
    is_active    BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT pk_roles PRIMARY KEY (role_code)
);

CREATE TABLE genders (
    gender_code  VARCHAR(50) NOT NULL,
    gender_name  VARCHAR(100) NOT NULL,
    is_active    BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT pk_genders PRIMARY KEY (gender_code)
);

CREATE TABLE contact_types (
    contact_type_code VARCHAR(50) NOT NULL,
    contact_type_name VARCHAR(100) NOT NULL,
    is_active         BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT pk_contact_types PRIMARY KEY (contact_type_code)
);

CREATE TABLE address_types (
    address_type_code VARCHAR(50) NOT NULL,
    address_type_name VARCHAR(100) NOT NULL,
    is_active         BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT pk_address_types PRIMARY KEY (address_type_code)
);

CREATE TABLE attendance_statuses (
    status_code  VARCHAR(50) NOT NULL,
    status_name  VARCHAR(100) NOT NULL,
    description  VARCHAR(500),
    is_active    BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT pk_attendance_statuses PRIMARY KEY (status_code)
);

CREATE TABLE leave_statuses (
    status_code  VARCHAR(50) NOT NULL,
    status_name  VARCHAR(100) NOT NULL,
    description  VARCHAR(500),
    is_active    BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT pk_leave_statuses PRIMARY KEY (status_code)
);

CREATE TABLE payroll_statuses (
    status_code  VARCHAR(50) NOT NULL,
    status_name  VARCHAR(100) NOT NULL,
    description  VARCHAR(500),
    is_active    BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT pk_payroll_statuses PRIMARY KEY (status_code)
);

CREATE TABLE work_shifts (
    shift_id        BINARY(16) NOT NULL,
    company_id      BINARY(16) NOT NULL,
    shift_code      VARCHAR(50) NOT NULL,
    shift_name      VARCHAR(100) NOT NULL,
    start_time      TIME NOT NULL,
    end_time        TIME NOT NULL,
    break_duration  INT NOT NULL DEFAULT 0,
    working_hours   DECIMAL(5,2) NOT NULL,
    status          VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at      TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at      TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                    ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT pk_work_shifts PRIMARY KEY (shift_id),
    CONSTRAINT uk_work_shifts_company_code UNIQUE (company_id, shift_code),
    CONSTRAINT fk_work_shifts_company
        FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT chk_work_shifts_break_duration CHECK (break_duration >= 0),
    CONSTRAINT chk_work_shifts_working_hours CHECK (working_hours >= 0)
);

-- ============================================================
-- Employee
-- ============================================================

CREATE TABLE employees (
    employee_id              BINARY(16) NOT NULL,
    company_id               BINARY(16) NOT NULL,
    branch_id                BINARY(16),
    employee_code            VARCHAR(50) NOT NULL,
    first_name               VARCHAR(100) NOT NULL,
    middle_name              VARCHAR(100),
    last_name                VARCHAR(100) NOT NULL,
    date_of_birth            DATE,
    gender_code              VARCHAR(50),
    personal_email           VARCHAR(150),
    work_email               VARCHAR(150),
    phone                    VARCHAR(30),
    joining_date             DATE NOT NULL,
    confirmation_date        DATE,
    termination_date         DATE,
    employment_status_code   VARCHAR(50) NOT NULL,
    reporting_manager_id     BINARY(16),
    profile_photo_url        VARCHAR(500),
    created_at               TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at               TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                             ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT pk_employees PRIMARY KEY (employee_id),
    CONSTRAINT uk_employees_company_code UNIQUE (company_id, employee_code),
    CONSTRAINT uk_employees_company_work_email UNIQUE (company_id, work_email),

    CONSTRAINT fk_employees_company
        FOREIGN KEY (company_id) REFERENCES companies(company_id),

    CONSTRAINT fk_employees_branch
        FOREIGN KEY (branch_id) REFERENCES branches(branch_id),

    CONSTRAINT fk_employees_gender
        FOREIGN KEY (gender_code) REFERENCES genders(gender_code),

    CONSTRAINT fk_employees_status
        FOREIGN KEY (employment_status_code)
        REFERENCES employment_statuses(status_code),

    CONSTRAINT fk_employees_manager
        FOREIGN KEY (reporting_manager_id)
        REFERENCES employees(employee_id)
);

-- ============================================================
-- Application users / authentication identity
-- ============================================================

CREATE TABLE users (
    user_id         BINARY(16) NOT NULL,
    company_id      BINARY(16) NOT NULL,
    employee_id     BINARY(16),
    username        VARCHAR(100) NOT NULL,
    password_hash   VARCHAR(255) NOT NULL,
    role_code       VARCHAR(50) NOT NULL,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    last_login_at   TIMESTAMP(6),
    created_at      TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at      TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                    ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT pk_users PRIMARY KEY (user_id),
    CONSTRAINT uk_users_username UNIQUE (username),
    CONSTRAINT uk_users_employee UNIQUE (employee_id),

    CONSTRAINT fk_users_company
        FOREIGN KEY (company_id) REFERENCES companies(company_id),

    CONSTRAINT fk_users_employee
        FOREIGN KEY (employee_id) REFERENCES employees(employee_id),

    CONSTRAINT fk_users_role
        FOREIGN KEY (role_code) REFERENCES roles(role_code)
);

-- ============================================================
-- Employee contact information
-- ============================================================

CREATE TABLE employee_contacts (
    contact_id        BINARY(16) NOT NULL,
    employee_id       BINARY(16) NOT NULL,
    contact_type_code VARCHAR(50) NOT NULL,
    contact_name      VARCHAR(150) NOT NULL,
    relationship      VARCHAR(100),
    phone             VARCHAR(30),
    email             VARCHAR(150),
    is_primary        BOOLEAN NOT NULL DEFAULT FALSE,
    created_at        TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at        TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                      ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT pk_employee_contacts PRIMARY KEY (contact_id),

    CONSTRAINT fk_employee_contacts_employee
        FOREIGN KEY (employee_id) REFERENCES employees(employee_id),

    CONSTRAINT fk_employee_contacts_type
        FOREIGN KEY (contact_type_code)
        REFERENCES contact_types(contact_type_code)
);

-- ============================================================
-- Employee addresses
-- ============================================================

CREATE TABLE employee_addresses (
    address_id        BINARY(16) NOT NULL,
    employee_id       BINARY(16) NOT NULL,
    address_type_code VARCHAR(50) NOT NULL,
    address_line1     VARCHAR(255) NOT NULL,
    address_line2     VARCHAR(255),
    city              VARCHAR(100),
    state             VARCHAR(100),
    postal_code       VARCHAR(20),
    country           VARCHAR(100),
    is_primary        BOOLEAN NOT NULL DEFAULT FALSE,
    created_at        TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at        TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                      ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT pk_employee_addresses PRIMARY KEY (address_id),

    CONSTRAINT fk_employee_addresses_employee
        FOREIGN KEY (employee_id) REFERENCES employees(employee_id),

    CONSTRAINT fk_employee_addresses_type
        FOREIGN KEY (address_type_code)
        REFERENCES address_types(address_type_code)
);

-- ============================================================
-- Effective-dated employee assignments
-- ============================================================

CREATE TABLE employee_assignments (
    assignment_id       BINARY(16) NOT NULL,
    employee_id         BINARY(16) NOT NULL,
    branch_id           BINARY(16),
    department_id       BINARY(16),
    designation_id      BINARY(16),
    employment_type_id  BINARY(16),
    shift_id            BINARY(16),
    effective_from      DATE NOT NULL,
    effective_to        DATE,
    created_at          TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at          TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                        ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT pk_employee_assignments PRIMARY KEY (assignment_id),

    CONSTRAINT fk_assignments_employee
        FOREIGN KEY (employee_id) REFERENCES employees(employee_id),

    CONSTRAINT fk_assignments_branch
        FOREIGN KEY (branch_id) REFERENCES branches(branch_id),

    CONSTRAINT fk_assignments_department
        FOREIGN KEY (department_id) REFERENCES departments(department_id),

    CONSTRAINT fk_assignments_designation
        FOREIGN KEY (designation_id) REFERENCES designations(designation_id),

    CONSTRAINT fk_assignments_employment_type
        FOREIGN KEY (employment_type_id)
        REFERENCES employment_types(employment_type_id),

    CONSTRAINT fk_assignments_shift
        FOREIGN KEY (shift_id) REFERENCES work_shifts(shift_id),

    CONSTRAINT chk_assignments_dates
        CHECK (effective_to IS NULL OR effective_to >= effective_from)
);

-- ============================================================
-- Attendance
-- ============================================================

CREATE TABLE attendance (
    attendance_id        BINARY(16) NOT NULL,
    employee_id          BINARY(16) NOT NULL,
    attendance_date      DATE NOT NULL,
    shift_id             BINARY(16),
    check_in             DATETIME(6),
    check_out            DATETIME(6),
    working_hours        DECIMAL(5,2),
    overtime_hours       DECIMAL(5,2) NOT NULL DEFAULT 0,
    attendance_status_code VARCHAR(50) NOT NULL,
    remarks              VARCHAR(500),
    created_at           TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at           TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                         ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT pk_attendance PRIMARY KEY (attendance_id),
    CONSTRAINT uk_attendance_employee_date
        UNIQUE (employee_id, attendance_date),

    CONSTRAINT fk_attendance_employee
        FOREIGN KEY (employee_id) REFERENCES employees(employee_id),

    CONSTRAINT fk_attendance_shift
        FOREIGN KEY (shift_id) REFERENCES work_shifts(shift_id),

    CONSTRAINT fk_attendance_status
        FOREIGN KEY (attendance_status_code)
        REFERENCES attendance_statuses(status_code),

    CONSTRAINT chk_attendance_working_hours
        CHECK (working_hours IS NULL OR working_hours >= 0),

    CONSTRAINT chk_attendance_overtime_hours
        CHECK (overtime_hours >= 0)
);

-- ============================================================
-- Leave management
-- ============================================================

CREATE TABLE leave_types (
    leave_type_id    BINARY(16) NOT NULL,
    company_id       BINARY(16) NOT NULL,
    leave_type_code  VARCHAR(50) NOT NULL,
    leave_type_name  VARCHAR(100) NOT NULL,
    description      VARCHAR(500),
    is_paid          BOOLEAN NOT NULL DEFAULT TRUE,
    status           VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at       TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at       TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                     ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT pk_leave_types PRIMARY KEY (leave_type_id),
    CONSTRAINT uk_leave_types_company_code
        UNIQUE (company_id, leave_type_code),

    CONSTRAINT fk_leave_types_company
        FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

CREATE TABLE leave_policies (
    leave_policy_id     BINARY(16) NOT NULL,
    company_id          BINARY(16) NOT NULL,
    leave_type_id       BINARY(16) NOT NULL,
    employment_type_id  BINARY(16),
    annual_days         DECIMAL(5,2) NOT NULL,
    carry_forward       BOOLEAN NOT NULL DEFAULT FALSE,
    max_carry_forward_days DECIMAL(5,2),
    encashment_allowed  BOOLEAN NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at          TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                        ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT pk_leave_policies PRIMARY KEY (leave_policy_id),

    CONSTRAINT uk_leave_policies_rule
        UNIQUE (company_id, leave_type_id, employment_type_id),

    CONSTRAINT fk_leave_policies_company
        FOREIGN KEY (company_id) REFERENCES companies(company_id),

    CONSTRAINT fk_leave_policies_leave_type
        FOREIGN KEY (leave_type_id)
        REFERENCES leave_types(leave_type_id),

    CONSTRAINT fk_leave_policies_employment_type
        FOREIGN KEY (employment_type_id)
        REFERENCES employment_types(employment_type_id),

    CONSTRAINT chk_leave_policies_annual_days
        CHECK (annual_days >= 0),

    CONSTRAINT chk_leave_policies_carry_forward_days
        CHECK (
            max_carry_forward_days IS NULL
            OR max_carry_forward_days >= 0
        )
);

CREATE TABLE leave_balances (
    leave_balance_id BINARY(16) NOT NULL,
    employee_id      BINARY(16) NOT NULL,
    leave_type_id    BINARY(16) NOT NULL,
    balance_year     INT NOT NULL,
    allocated_days   DECIMAL(5,2) NOT NULL DEFAULT 0,
    used_days        DECIMAL(5,2) NOT NULL DEFAULT 0,
    carried_forward  DECIMAL(5,2) NOT NULL DEFAULT 0,
    available_days   DECIMAL(5,2) NOT NULL DEFAULT 0,
    created_at       TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at       TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                     ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT pk_leave_balances PRIMARY KEY (leave_balance_id),

    CONSTRAINT uk_leave_balances_employee_type_year
        UNIQUE (employee_id, leave_type_id, balance_year),

    CONSTRAINT fk_leave_balances_employee
        FOREIGN KEY (employee_id) REFERENCES employees(employee_id),

    CONSTRAINT fk_leave_balances_leave_type
        FOREIGN KEY (leave_type_id)
        REFERENCES leave_types(leave_type_id),

    CONSTRAINT chk_leave_balances_allocated
        CHECK (allocated_days >= 0),

    CONSTRAINT chk_leave_balances_used
        CHECK (used_days >= 0),

    CONSTRAINT chk_leave_balances_carried
        CHECK (carried_forward >= 0),

    CONSTRAINT chk_leave_balances_available
        CHECK (available_days >= 0)
);

CREATE TABLE leave_requests (
    leave_request_id   BINARY(16) NOT NULL,
    employee_id        BINARY(16) NOT NULL,
    leave_type_id      BINARY(16) NOT NULL,
    start_date         DATE NOT NULL,
    end_date           DATE NOT NULL,
    total_days         DECIMAL(5,2) NOT NULL,
    reason             VARCHAR(1000),
    leave_status_code  VARCHAR(50) NOT NULL,
    processed_by       BINARY(16),
    processed_at       TIMESTAMP(6),
    rejection_reason   VARCHAR(1000),
    created_at         TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at         TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                       ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT pk_leave_requests PRIMARY KEY (leave_request_id),

    CONSTRAINT fk_leave_requests_employee
        FOREIGN KEY (employee_id) REFERENCES employees(employee_id),

    CONSTRAINT fk_leave_requests_leave_type
        FOREIGN KEY (leave_type_id)
        REFERENCES leave_types(leave_type_id),

    CONSTRAINT fk_leave_requests_status
        FOREIGN KEY (leave_status_code)
        REFERENCES leave_statuses(status_code),

    CONSTRAINT fk_leave_requests_processed_by
        FOREIGN KEY (processed_by)
        REFERENCES users(user_id),

    CONSTRAINT chk_leave_requests_dates
        CHECK (end_date >= start_date),

    CONSTRAINT chk_leave_requests_total_days
        CHECK (total_days > 0)
);

-- ============================================================
-- Salary structure
-- ============================================================

CREATE TABLE salary_components (
    salary_component_id    BINARY(16) NOT NULL,
    company_id             BINARY(16) NOT NULL,
    component_code         VARCHAR(50) NOT NULL,
    component_name         VARCHAR(150) NOT NULL,
    component_type         VARCHAR(30) NOT NULL,
    calculation_type       VARCHAR(30) NOT NULL,
    taxable                BOOLEAN NOT NULL DEFAULT FALSE,
    description            VARCHAR(500),
    status                 VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at             TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at             TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                           ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT pk_salary_components PRIMARY KEY (salary_component_id),
    CONSTRAINT uk_salary_components_company_code
        UNIQUE (company_id, component_code),

    CONSTRAINT fk_salary_components_company
        FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

CREATE TABLE salary_structures (
    salary_structure_id BINARY(16) NOT NULL,
    employee_id         BINARY(16) NOT NULL,
    effective_from      DATE NOT NULL,
    effective_to        DATE,
    currency_code       VARCHAR(10) NOT NULL,
    status              VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at          TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at          TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                        ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT pk_salary_structures PRIMARY KEY (salary_structure_id),

    CONSTRAINT fk_salary_structures_employee
        FOREIGN KEY (employee_id) REFERENCES employees(employee_id),

    CONSTRAINT chk_salary_structures_dates
        CHECK (effective_to IS NULL OR effective_to >= effective_from)
);

CREATE TABLE salary_structure_items (
    salary_structure_item_id BINARY(16) NOT NULL,
    salary_structure_id      BINARY(16) NOT NULL,
    salary_component_id      BINARY(16) NOT NULL,
    amount                   DECIMAL(15,2) NOT NULL,
    percentage               DECIMAL(7,4),
    created_at               TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at               TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                             ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT pk_salary_structure_items
        PRIMARY KEY (salary_structure_item_id),

    CONSTRAINT uk_salary_structure_component
        UNIQUE (salary_structure_id, salary_component_id),

    CONSTRAINT fk_salary_structure_items_structure
        FOREIGN KEY (salary_structure_id)
        REFERENCES salary_structures(salary_structure_id),

    CONSTRAINT fk_salary_structure_items_component
        FOREIGN KEY (salary_component_id)
        REFERENCES salary_components(salary_component_id),

    CONSTRAINT chk_salary_structure_items_amount
        CHECK (amount >= 0),

    CONSTRAINT chk_salary_structure_items_percentage
        CHECK (
            percentage IS NULL
            OR (percentage >= 0 AND percentage <= 100)
        )
);

-- ============================================================
-- Payroll
-- ============================================================

CREATE TABLE payroll (
    payroll_id          BINARY(16) NOT NULL,
    employee_id         BINARY(16) NOT NULL,
    payroll_month       INT NOT NULL,
    payroll_year        INT NOT NULL,
    pay_period_start    DATE NOT NULL,
    pay_period_end      DATE NOT NULL,
    gross_salary        DECIMAL(15,2) NOT NULL DEFAULT 0,
    total_deductions    DECIMAL(15,2) NOT NULL DEFAULT 0,
    net_salary          DECIMAL(15,2) NOT NULL DEFAULT 0,
    payroll_status_code VARCHAR(50) NOT NULL,
    processed_at        TIMESTAMP(6),
    created_at          TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at          TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                        ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT pk_payroll PRIMARY KEY (payroll_id),

    CONSTRAINT uk_payroll_employee_period
        UNIQUE (employee_id, payroll_month, payroll_year),

    CONSTRAINT fk_payroll_employee
        FOREIGN KEY (employee_id) REFERENCES employees(employee_id),

    CONSTRAINT fk_payroll_status
        FOREIGN KEY (payroll_status_code)
        REFERENCES payroll_statuses(status_code),

    CONSTRAINT chk_payroll_month
        CHECK (payroll_month BETWEEN 1 AND 12),

    CONSTRAINT chk_payroll_period
        CHECK (pay_period_end >= pay_period_start),

    CONSTRAINT chk_payroll_gross_salary
        CHECK (gross_salary >= 0),

    CONSTRAINT chk_payroll_total_deductions
        CHECK (total_deductions >= 0),

    CONSTRAINT chk_payroll_net_salary
        CHECK (net_salary >= 0)
);

CREATE TABLE payroll_items (
    payroll_item_id      BINARY(16) NOT NULL,
    payroll_id           BINARY(16) NOT NULL,
    salary_component_id  BINARY(16) NOT NULL,
    component_code       VARCHAR(50) NOT NULL,
    component_name       VARCHAR(150) NOT NULL,
    component_type       VARCHAR(30) NOT NULL,
    amount                DECIMAL(15,2) NOT NULL,
    created_at            TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at            TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                          ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT pk_payroll_items PRIMARY KEY (payroll_item_id),

    CONSTRAINT uk_payroll_component
        UNIQUE (payroll_id, salary_component_id),

    CONSTRAINT fk_payroll_items_payroll
        FOREIGN KEY (payroll_id) REFERENCES payroll(payroll_id),

    CONSTRAINT fk_payroll_items_component
        FOREIGN KEY (salary_component_id)
        REFERENCES salary_components(salary_component_id)
);

-- ============================================================
-- Helpful indexes
-- ============================================================

CREATE INDEX idx_branches_company
    ON branches(company_id);

CREATE INDEX idx_departments_company
    ON departments(company_id);

CREATE INDEX idx_designations_company
    ON designations(company_id);

CREATE INDEX idx_employment_types_company
    ON employment_types(company_id);

CREATE INDEX idx_work_shifts_company
    ON work_shifts(company_id);

CREATE INDEX idx_employees_company
    ON employees(company_id);

CREATE INDEX idx_employees_branch
    ON employees(branch_id);

CREATE INDEX idx_employees_manager
    ON employees(reporting_manager_id);

CREATE INDEX idx_users_company
    ON users(company_id);

CREATE INDEX idx_employee_contacts_employee
    ON employee_contacts(employee_id);

CREATE INDEX idx_employee_addresses_employee
    ON employee_addresses(employee_id);

CREATE INDEX idx_employee_assignments_employee
    ON employee_assignments(employee_id);

CREATE INDEX idx_employee_assignments_dates
    ON employee_assignments(employee_id, effective_from, effective_to);

CREATE INDEX idx_attendance_employee_date
    ON attendance(employee_id, attendance_date);

CREATE INDEX idx_leave_types_company
    ON leave_types(company_id);

CREATE INDEX idx_leave_policies_company
    ON leave_policies(company_id);

CREATE INDEX idx_leave_balances_employee
    ON leave_balances(employee_id);

CREATE INDEX idx_leave_requests_employee
    ON leave_requests(employee_id);

CREATE INDEX idx_leave_requests_status
    ON leave_requests(leave_status_code);

CREATE INDEX idx_salary_components_company
    ON salary_components(company_id);

CREATE INDEX idx_salary_structures_employee
    ON salary_structures(employee_id);

CREATE INDEX idx_payroll_employee_period
    ON payroll(employee_id, payroll_year, payroll_month);

CREATE INDEX idx_payroll_status
    ON payroll(payroll_status_code);

CREATE INDEX idx_payroll_items_payroll
    ON payroll_items(payroll_id);
