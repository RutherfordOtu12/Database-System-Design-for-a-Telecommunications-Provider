
-- To avoid conflicting tables, already existing tables which might be in the DB were dropped

DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Billing;
DROP TABLE IF EXISTS Subscription;
DROP TABLE IF EXISTS NetworkElements;
DROP TABLE IF EXISTS CustomerService;
DROP TABLE IF EXISTS Package;
DROP TABLE IF EXISTS UsageData;

-- -----------------------------------------------------
-- Creating various tables
-- -----------------------------------------------------

-- CUSTOMER TABLE
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(15) UNIQUE NOT NULL,
    Address VARCHAR(100) NOT NULL,
    DOB DATE NOT NULL,
    Gender VARCHAR(20) NOT NULL
);

-- PACKAGE TABLE

-- to be able to check standardization of counts and usage, call, sms and data limits were enumerated using the 'check' option
CREATE TABLE Package (
    PackageID INT PRIMARY KEY AUTO_INCREMENT,
    PackageType VARCHAR(50) NOT NULL,
    PackageName VARCHAR(50) NOT NULL,
    MonthlyFee DECIMAL(10,2) NOT NULL,
    DataLimit INT CHECK (DataLimit IN (512, 1024, 2048, 5120, 10240)) NOT NULL,      -- in MB: 1GB, 2GB, 5GB, 10GB
    VoiceLimit INT CHECK (VoiceLimit IN (100, 500, 1000, 2000)) NOT NULL,      -- in minutes
    SMSLimit INT CHECK (SMSLimit IN (50, 100, 500, 1000)) NOT NULL,            -- number of messages
    OtherFeatures VARCHAR(50)
);


