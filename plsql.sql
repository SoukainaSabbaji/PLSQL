--swap salaries of employees 120 and 122
DECLARE 
v_salary_120 employees.salary%TYPE;
BEGIN 
SELECT salary into v_salary_120 FROM employees 
WHERE employee_id = 120;
UPDATE employees 
SET salary = (SELECT salary from employees WHERE employee_id = 122) where employee_id = 120;
UPDATE employees 
SET salary = v_salary_120 WHERE employee_id = 122 ;
END;
/

--give employee number 115 a raise based on their experience 
DECLARE 
v_experience NUMBER(6);
v_raise NUMBER(6);
BEGIN 
SELECT trunc((sysdate-hire_date)/365) into v_experience from employees
where employee_id = 115 ;
CASE 
when v_experience > 10 THEN v_raise := 1,2;
WHEN v_experience > 5 THEN v_raise := 1,1;
ELSE v_raise := 1,05;
END CASE 
UPDATE employees SET salary = salary * v_raise from employees
WHERE employee_id = 115;
END ;
/
--update commission based on experience and salary of employee number 150
DECLARE 
v_sal employees.salary%TYPE;
v_experience NUMBER(6);
v_comm NUMBER(5,2);
BEGIN 
SELECT salary ,trunc((sysdate-hire_date)/365) INTO v_sal,v_experience 
FROM employees WHERE employee_id = 150;
IF v_sal > 10000 THEN v_comm := 0,4;
ELSIF
v_experience > 10 then v_comm := 0,35;
ELSIF 
v_sal < 3000 THEN v_comm := 0,25;
ELSE 
v_comm := 0,15;
END IF;
UPDATE employees SET commission_pct = commission_pct * v_comm WHERE employee_id = 150;
END;
/

--find the name and department of the manager of employee 103 
DECLARE 
v_manager employees.manager_id%TYPE;
v_lname employees.last_name%TYPE;
v_dept departments.department_name%TYPE;
BEGIN 
SELECT manager_id into v_manager FROM employees
WHERE employee_id = 103 ;
select last_name ,department_name INTO v_lname ,v_dept 
FROM employees JOIN departments ON (department_id)
WHERE employee_id = v_manager;
dbms_output.put_line('The manager of employee 103 is :'|| v_lname 'And his department is :' v_dept);
END;
/
set serveroutput on;


--display missing employee ids 
DECLARE
v_min NUMBER(4);
v_max NUMBER(4);
v_count NUMBER(1);
BEGIN
SELECT max(employee_id),min(employee_id) INTO v_max , v_min
FROM employees;
FOR i in v_min .. v_max 
LOOP 
SELECT COUNT(*) INTO v_count FROM employees
WHERE employee_id = i ;
IF v_count = 0
THEN dbms_output.put_line(i);
END IF ;
END LOOP;
END;
/



