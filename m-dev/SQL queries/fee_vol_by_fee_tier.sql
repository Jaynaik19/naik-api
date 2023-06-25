
 /*Total fee volume by fee tier*/

 with all_trades AS (
SELECT
  p.pool_name,
  p.fee_percent,
  SUM((ABS(amount0_usd) + ABS(amount1_usd))/2) * p.fee_percent / 100 as fees_collected,
  RANK() OVER(ORDER BY fees_collected DESC ) as rank
FROM ethereum.uniswapv3.ez_swaps s
JOIN ethereum.uniswapv3.ez_pools p
ON s.pool_address = p.pool_address
GROUP BY 1,2
),

 fee_by_volume as (
  
    SELECT 
            CASE WHEN fee_percent = 1 THEN '1'
                    WHEN fee_percent = 0.05 THEN '0.05'
                    WHEN fee_percent = 0.3 THEN '0.3'
                    WHEN fee_percent = 0.01 THEN '0.01'
                    ELSE 'Others'
                    END as fee_percent,
            SUM(fees_collected) as Volume 
    FROM all_trades 
    GROUP by 1
    ORDER by 1 DESC
  )
  
  SELECT * FROM fee_by_volume
  