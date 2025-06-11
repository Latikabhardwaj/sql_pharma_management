create database project;
use project;



create table Medicines (medicine_id varchar(20) primary key, medicine_name varchar(20), category varchar(20),
price_per_unit float, stock_quantity int, expiry_date date);

create table Doctors (doctor_id varchar(20)  ,doctor_name varchar(20),specialization varchar(20), hospital_name varchar(30));

create table Patients (patient_id varchar(20) primary key , patient_name varchar(20),gender varchar(20), dob date, city varchar (20));

create table Prescriptions (prescription_id varchar(20) primary key , doctor_id varchar(20) , patient_id varchar(20) ,prescription_date date,diagnosis varchar(20));

create table Prescription_Details (prescription_detail_id varchar(20) primary key ,prescription_id varchar(20), medicine_id varchar(20) ,dosage varchar(20), duration int);

create table Sales (sale_id varchar(20) primary key , patient_id varchar(20) , medicine_id varchar(20) ,quantity int, sale_date date, payment_method varchar(20));




insert into Medicines values ("M001","Paracetamol","Analgesic",1.50,200,"2026-03-15");
insert into Medicines values ("M002","Amoxicillin","Antibiotic",3.20,150,"2025-12-01");
insert into Medicines values ("M003","Cetirizine","Antihistamine",2.00,80,"2024-11-30");
insert into Medicines values ("M004","Metformin","Antidiabetic",5.00,50,"2027-05-20");
insert into Medicines values ("M005","Ibuprofen","Analgesic",1.75,0,"2024-08-01");




insert into Doctors values ("D101","Dr. Anjali Verma","General","City Care Hospital");
insert into Doctors values ("D102","Dr. Rakesh Nair","Pediatrics","Rainbow Clinic");
insert into Doctors values ("D103","Dr. Kavita Shah","ENT","Health First Hospital");



insert into Patients values ("P001","Rohit Mehra","Male","1985-06-15","Delhi");
insert into Patients values ("P002","Neha Sharma","Female","1992-09-21","Mumbai");
insert into Patients values ("P003","Suresh Iyer","Male","1978-12-03","Bengaluru");


insert into Prescriptions values ("PR001","D101","P001","2024-10-12","Fever");
insert into Prescriptions values ("PR002","D102","P002","2024-11-05","Cold");
insert into Prescriptions values ("PR003","D101","P003","2025-01-18","Diabetes");


insert into Prescription_Details values ("PD001","PR001","M001","2 tablets/day",5);
insert into Prescription_Details values ("PD002","PR002","M002","1 tablets/day",3);
insert into Prescription_Details values ("PD003","PR003","M003","1 tablets/day",30);



insert into Sales values ("S001","P001","M001",10,"2024-10-12","Cash");
insert into Sales values ("S002","P002","M003",5,"2024-11-05","Card");
insert into Sales values ("S003","P003","M004",30,"2025-01-18","UPI");
insert into sales values ("S004","P004","M005", 12,"2025-06-05","Cash");
insert into sales values ("S005","P005","M002", 7,"2025-06-08","Card");




#******************************************************************************************************************************************************************
#                                                                         Task 1 :-
#******************************************************************************************************************************************************************

# 1. List all medicines that are currently in stock.
select medicine_name from medicines where stock_quantity>0;

# 2. List medicines that are below minimum stock level (e.g., stock_quantity < 10).
select medicine_name from medicines where stock_quantity<80;

# 3. Find all patients living in a specific city (e.g., Mumbai).
select patient_name from patients where city="mumbai";

# 4. Identify medicines that have expired as of today.
select medicine_name from medicines where expiry_date < current_date();

# 5. Show all doctors specializing in "Pediatrics".
select doctor_name from doctors where specialization="Pediatrics";

# 6. List all prescriptions for a specific patient. (e.g , P001)
select * from prescriptions where patient_id="P001";


# 7. Show details of a medicine named "Paracetamol".
select * from medicines where medicine_name="Paracetamol";

# 8. List all patients in alphabetical order.
select patient_name from patients order by patient_name;

# 9. Find all medicines that belong to the "Analgesic" category.
select medicine_name from medicines where category="Analgesic";


# 10. List medicines with stock quantity less than 20.
select medicine_name from medicines where stock_quantity<20;

#*********************************************************************************************************************************************************************
#                                                                          Level 2 :-
#*********************************************************************************************************************************************************************

