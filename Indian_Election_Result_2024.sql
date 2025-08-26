SELECT * FROM statewise_results

--total seats

select 
distinct count(Constituency_ID) as total_seats
from constituencywise_results

--what are the total number of seats avaibale for electionin each states

SELECT 
    s.State AS State_Name,
    COUNT(cr.Constituency_ID) AS Total_Seats_Available
FROM [India Election Results].[dbo].[constituencywise_results] cr
JOIN [India Election Results].[dbo].[statewise_results] sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN [India Election Results].[dbo].[states] s ON sr.State_ID = s.State_ID
GROUP BY s.State
ORDER BY s.State;


--Total seats won by NDA alliance 
SELECT 
    SUM(CASE 
            WHEN party IN (
                'Bharatiya Janata Party - BJP', 
                'Telugu Desam - TDP', 
				'Janata Dal  (United) - JD(U)',
                'Shiv Sena - SHS', 
                'AJSU Party - AJSUP', 
                'Apna Dal (Soneylal) - ADAL', 
                'Asom Gana Parishad - AGP',
                'Hindustani Awam Morcha (Secular) - HAMS'
				,'Janasena Party - JnP', 
				'Janata Dal  (Secular) - JD(S)',
                'Lok Janshakti Party(Ram Vilas) - LJPRV', 
                'Nationalist Congress Party - NCP',
                'Rashtriya Lok Dal - RLD', 
                'Sikkim Krantikari Morcha - SKM'
            ) THEN [Won]
            ELSE 0 
        END) AS NDA_Total_Seats_Won
FROM 
    [India Election Results].dbo.partywise_results


--Seats Won by NDA Alliance Parties
SELECT 
    Party,
    [Won]
FROM [India Election Results].dbo.partywise_results
WHERE Party IN (
    'Bharatiya Janata Party - BJP', 
    'Telugu Desam - TDP', 
    'Janata Dal  (United) - JD(U)',
    'Shiv Sena - SHS', 
    'AJSU Party - AJSUP', 
    'Apna Dal (Soneylal) - ADAL', 
    'Asom Gana Parishad - AGP',
    'Hindustani Awam Morcha (Secular) - HAMS',
    'Janasena Party - JnP', 
    'Janata Dal  (Secular) - JD(S)',
    'Lok Janshakti Party(Ram Vilas) - LJPRV', 
    'Nationalist Congress Party - NCP',
    'Rashtriya Lok Dal - RLD', 
    'Sikkim Krantikari Morcha - SKM'
) order by Won desc

--Total seats won by India Alliance

select 
sum(case when Party in ('Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK'

		)
		then [won]
		else 0 
		end) as Seats_won_INDIA_aliance

FROM [India Election Results].dbo.partywise_results



--Seats Won by I.N.D.I.A Alliance Parties
select Party, Won
from [India Election Results].dbo.partywise_results
where Party in ('Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK')
order by Won desc

--Add new column field in table partywise_results to get the Party Alliance  as NDA, I.N.D.I.A and OTHER

alter table [India Election Results].dbo.partywise_results
add Alliance  varchar(50)

update [India Election Results].dbo.partywise_results
set Alliance='NDA' where Party in ('Bharatiya Janata Party - BJP', 
    'Telugu Desam - TDP', 
    'Janata Dal  (United) - JD(U)',
    'Shiv Sena - SHS', 
    'AJSU Party - AJSUP', 
    'Apna Dal (Soneylal) - ADAL', 
    'Asom Gana Parishad - AGP',
    'Hindustani Awam Morcha (Secular) - HAMS',
    'Janasena Party - JnP', 
    'Janata Dal  (Secular) - JD(S)',
    'Lok Janshakti Party(Ram Vilas) - LJPRV', 
    'Nationalist Congress Party - NCP',
    'Rashtriya Lok Dal - RLD', 
    'Sikkim Krantikari Morcha - SKM')

	update [India Election Results].dbo.partywise_results
set Alliance='I.N.D.I.A' where Party in ('Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK')

UPDATE [India Election Results].dbo.partywise_results
SET Alliance = 'OTHER'
WHERE Alliance IS NULL;

--Alliance wise seats won

select Alliance,sum(Won) as seats_won
from [India Election Results].dbo.partywise_results
group by Alliance
order by seats_won desc

--Winning candidate's name, their party name, total votes, and the margin of victory for a specific state and constituency?

