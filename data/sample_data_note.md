# Data Note

이 프로젝트는 온라인 리테일 거래 데이터 `ecommerce_data.csv`를 사용합니다.

## Data Period

- 2010-12-01 ~ 2011-12-09

## Raw Data

- Rows: 541,909
- Columns: 8
- Main columns: `InvoiceNo`, `StockCode`, `Description`, `Quantity`, `InvoiceDate`, `UnitPrice`, `CustomerID`, `Country`

## Analysis Scope

분석에서는 실제 구매 거래만 보기 위해 취소 거래, 0 이하 수량/단가, 비상품성 코드, 극단 수량값을 제외했습니다.

`CustomerID`가 없는 거래는 비회원 거래로 분류했습니다. 단, 비회원은 고객 단위 식별이 불가능하므로 재구매율 분석에서는 제외했습니다.
