from flipside import Flipside
# from sequels import pools
import pandas as pd

pools = """

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
  
"""

def execute_query(sql):
  flipside = Flipside("aacbd3da-5f83-4039-a08f-92ccd15fa9f1", "https://api-v2.flipsidecrypto.xyz")
  query_result_set = flipside.query(sql)
  return query_result_set


def clean_data(data):
  result = {}
  
  for column in data.columns:
    result[column] = []
  
  for record in data.records:
    for column in data.columns:
      result[column].append(record[column])
  
  return pd.DataFrame(result)

if __name__ == "__main__":
  
  sql = execute_query(pools)
  
  df = clean_data(data=sql)