SELECT cr.Winning_Candidate, p.Party, p.Alliance, cr.Total_Votes, cr.Margin, cr.Constituency_Name, s.State
FROM constituencywise_results cr
JOIN partywise_results p ON cr.Party_ID = p.Party_ID
JOIN statewise_results sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN states s ON sr.State_ID = s.State_ID
WHERE s.State = 'Uttar Pradesh' AND cr.Constituency_Name = 'AMETHI';

--What is the distribution of EVM votes versus postal votes for candidates in a specific constituency?


SELECT
    cd.Candidate,
    cd.Postal_Votes,
    cd.EVM_Votes,
	cd.Total_Votes,
    cr.Constituency_Name
FROM [India Election Results].dbo.constituencywise_details cd
JOIN [India Election Results].dbo.constituencywise_results cr 
    ON cd.Constituency_ID = cr.Constituency_ID
WHERE cr.Constituency_Name = 'HOWRAH'
order by cd.Total_Votes desc






--Which parties won the most seats in s State, and how many seats did each party win?
SELECT 
    p.Party,
    COUNT(cr.Constituency_ID) AS Seats_Won
FROM 
    constituencywise_results cr
JOIN 
    partywise_results p ON cr.Party_ID = p.Party_ID
JOIN 
    statewise_results sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN states s ON sr.State_ID = s.State_ID
WHERE 
    s.state = 'West Bengal'
GROUP BY 
    p.Party
ORDER BY 
    Seats_Won DESC;


--What is the total number of seats won by each party alliance (NDA, I.N.D.I.A, and OTHER) in each state for the India Elections 2024


select 

s.State as State_name,
sum(case when pr.Alliance ='NDA' then 1 else 0 end) as NDA_seas_won,
sum(case when pr.Alliance = 'I.N.D.I.A' then 1 else 0 end) as INDIA_seats_won,
sum(case when pr.Alliance = 'OTHER' then 1 else 0 end) as others_seats_won

from [India Election Results].dbo.constituencywise_results cr

join [India Election Results].dbo.partywise_results pr on cr.Party_ID=pr.Party_ID

join [India Election Results].dbo.statewise_results sr on  sr.Parliament_Constituency=cr.Parliament_Constituency

join [India Election Results].dbo.states s on s.State_ID=sr.State_ID

where pr.Alliance in ('NDA', 'I.N.D.I.A',  'OTHER')

group by s.State

order by s.State

--Which candidate received the highest number of EVM votes in each constituency (Top 10)?


	SELECT TOP 10 *
FROM (
    SELECT 
        cd.Candidate,
        cd.EVM_Votes,
        cr.Constituency_Name,
        ROW_NUMBER() OVER (
            PARTITION BY cr.Constituency_Name
            ORDER BY cd.EVM_Votes DESC
        ) AS RankByVotes
    FROM [India Election Results].dbo.constituencywise_details cd
    JOIN [India Election Results].dbo.constituencywise_results cr 
        ON cd.Constituency_ID = cr.Constituency_ID
) Ranked
WHERE RankByVotes = 1
ORDER BY EVM_Votes DESC;


WITH RankedCandidates AS (
    SELECT 
        cd.Constituency_ID,
        cd.Candidate,
        cd.Party,
        cd.EVM_Votes,
        cd.Postal_Votes,
        cd.EVM_Votes + cd.Postal_Votes AS Total_Votes,
        ROW_NUMBER() OVER (
            PARTITION BY cd.Constituency_ID 
            ORDER BY cd.EVM_Votes + cd.Postal_Votes DESC
        ) AS VoteRank
    FROM 
        [India Election Results].dbo.constituencywise_details cd
    JOIN 
        [India Election Results].dbo.constituencywise_results cr 
        ON cd.Constituency_ID = cr.Constituency_ID
    JOIN 
        [India Election Results].dbo.statewise_results sr 
        ON cr.Parliament_Constituency = sr.Parliament_Constituency
    JOIN 
        [India Election Results].dbo.states s 
        ON sr.State_ID = s.State_ID
    WHERE 
        s.State = 'Maharashtra'
)
SELECT 
    cr.Constituency_Name,
    MAX(CASE WHEN rc.VoteRank = 1 THEN rc.Candidate END) AS Winning_Candidate,
    MAX(CASE WHEN rc.VoteRank = 2 THEN rc.Candidate END) AS Runnerup_Candidate
FROM 
    RankedCandidates rc
JOIN 
    [India Election Results].dbo.constituencywise_results cr 
    ON rc.Constituency_ID = cr.Constituency_ID
GROUP BY 
    cr.Constituency_Name
ORDER BY 
    cr.Constituency_Name;
