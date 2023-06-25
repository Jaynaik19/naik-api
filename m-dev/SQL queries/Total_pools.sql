

/* TOTAL POOLS - Stable / Non-stable */

WITH
  pools as (
    SELECT
      pools.BLOCK_TIMESTAMP,
      pools.BLOCKCHAIN,
      pools.POOL_ADDRESS,
      pools.TOKEN0_SYMBOL as token0_symbol,
      pools.TOKEN1_SYMBOL as token1_symbol,
      pools.TOKEN0_ADDRESS AS token0,
      pools.TOKEN1_ADDRESS AS token1
    FROM
      ethereum.uniswapv3.ez_pools pools
  ),
  categorize as (
    SELECT
      *,
      CASE
        WHEN token0_symbol IN ('USDT', 'USDC', 'DAI', 'TUSD') THEN 'stable'
        WHEN token1_symbol IN ('USDT', 'USDC', 'DAI', 'TUSD') THEN 'stable'
        ELSE 'non_stable'
      END AS classification
    FROM
      pools
  ),
  main as (
    SELECT
      COUNT(
        CASE
          WHEN classification = 'stable' THEN 1
        END
      ) as count_,
      'Stablecoin count' as label
    FROM
      categorize
    UNION ALL
    SELECT
      COUNT(
        CASE
          WHEN classification = 'non_stable' THEN 1
        END
      ) as count_,
      'Nonstablecoin count' as label
    FROM
      categorize
  )
SELECT
  *
FROM
  main