# 1. What is the total quantity sold for each medicine?
select medicine_name, sum(quantity) from  medicines inner join sales on medicines.medicine_id=sales.medicine_id
group by medicine_name;

# 2. Which medicine generated the highest revenue?
select medicine_name from medicines inner join sales on medicines.medicine_id=sales.medicine_id where
price_per_unit*quantity limit 1;

# 3. How many prescriptions has each doctor written?
select doctors.doctor_id,doctor_name, count(prescription_id) as total_prescription from doctors inner join prescriptions on prescriptions.doctor_id=doctors.doctor_id
group by doctors.doctor_id,doctor_name;

# 4 Show the number of patients treated by each doctor.
select doctor_name,count(patient_id) as Total_patients_treated from doctors inner join prescriptions on prescriptions.doctor_id=doctors.doctor_id
group by doctor_name;

# 5. Find medicines that will expire within the next 6 months.
select medicine_name from medicines where expiry_date<= current_date()+ interval 6 month;

# 6. Identify medicines that are already expired.
select medicine_name from medicines where expiry_date<= current_date();

# 7. Show revenue by payment method (Cash, Card, UPI).
select payment_method, sum(quantity*price_per_unit) as revenue from sales inner join medicines on medicines.medicine_id=sales.medicine_id  
group by payment_method;

# 8. Find the top 3 most sold medicines.
select medicine_name from medicines inner join sales on sales.medicine_id=medicines.medicine_id order by quantity desc
limit 3;

# 9. List all prescriptions along with the prescribing doctor and patient.
select prescription_id, prescription_date, diagnosis, doctor_name, patient_name from prescriptions inner join
doctors on doctors.doctor_id=prescriptions.doctor_id inner join patients on patients.patient_id=prescriptions.patient_id;

# 10. Retrieve the top 3 most sold medicines by total quantity.
select medicines.medicine_name, sum(sales.quantity) as total_sold from sales inner join medicines on sales.medicine_id = medicines.medicine_id
group by medicines.medicine_name order by total_sold desc limit 3;

#*******************************************************************************************************************************************************************
#                                                                        Level 3 :-
# ******************************************************************************************************************************************************************

# 1.  Show medicines that have never been sold.
select medicine_name from medicines where medicine_id not in (select distinct medicine_id from sales);

# 2. Find doctors who have never prescribed any medicine.
select doctor_id,doctor_name from doctors where doctor_id not in (select doctor_id from prescriptions);

# 3. List the most frequently used medicine in prescriptions.
select medicines.medicine_id,medicine_name,count(prescription_details.medicine_id) as total_prescriptions from medicines inner join prescription_details on 
prescription_details.medicine_id=medicines.medicine_id group by medicine_id,medicine_name order by medicine_id limit 1;

# 4. Generate a report of total sales, grouped by month and medicine.
select date_format(sale_date,'%Y-%m') as sale_month,medicine_name,sum(quantity*price_per_unit) as total_sales from sales
inner join medicines on medicines.medicine_id=sales.medicine_id group by medicine_name,date_format(sale_date,'%Y-%m') order by total_sales desc;

# 5. Calculate total revenue generated per medicine.
select medicine_name,sum(quantity*price_per_unit) as total_revenue from medicines inner join sales on medicines.medicine_id=sales.medicine_id group by medicine_name;

# 6. Find the number of distinct patients each doctor has treated.

select doctors.doctor_name, count(prescriptions.doctor_id) as Total_patients_treated from doctors inner join prescriptions 
on doctors.doctor_id=prescriptions.doctor_id  group by doctors.doctor_name,prescriptions.doctor_id;

    
# 7. Show daily sales totals for the last 30 days.
select sale_date, sum(quantity) as total_quantity_sold from sales where sale_date>= current_date()- interval 30 day group by sale_date; 


# 8. Identify medicines that have never been sold but were prescribed.

select medicines.medicine_id, medicine_name from medicines join prescription_details on medicines.medicine_id=prescription_details.medicine_id where 
medicines.medicine_id not in (select medicine_id from sales);
        
        
# 9. Retrieve the number of prescriptions issued by each doctor in the last 6 months.
 select doctors.doctor_id,doctors.doctor_name,count(prescriptions.prescription_id)as prescriptions_issued from doctors inner join
 prescriptions on prescriptions.doctor_id=doctors.doctor_id where prescriptions.prescription_date>=current_date()-interval 6 month 
 group by doctors.doctor_id,doctors.doctor_name;


















