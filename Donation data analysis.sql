--Shows the total donation and average donation amounts for each state
SELECT state,
	   SUM(donation) as total_donation,
       ROUND(avg(donation),1) as average_donation
FROM Donation_Data
GROUP BY state
order by total_donation desc;

--Shows the total donation and average donation amounts for each job field
SELECT job_field,
	   SUM(donation) as total_donation,
       ROUND(avg(donation),1) as average_donation
FROM Donation_Data
GROUP BY job_field
order by SUM(donation) desc;

--Joins donation and donor data and shows the total donation and average donations per donation_frequencies
SELECT Donor_Data2.donation_frequency AS donation_frequency,
	   SUM(Donation_Data.donation) as total_donation,
       ROUND(AVG(Donation_Data.donation),1) as avg_donation
       
From Donation_Data
join Donor_Data2
on Donation_Data.id = Donor_Data2.id

group by donation_frequency
ORDER BY total_donation DESC

--Shows the name of the top donors from each job field in descending order

WITH donor_ranking AS (
  SELECT Donation_Data.first_name,
  	   Donation_Data.last_name,
  	   Donation_Data.gender,
	   Donation_Data.job_field,
       Donation_Data.donation as donation_amount,
       Donation_Data.state,
       Donor_Data2.donation_frequency,
       Donor_Data2.movie_genre,
       RANK() OVER (PARTITION BY job_field ORDER BY donation DESC) as ranking
From Donation_Data
join Donor_Data2
on Donation_Data.id = Donor_Data2.id
)

SELECt first_name,
	   last_name,
       donation_amount,
       job_field
FROM donor_ranking
WHERE ranking = 1

--Shows the name of top donors from each state in descending order

WITH donor_ranking AS (
  SELECT Donation_Data.first_name,
  	   Donation_Data.last_name,
  	   Donation_Data.gender,
	   Donation_Data.job_field,
       Donation_Data.donation as donation_amount,
       Donation_Data.state,
       Donor_Data2.donation_frequency,
       Donor_Data2.movie_genre,
       RANK() OVER (PARTITION BY state ORDER BY donation DESC) as ranking
From Donation_Data
join Donor_Data2
on Donation_Data.id = Donor_Data2.id
)

SELECt first_name,
	   last_name,
       donation_amount,
       state
FROM donor_ranking
WHERE ranking = 1
ORDER BY donation_amount 

--Creates education categories based on the education data
--groups donors based on education levels after joining the donation and donor datasets
--and shows the donation amount for each education group

WITH donor_ranking AS (
  SELECT Donation_Data.first_name || ' ' || Donation_Data.last_name AS full_name,
  	     Donation_Data.gender,
	     Donation_Data.job_field,
         Donation_Data.donation as donation_amount,
         Donation_Data.state,
         Donor_Data2.donation_frequency,
         (CASE
          WHEN university IS NULL THEN 'No College Education'
          ELSE 'College Educated'
          END) AS education
From Donation_Data
join Donor_Data2
on Donation_Data.id = Donor_Data2.id
)

SELECT ROUND(AVG(donation_amount),1) AS donation_average,
       COUNT(education) AS number_of_donors,
	   education
FROM donor_ranking
GROUP BY education