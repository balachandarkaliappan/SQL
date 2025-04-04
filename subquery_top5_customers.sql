-- Question 1:

EXPLAIN
SELECT
	AVG(TOTAL_PAYMENT) AS AVERAGE
FROM
	(
	SELECT
		B.CUSTOMER_ID,
		B.FIRST_NAME,
		B.LAST_NAME,
		D.CITY,
		E.COUNTRY,
		SUM(A.AMOUNT) AS TOTAL_PAYMENT
	FROM
		PAYMENT A
		INNER JOIN CUSTOMER B ON A.CUSTOMER_ID = B.CUSTOMER_ID
		INNER JOIN ADDRESS C ON B.ADDRESS_ID = C.ADDRESS_ID
		INNER JOIN CITY D ON C.CITY_ID = D.CITY_ID
		INNER JOIN COUNTRY E ON D.COUNTRY_ID = E.COUNTRY_ID
		WHERE
		(E.COUNTRY, D.CITY) IN (
			SELECT
			D.COUNTRY,
			C.CITY
			FROM
			CUSTOMER A
				INNER JOIN ADDRESS B ON A.ADDRESS_ID = B.ADDRESS_ID
				INNER JOIN CITY C ON B.CITY_ID = C.CITY_ID
				INNER JOIN COUNTRY D ON C.COUNTRY_ID = D.COUNTRY_ID
	WHERE
		D.COUNTRY IN (
		SELECT
		D.COUNTRY
		FROM
		CUSTOMER A
		INNER JOIN ADDRESS B ON A.ADDRESS_ID = B.ADDRESS_ID
		INNER JOIN CITY C ON B.CITY_ID = C.CITY_ID
		INNER JOIN COUNTRY D ON C.COUNTRY_ID = D.COUNTRY_ID
		GROUP BY
			D.COUNTRY
			ORDER BY
			COUNT(A.CUSTOMER_ID) DESC
			LIMIT
			10
			)
	GROUP BY
		D.COUNTRY,
		C.CITY
		ORDER BY
		COUNT(A.CUSTOMER_ID) DESC
		LIMIT
		10
			)
	GROUP BY
		B.CUSTOMER_ID,
		D.CITY,
		B.FIRST_NAME,
		B.LAST_NAME,
		E.COUNTRY
		ORDER BY
		TOTAL_PAYMENT DESC
		LIMIT
		5
	) AS TOTAL_AMOUNT_PAID;


-- Question 2:

EXPLAIN
SELECT
	E.COUNTRY,
	COUNT(DISTINCT B.CUSTOMER_ID) AS ALL_CUSTOMER_COUNT,
	COUNT(DISTINCT TOP_5_CUSTOMERS) AS TOP_CUSTOMER_COUNT
FROM
	CUSTOMER B
	INNER JOIN ADDRESS C ON B.ADDRESS_ID = C.ADDRESS_ID
	INNER JOIN CITY D ON C.CITY_ID = D.CITY_ID
	INNER JOIN COUNTRY E ON D.COUNTRY_ID = E.COUNTRY_ID
	LEFT JOIN (
		SELECT
			B.CUSTOMER_ID,
			B.FIRST_NAME,
			B.LAST_NAME,
			E.COUNTRY,
			D.CITY,
			SUM(A.AMOUNT) AS TOTAL_AMOUNT_PAID
		FROM
			PAYMENT A
			INNER JOIN CUSTOMER B ON A.CUSTOMER_ID = B.CUSTOMER_ID
			INNER JOIN ADDRESS C ON B.ADDRESS_ID = C.ADDRESS_ID
			INNER JOIN CITY D ON C.CITY_ID = D.CITY_ID
			INNER JOIN COUNTRY E ON D.COUNTRY_ID = E.COUNTRY_ID
		WHERE
			D.CITY IN (
				SELECT
					D.CITY
				FROM
					CUSTOMER B
					INNER JOIN ADDRESS C ON B.ADDRESS_ID = C.ADDRESS_ID
					INNER JOIN CITY D ON C.CITY_ID = D.CITY_ID
					INNER JOIN COUNTRY E ON D.COUNTRY_ID = E.COUNTRY_ID
				WHERE
					E.COUNTRY IN (
						SELECT
							E.COUNTRY
						FROM
							CUSTOMER B
							INNER JOIN ADDRESS C ON B.ADDRESS_ID = C.ADDRESS_ID
							INNER JOIN CITY D ON C.CITY_ID = D.CITY_ID
							INNER JOIN COUNTRY E ON D.COUNTRY_ID = E.COUNTRY_ID
						GROUP BY
							E.COUNTRY
						ORDER BY
							COUNT(B.CUSTOMER_ID) DESC
						LIMIT
							10
					)
				GROUP BY
					E.COUNTRY,
					D.CITY
				ORDER BY
					COUNT(B.CUSTOMER_ID) DESC
				LIMIT
					10
			)
		GROUP BY
			B.CUSTOMER_ID,
			B.FIRST_NAME,
			B.LAST_NAME,
			E.COUNTRY,
			D.CITY
		ORDER BY
			SUM(A.AMOUNT) DESC
		LIMIT
			5
	) AS TOP_5_CUSTOMERS ON B.CUSTOMER_ID = TOP_5_CUSTOMERS.CUSTOMER_ID
GROUP BY
	E.COUNTRY
ORDER BY
	ALL_CUSTOMER_COUNT DESC
LIMIT
	10;
---
