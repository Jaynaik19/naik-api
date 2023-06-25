----------total fees stable/non-stable-----------

with fees_generated as (
  SELECT 
      swaps.token0_symbol,
      swaps.token1_symbol,
      pools.fee_percent,
      SUM((ABS(swaps.amount0_usd) + ABS(swaps.amount1_usd))/2) * pools.fee_percent / 100 AS fee_collected
  FROM
      ethereum.uniswapv3.ez_swaps swaps
  LEFT JOIN ethereum.uniswapv3.ez_pools pools ON swaps.pool_address = pools.pool_address
  GROUP BY 1, 2, 3
  HAVING fee_collected IS NOT NULL
  ),

categorize as (
    SELECT
      *,
      CASE
        WHEN token0_symbol IN ('USDT', 'USDC', 'DAI','TUSD') THEN 'stable'
        WHEN token1_symbol IN ('USDT', 'USDC', 'DAI','TUSD') THEN 'stable'
        ELSE 'non_stable'
      END AS classification
    FROM
      fees_generated),

summing_up as (

  SELECT sum(c.fee_collected) as fee_in_usd,
          c.classification
  FROM categorize c 
  GROUP BY c.classification

)

SELECT * FROM summing_up