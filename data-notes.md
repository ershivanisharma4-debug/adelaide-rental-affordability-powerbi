# Data notes

## Source
SA Government **Private Rent Report**, quarterly, published on data.sa.gov.au (Creative Commons Attribution licence). Based on rental bonds lodged with Consumer and Business Services for private rental properties.

## Period
12 quarters: September 2023 – June 2026.

## Cleaning decisions
| Issue | Decision | Reason |
|---|---|---|
| `*` values | Replaced with null | Published when too few bonds were lodged; zero would distort averages |
| Blank suburb rows | Removed | Notes and spacer rows from the Excel layout |
| `Row Labels` rows | Removed | Excel pivot table headings, not suburbs |
| `Metro Total`, `Country Total`, `Grand Total` | Removed | Summary rows that double-counted bonds |
| Duplicate rows (Mount Barker, Virginia – 3-bed houses, June 2024) | One copy kept | Genuine duplicates in the source file |
| Non-Excel files in folder | Filtered out | Prevents refresh errors from Excel lock files |

## Analytical rules
- **Weighted median rent:** suburb medians weighted by bond count.
- **Growth:** same quarter vs. previous year; minimum **30 bonds in both years** for rankings.
- **Rental stress:** rent above **30%** of gross weekly household income.

## Limitations
- The weighted median approximates, but is not, a true overall median.
- Suppressed small samples are excluded.
- Data covers new leases only, not all existing tenancies.
- Affordability uses a single user-selected income, not local income data.