-- SUBSCRIPTION TABLE
CREATE TABLE Subscription (
    SubscriptionID INT PRIMARY KEY AUTO_INCREMENT,
    PackageID INT,
    CustomerID INT,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    FOREIGN KEY (PackageID) REFERENCES Package(PackageID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- USED TABLE (UsageData)
-- to be able to check standardization of counts and usage, call, sms and data were enumerated using the 'check' option
CREATE TABLE UsageData (
    UsageDataID INT PRIMARY KEY AUTO_INCREMENT,
    PackageID INT,
    SubscriptionID INT,
    Date DATE NOT NULL,
    CallMinutes INT CHECK (CallMinutes IN (0, 100, 250, 500, 1000)) NOT NULL, -- Enumerated call minute ranges
    SMSCount INT CHECK (SMSCount IN (0, 50, 100, 250, 500, 1000)) NOT NULL,   -- Enumerated SMS usage
    DataUsed INT CHECK (DataUsed IN (0, 512, 1024, 2048, 5120, 10240)) NOT NULL, -- in MB: 0MB to 10GB
    FOREIGN KEY (PackageID) REFERENCES Package(PackageID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (SubscriptionID) REFERENCES Subscription(SubscriptionID)
        ON DELETE CASCADE ON UPDATE CASCADE
);


-- BILLING TABLE
CREATE TABLE Billing (
    BillID INT PRIMARY KEY AUTO_INCREMENT,
    SubscriptionID INT,
    Month VARCHAR(15) NOT NULL,
    AmountDue DECIMAL(10,2) NOT NULL,
    AmountPaid DECIMAL(10,2) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    DueDate DATE NOT NULL,
    FOREIGN KEY (SubscriptionID) REFERENCES Subscription(SubscriptionID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- NETWORK ELEMENTS TABLE
CREATE TABLE NetworkElements (
    ElementID INT PRIMARY KEY AUTO_INCREMENT,
    ElementType VARCHAR(50) NOT NULL,
    Region VARCHAR(50) NOT NULL,
    Town VARCHAR(50) NOT NULL,
    DeviceCode VARCHAR(50) NOT NULL,
    InstallationDate DATE NOT NULL,
    Status VARCHAR(50) NOT NULL,
    AssignedTo VARCHAR(100) NOT NULL,
    Comments VARCHAR(500)
);

-- CUSTOMER SERVICE TABLE
CREATE TABLE CustomerService (
    ServiceID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    IssueType VARCHAR(100) NOT NULL,
    CreatedDate DATE NOT NULL,
    ResolutionDate DATE NOT NULL,
    Status VARCHAR(50) NOT NULL,
    AssignedTo VARCHAR(100) NOT NULL,
    Comments VARCHAR(500),
    ElementID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ElementID) REFERENCES NetworkElements(ElementID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- ------------------------------------------------------------------------------------------------------------------------
-- Populating or inserting into the tables with sample data, to be ablke to run trial queries for various levels of querrying
-- ------------------------------------------------------------------------------------------------------------------------
-- 25 sample data was inserted into 'customers'

INSERT INTO Customer (Name, Email, PhoneNumber, Address, DOB, Gender) 
VALUES
('Mary Aye', 'Mary.aye@gmail.com', '08583584677', '1 Fertlizer St.', '1983-05-21', 'Male'),
('Jane Akosua', 'jane.smith@gmail.com', '08481282015', '2 cacumber St.', '1974-08-25', 'Female'),
('Kwame Otu', 'kwame@web.de', '08868652789', '3 Best St.', '1988-06-13', 'Male'),
('Maame Birago', 'M.birago@gmail.com', '08793441233', '4 dansoman St.', '1992-03-21', 'Female'),
('Emmanuel kyei Opoku', 'Emmakyei@yahoo.com', '08139049272', '5 Nimtree St.', '1974-04-04', 'Male'),
('Emily Adams', 'emily.adams@mail.com', '08654268516', '6 KNUST St.', '1980-05-20', 'Female'),
('Rutherford Otu', 'Rutherford.ro@gmail.com', '08500751005', '7 OXFORD St.', '1997-08-12', 'Male'),
('Fatima Yakubu', 'fatima.Moro@yahoo.com', '08756707017', '8 Boxhagener St.', '1992-02-29', 'Female'),
('Gabrelle Lee', 'david@web.com', '08967606820', '9 KarlMax St.', '1976-03-31', 'Feamale'),
('Bharat Gudimethla', 'priya.singh@bsbi.com', '08707161858', '10 faraday St.', '1989-05-16', 'Female'),
('Ahenkorah Carlos', 'carlosahen@bsbi.com', '08148323669', '11 gemuse St.', '1981-04-26', 'Male'),
('Amina Yusuf', 'amina.yusuf@mail.com', '08155393408', '12 Sonnenallee St.', '1984-04-22', 'Female'),
('Michael opare', 'michael.chen@gmail.com', '08651360193', '13 waschauer St.', '1989-09-07', 'Male'),
('Laura Jones', 'laura.jones@gmail.com', '08143977275', '14 Rutchow St.', '1975-04-08', 'Female'),
('Nina Patel', 'nina.patel@bsbi.com', '08958192188', '15 Meringdam St.', '1994-01-16', 'Male'),
('Samuel Okoro', 'samuel.okoro@gmail.com', '08924837444', '16 karkshorst St.', '1982-01-10', 'Female'),
('Isabella Rossi', 'isabella.rossi@web.com', '08250032618', '17 kaufland St.', '1991-12-16', 'Male'),
('Irma Martin', 'Martin98.brown@mail.com', '08247981714', '18 Rewe St.', '2000-08-17', 'Female'),
('Sara Ibrahim', 'sara.ibrahim@example.com', '08640721396', '19 Ostkreuz St.', '1985-06-01', 'Male'),
('Leo Martinez', 'leo.martinez@gmail.com', '08205810581', '20 Air St.', '1981-08-13', 'Female'),
('Victor Cruz', 'victor.cruz@gmail.com', '08685716243', '21 6th march St.', '1996-09-22', 'Male'),
('Manu Hannah', 'anna.ivanova@yahoo.com', '08245867387', '22 independence St.', '1980-06-16', 'Female'),
('Ampoonsah Opare', 'george@web.com', '08657297747', '23 Poor no friend St.', '1994-04-26', 'Male'),
('Yuki Tanaka', 'yuki@gmail.com', '08592061094', '24 Awoshie St.', '1985-12-12', 'Female'),
('Lina Mohammed', 'lina.mohammed@yahoo.com', '08639602142', '25 sunday St.', '1996-01-24', 'Male');


INSERT INTO Package (PackageType, PackageName, MonthlyFee, DataLimit, VoiceLimit, SMSLimit, OtherFeatures) 
VALUES
('Prepaid', 'Basic Pack', 30.75, 512, 100, 50, 'None'),
('Postpaid', 'Family Pack', 17.06, 1024, 500, 100, 'Free Roaming'),
('Prepaid', 'Premium Pack', 42.17, 2048, 1000, 500, '5G Access'),
('Postpaid', 'Unlimited Pack', 19.30, 5120, 2000, 1000, 'Night Data'),
('Prepaid', 'Student Pack', 36.33, 10240, 100, 50, 'Bundle Discount');


INSERT INTO Subscription (PackageID, CustomerID, StartDate, EndDate)
 VALUES
(2, 1, '2022-09-23', '2023-07-25'),
(5, 2, '2022-12-10', '2023-06-23'),
(4, 3, '2022-08-30', '2023-03-29'),
(5, 4, '2022-06-16', '2023-01-24'),
(1, 5, '2022-06-01', '2023-04-13'),
(2, 6, '2022-10-08', '2023-04-21'),
(5, 7, '2023-05-23', '2024-05-15'),
(4, 8, '2022-04-23', '2023-02-14'),
(4, 9, '2022-06-24', '2023-06-06'),
(5, 10, '2022-03-29', '2023-01-24'),
(4, 11, '2023-03-16', '2024-02-27'),
(3, 12, '2022-10-04', '2023-07-31'),
(2, 13, '2023-09-19', '2024-05-13'),
(5, 14, '2022-03-21', '2022-12-21'),
(5, 15, '2022-07-17', '2023-03-08'),
(1, 16, '2022-07-20', '2023-06-21'),
(2, 17, '2023-06-21', '2024-05-12'),
(2, 18, '2022-01-14', '2023-01-08'),
(2, 19, '2023-08-27', '2024-07-25'),
(1, 20, '2022-11-19', '2023-05-21'),
(3, 21, '2022-01-26', '2022-08-05'),
(4, 22, '2023-03-15', '2024-03-13'),
(4, 23, '2022-07-16', '2023-05-01'),
(3, 24, '2023-02-25', '2023-09-01'),
(1, 25, '2023-07-27', '2024-05-26');

update Subscription
set EndDate = '2025-07-25'
where CustomerID = '1';

update Subscription
set EndDate = '2025-07-25'
where CustomerID = '25';


-- -------------------------------------------------------------------------------------------------------------------------------
-- using the valid enumerated values, usageData table linked to subscription was populated with 25 samples
-- usageData were recorded as at 7th june, 2025
-- -------------------------------------------------------------------------------------------------------------------------------

INSERT INTO UsageData (PackageID, SubscriptionID, Date, CallMinutes, SMSCount, DataUsed) 
VALUES
(2, 1, '2025-06-07', 500, 1000, 512),
(5, 2, '2025-06-07', 500, 0, 2048),
(4, 3, '2025-06-07', 250, 500, 1024),
(5, 4, '2025-06-07', 1000, 50, 2048),
(1, 5, '2025-06-07', 250, 0, 10240),
(2, 6, '2025-06-07', 1000, 500, 512),
(5, 7, '2025-06-07', 100, 100, 10240),
(4, 8, '2025-06-07', 100, 1000, 0),
(4, 9, '2025-06-07', 500, 0, 512),
(5, 10, '2025-06-07', 1000, 50, 5120),
(4, 11, '2025-06-07', 100, 1000, 1024),
(3, 12, '2025-06-07', 250, 100, 10240),
(2, 13, '2025-06-07', 0, 0, 0),
(5, 14, '2025-06-07', 100, 250, 512),
(5, 15, '2025-06-07', 1000, 50, 0),
(1, 16, '2025-06-07', 250, 50, 1024),
(2, 17, '2025-06-07', 250, 500, 1024),
(2, 18, '2025-06-07', 0, 500, 5120),
(2, 19, '2025-06-07', 0, 50, 512),
(1, 20, '2025-06-07', 1000, 0, 2048),
(3, 21, '2025-06-07', 250, 250, 0),
(4, 22, '2025-06-07', 100, 50, 512),
(4, 23, '2025-06-07', 1000, 250, 1024),
(3, 24, '2025-06-07', 250, 0, 2048),
(1, 25, '2025-06-07', 1000, 1000, 512);



-- -------------------------------------------------------------------------------------------------------------------------------
-- a corresponding bill was inserted into billing table based on customer's subscriptions
-- -------------------------------------------------------------------------------------------------------------------------------

INSERT INTO Billing (SubscriptionID, Month, AmountDue, AmountPaid, Status, DueDate) 
VALUES
(1, '2025-05', 65.83, 65.83, 'Paid', '2025-06-28'),
(2, '2025-06', 43.02, 43.02, 'Paid', '2025-06-28'),
(3, '2025-06', 41.73, 41.73, 'Paid', '2025-06-28'),
(4, '2025-06', 18.19, 18.19, 'Paid', '2025-06-28'),
(5, '2025-05', 74.60, 74.60, 'Paid', '2025-06-28'),
(6, '2025-05', 45.36, 45.36, 'Paid', '2025-06-28'),
(7, '2025-05', 12.82, 10.87, 'Pending', '2025-06-28'),
(8, '2025-06', 12.72, 12.72, 'Paid', '2025-06-28'),
(9, '2025-06', 66.43, 36.83, 'Pending', '2025-06-28'),
(10, '2025-06', 35.09, 27.74, 'Pending', '2025-06-28'),
(11, '2025-06', 46.09, 24.22, 'Pending', '2025-06-28'),
(12, '2025-05', 61.62, 61.62, 'Paid', '2025-06-28'),
(13, '2025-05', 55.16, 55.16, 'Paid', '2025-06-28'),
(14, '2025-05', 11.12, 11.12, 'Paid', '2025-06-28'),
(15, '2025-05', 37.29, 37.29, 'Paid', '2025-06-28'),
(16, '2025-06', 78.87, 78.87, 'Paid', '2025-06-28'),
(17, '2025-06', 29.67, 0.00, 'Overdue', '2025-06-28'),
(18, '2025-06', 60.54, 60.54, 'Paid', '2025-06-28'),
(19, '2025-06', 23.00, 23.00, 'Paid', '2025-06-28'),
(20, '2025-06', 45.53, 45.53, 'Paid', '2025-06-28'),
(21, '2025-06', 60.77, 60.77, 'Paid', '2025-06-28'),
(22, '2025-05', 36.23, 36.23, 'Paid', '2025-06-28'),
(23, '2025-05', 53.75, 38.49, 'Pending', '2025-06-28'),
(24, '2025-05', 62.22, 62.22, 'Paid', '2025-06-28'),
(25, '2025-05', 77.75, 77.75, 'Paid', '2025-06-28');



-- -------------------------------------------------------------------------------------------------------------------------------
-- NetworkElements Table
-- -------------------------------------------------------------------------------------------------------------------------------
INSERT INTO NetworkElements (ElementType, Region, Town, DeviceCode, InstallationDate, Status, AssignedTo, Comments) 
VALUES
('Tower', 'Northern', 'Bolgatanga', 'DEV1000', '2020-05-10', 'Active', 'Kofi Otu', 'Tower in Bolagatanga (Active)'),
('Router', 'Eastern', 'Kwahu Abetifi', 'DEV1001', '2021-03-15', 'Maintenance', 'Maintenanace Team ', 'Router in Kwahu Abetifi (Maintenance)'),
('Switch', 'Savanna', 'Nyankpala', 'DEV1002', '2022-07-25', 'Offline', 'Agent Paul', 'Switch in Nyankpala (Offline)'),
('Gateway', 'Western', 'Sehwi', 'DEV1003', '2023-01-11', 'Active', 'Agent Boakye', 'Gateway in Sehwi (Active)'),
('Tower', 'Central', 'Winneba', 'DEV1004', '2020-11-05', 'Active', 'Support Team', 'Tower in Winneba (Active)'),
('Router', 'Northern', 'Tamale', 'DEV1005', '2021-12-30', 'Maintenance', 'Kwame Owusu', 'Router in Tamale (Maintenance)'),
('Switch', 'Eastern', 'Koforidua', 'DEV1006', '2019-08-19', 'Offline', 'Maintenance Team', 'Switch in Koforidua (Offline)'),
('Gateway', 'Savanna', 'Bupui', 'DEV1007', '2023-04-10', 'Active', 'Agent Boakye', 'Gateway in Bupui (Active)'),
('Tower', 'Western', 'Takoradi', 'DEV1008', '2022-09-16', 'Maintenance', 'Support Team', 'Tower in Takoradi (Maintenance)'),
('Router', 'Ashanti', 'Kumasi', 'DEV1009', '2021-06-02', 'Offline', 'Agent Paul', 'Router in Kumasi (Offline)'),
('Router',	'Greater Accra',	'Osu',	'DEV1010',	'2021-06-03',	'Active',	'Maintenance Team',	'Rounter in Osu (Active)');


-- Customer Service Table

INSERT INTO CustomerService (CustomerID, IssueType, CreatedDate, ResolutionDate, Status, AssignedTo, Comments, ElementID)
VALUES
(1, 'No Signal', '2025-01-10', '2025-01-13', 'Resolved', 'Agent Paul', 'Issue: No Signal', 1),
(2, 'Billing Issue', '2024-11-21', '2024-11-24', 'Resolved', 'Agent Boakye', 'Issue: Billing Issue', 2),
(3, 'Slow Internet', '2025-03-03', '2025-03-07', 'Resolved', 'Maintenance Team', 'Issue: Slow Internet', 3),
(4, 'Call Drops', '2024-10-12', '2024-10-14', 'Resolved', 'Kofi Otu', 'Issue: Call Drops', 4),
(5, 'Activation Delay', '2024-12-01', '2024-12-04', 'Resolved', 'Support Team', 'Issue: Activation Delay', 5),
(6, 'No Signal', '2025-02-15', '2025-02-18', 'Resolved', 'Agent Paul', 'Issue: No Signal', 6),
(7, 'Billing Issue', '2024-09-05', '2024-09-07', 'Resolved', 'Agent Boakye', 'Issue: Billing Issue', 7),
(8, 'Slow Internet', '2025-04-20', '2025-04-22', 'Resolved', 'MaintenanceTeam', 'Issue: Slow Internet', 8),
(9, 'Call Drops', '2025-01-29', '2025-02-01', 'Resolved', 'Kwame Owusu', 'Issue: Call Drops', 9),
(10, 'Activation Delay', '2024-08-10', '2024-08-13', 'Resolved', 'Support Team', 'Issue: Activation Delay', 10),
(11, 'No Signal', '2025-01-05', '2025-01-10', 'Resolved', 'Agent Paul', 'Issue: No Signal', 1),
(12, 'Billing Issue', '2025-03-17', '2025-03-20', 'Resolved', 'Agent Boakye', 'Issue: Billing Issue', 2),
(13, 'Slow Internet', '2024-12-25', '2024-12-29', 'Resolved', 'Maintenance Team', 'Issue: Slow Internet', 3),
(14, 'Call Drops', '2024-11-15', '2024-11-17', 'Resolved', 'Kofi Otu', 'Issue: Call Drops', 4),
(15, 'Activation Delay', '2025-02-10', '2025-02-13', 'Resolved', 'Support Team', 'Issue: Activation Delay', 5),
(16, 'No Signal', '2025-04-01', '2025-04-05', 'Resolved', 'Agent Paul', 'Issue: No Signal', 6),
(17, 'Billing Issue', '2025-01-20', '2025-01-22', 'Resolved', 'Agent Boakye', 'Issue: Billing Issue', 7),
(18, 'Slow Internet', '2024-10-07', '2024-10-11', 'Resolved', 'Maintenance Team', 'Issue: Slow Internet', 8),
(19, 'Call Drops', '2025-03-25', '2025-03-28', 'Resolved', 'Engineer Yankeson', 'Issue: Call Drops', 11),
(20, 'Activation Delay', '2024-09-18', '2024-09-20', 'Resolved', 'Support Team', 'Issue: Activation Delay', 10),
(21, 'No Signal', '2025-01-15', '2025-01-18', 'Resolved', 'Agent Paul', 'Issue: No Signal', 1),
(22, 'Billing Issue', '2025-03-01', '2025-03-04', 'Resolved', 'Agent Benson', 'Issue: Billing Issue', 11),
(23, 'Slow Internet', '2025-04-10', '2025-04-12', 'Resolved', 'Maintenance Team', 'Issue: Slow Internet', 3),
(24, 'Call Drops', '2024-12-05', '2024-12-09', 'Resolved', 'Kofi Otu', 'Issue: Call Drops', 4),
(25, 'Activation Delay', '2024-11-25', '2024-11-27', 'Resolved', 'Support Team', 'Issue: Activation Delay', 5);





-- -------------------------------------------------------------------------------------------------------------------------------
-- The following thematic queries will range from customer information retrieval,  package management, usage History Analysis, Billing deatails, Network performance indicators to Adavanced telecommunication operations. 
-- -------------------------------------------------------------------------------------------------------------------------------


-- 1. Customer Information retrieval
-- ----------------------------------------------------------------------------


-- A. What are the active customers with their current subscriptions?

SELECT c.CustomerID, c.Name, c.Email, c.PhoneNumber, p.PackageName, s.StartDate
FROM Customer c
JOIN Subscription s ON c.CustomerID = s.CustomerID
JOIN Package p ON s.PackageID = p.PackageID
WHERE s.EndDate > CURRENT_DATE
order by CustomerID;




-- B. Custoimers with no usage over the past month

SELECT DISTINCT c.CustomerID, c.Name
FROM Customer c
JOIN Subscription s ON c.CustomerID = s.CustomerID
LEFT JOIN UsageData u ON s.SubscriptionID = u.SubscriptionID 
                        AND u.Date >= CURRENT_DATE - INTERVAL 30 DAY
WHERE u.UsageDataID IS NULL;


-- Customers who are yet to celeberate their birthdays(query parsed as at 9th june)
SELECT CustomerID, Name, DOB
FROM Customer
WHERE MONTH(DOB) = MONTH(CURRENT_DATE)
  AND DAY(DOB) > DAY(CURRENT_DATE)
ORDER BY DAY(DOB);


-- 2.  Package Management
-- ----------------------------------------------------------------------------
-- A. Identify how many customers who have subscribed to a package Type (PostPaid and Prepaid)

SELECT p.PackageType, COUNT(DISTINCT s.CustomerID) AS ToatalCustomers
FROM Package p
JOIN Subscription s ON p.PackageID = s.PackageID
GROUP BY p.PackageType;


-- B. Count of customers with expired Subscriptions. This will enable the Comapany AIR, 
-- 		rolled out favorable and befitting advertisements and personalized offers

SELECT c.CustomerID, c.Name, s.EndDate
FROM Customer c
JOIN Subscription s ON c.CustomerID = s.CustomerID
WHERE s.EndDate < CURRENT_DATE
order by CustomerID;



-- 3. Usage History 
-- 		(This is to ascertain the the total call, sms and data used by customers oveer the past month)
-- 		such analysis enables the company to realise user usage pattern, network problems and 
-- 		plan maintainance or personalised bonuses and offers.

-- A. Total calls, sms and data usage per customer for current month

SELECT c.CustomerID, c.Name,
       SUM(u.CallMinutes) AS TotalCallMinutes,
       SUM(u.SMSCount) AS TotalSMS,
       SUM(u.DataUsed) AS TotalDataMB
FROM Customer c
JOIN Subscription s ON c.CustomerID = s.CustomerID
JOIN UsageData u ON s.SubscriptionID = u.SubscriptionID
WHERE MONTH(u.Date) = MONTH(CURRENT_DATE) AND YEAR(u.Date) = YEAR(CURRENT_DATE)
GROUP BY c.CustomerID, c.Name;


-- B. Identifying top 10 Data users in the last month. 

SELECT c.CustomerID, c.Name, SUM(u.DataUsed) AS TotalDataMB
FROM Customer c
JOIN Subscription s ON c.CustomerID = s.CustomerID
JOIN UsageData u ON s.SubscriptionID = u.SubscriptionID
WHERE u.Date >= CURRENT_DATE - INTERVAL 30 DAY
GROUP BY c.CustomerID, c.Name
ORDER BY TotalDataMB DESC 	-- this produce result with highest users at the top
LIMIT 10;


-- 4. Billings History

-- A. calculate monthly bill summary for each customers (AIR, would love to issue monthly
-- 		receipts to customers as well as gift monthly data bonuses for highest paying customer. billings were calcualted over MAY and June, 2025.

SELECT c.CustomerID, c.Name, b.Month, 
       SUM(b.AmountDue) AS Due, 
       SUM(b.AmountPaid) AS Paid
FROM Customer c
JOIN Subscription s ON c.CustomerID = s.CustomerID
JOIN Billing b ON s.SubscriptionID = b.SubscriptionID
GROUP BY c.CustomerID, c.Name, b.Month
ORDER BY b.Month DESC;


-- B. Overdue Bills (to be able to retrieve overdue bills, targeted customers need to be identified

SELECT c.CustomerID, c.Name, b.AmountDue, b.DueDate
FROM Customer c
JOIN Subscription s ON c.CustomerID = s.CustomerID
JOIN Billing b ON s.SubscriptionID = b.SubscriptionID
WHERE b.Status not in  ('Paid')
Order by b.AmountDue desc;

-- 5. Assessing Network Elements and perfomance
 
 -- A. To be able to deploy maintenanance and repair services at various regions or locations, we need to 
-- 	List of inactive or faulty network elements 
 
 SELECT ElementID, Region, Town, DeviceCode, Status
FROM NetworkElements
WHERE Status NOT IN ('Active', 'Operational');


 -- B. How many unresolved issues left pending? Show results per region.
 
 SELECT ne.Region, COUNT(cs.ServiceID) AS Unresolved
FROM CustomerService cs
JOIN NetworkElements ne ON cs.ElementID = ne.ElementID
WHERE cs.Status = 'Resolved'
GROUP BY ne.Region;

 
 -- Calcualting over-usage fees if usage exceeds Limits. This will enable possible suggestions to users to upgrade to higher packs, 
-- 	ensures fair usage enforcement, recouping revenue and planning operations accordingly to meet customer capcity.alter

 SELECT c.CustomerID, c.Name, p.PackageName,
       SUM(u.CallMinutes - p.VoiceLimit) AS ExtraMinutes,
       SUM(u.SMSCount - p.SMSLimit) AS ExtraSMS,
       SUM(u.DataUsed - p.DataLimit) AS ExtraDataMB
FROM Customer c
JOIN Subscription s ON c.CustomerID = s.CustomerID
JOIN Package p ON s.PackageID = p.PackageID
JOIN UsageData u ON s.SubscriptionID = u.SubscriptionID
GROUP BY c.CustomerID, c.Name, p.PackageName, p.VoiceLimit, p.SMSLimit, p.DataLimit
HAVING SUM(u.CallMinutes) > p.VoiceLimit 
    OR SUM(u.SMSCount) > p.SMSLimit 
    OR SUM(u.DataUsed) > p.DataLimit;
    
    
  -- -----------------------------------------------------------------------------------------------------------  
   -- EXPERIMENTING STORED PROCEDURES
   -- This procedure was parsed to GENERATE MONTHLY BILL REPORT. Flags unpaid bills, loops through all customers and allows Rollback 
    -- -----------------------------------------------------------------------------------------------------------  
 -- step 1: creating addtional log table to keep logs of flaaged Customers
 
 
 CREATE TABLE IF NOT EXISTS FlaggedCustomers (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    Name VARCHAR(100),
    MonthFlagged VARCHAR(15),
    Reason VARCHAR(255),
    FlaggedDate DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- Step 2: Creating Stored Procedure with Loop, Flagging, and Savepoint to get monthly summary of customers

DELIMITER $$
CREATE PROCEDURE FlagUnpaidCustomers()
BEGIN
    -- Variable declarations
    DECLARE done INT DEFAULT 0;
    DECLARE varCustomerID INT;
    DECLARE varName VARCHAR(100);

    -- Cursor declaration
    DECLARE customer_cursor CURSOR FOR
        SELECT CustomerID, Name FROM Customer;

    -- Continue handler for end of cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Start transaction
    START TRANSACTION;

    -- Open cursor
    OPEN customer_cursor;

    customer_loop: LOOP
        FETCH customer_cursor INTO varCustomerID, varName;
        IF done THEN 
            LEAVE customer_loop;
        END IF;

        -- Savepoint before processing a customer
        SAVEPOINT sp_customer;

        -- Check and flag unpaid/pending bills
        IF EXISTS (
            SELECT 1
            FROM Subscription s
            JOIN Billing b ON s.SubscriptionID = b.SubscriptionID
            WHERE s.CustomerID = varCustomerID
              AND b.Status IN ('OverDue', 'Pending')
        ) THEN
            INSERT INTO FlaggedCustomers (CustomerID, Name, MonthFlagged, Reason)
            SELECT DISTINCT varCustomerID, varName, b.Month, CONCAT('Bill ', b.Status)
            FROM Subscription s
            JOIN Billing b ON s.SubscriptionID = b.SubscriptionID
            WHERE s.CustomerID = varCustomerID
              AND b.Status IN ('OverDue', 'Pending');
        END IF;

    END LOOP;

    -- Close cursor
    CLOSE customer_cursor;

    COMMIT;
END$$

DELIMITER ;

call FlagUnpaidCustomers();
 