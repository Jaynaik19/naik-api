with pool_tvl AS (

SELECT 
    avg(TOKEN0_BALANCE_USD + TOKEN1_BALANCE_USD) AS Total_avg_tvl,
    TOKEN0_SYMBOL AS token0_symbol,
    TOKEN1_SYMBOL AS token1_symbol
FROM ethereum.uniswapv3.ez_pool_stats
  WHERE TOKEN0_BALANCE_USD IS NOT NULL AND TOKEN1_BALANCE_USD IS NOT NULL
GROUP BY 2,3
),

 categorize as (
    SELECT
      sum(Total_avg_tvl),
      CASE
        WHEN token0_symbol IN ('USDT', 'USDC', 'DAI','TUSD') THEN 'stable'
        WHEN token1_symbol IN ('USDT', 'USDC', 'DAI','TUSD') THEN 'stable'
        ELSE 'non_stable'
      END AS classification
    FROM pool_tvl
 GROUP BY 2
      )
SELECT * FROM categorize