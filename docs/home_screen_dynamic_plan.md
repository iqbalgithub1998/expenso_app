# Home Screen — Static → Dynamic Data Plan

Goal: Replace all hard-coded/static values in `lib/screens/dashboard/home_screen.dart`
(driven by `lib/controllers/home_controller.dart`) with live data pulled from the
existing controllers and Supabase.

---

## Current state (what is static today)

`HomeController` holds fixed `.obs` values and a hand-written transaction list:

| UI element | Widget | Source today | Should come from |
|---|---|---|---|
| Greeting name | App bar | `userName = 'Alex'` | `ProfileController.displayName` |
| Total Expenses | Hero card | `totalExpense = '$14,285.60'` | `ExpenseController` (current month total) |
| Pending Lend | Stat tile | `pendingLend = '$2,400'` | `LendBorrowController.netLend` |
| Borrowed | Stat tile | `totalBorrowed = '$840'` | `LendBorrowController.netBorrow` |
| Recent list | Transactions | hard-coded `transactions` list | `ExpenseController` recent transactions |
| Trend chart | `_ChartCard` | hard-coded `FlSpot`s | `ExpenseController` monthly totals (last 6 months) |
| "+12.5% vs last month" | Hero chip | literal string | month-over-month delta (optional) |

## Existing data sources (already in the app)

- **`ExpenseController`** — fetches `expense` rows from Supabase. Exposes
  `totalExpense` (current month, `String`), `filteredTransactions`,
  private `_allTransactions` (sorted newest-first). Uses `$` formatting.
- **`LendBorrowController`** — `netLend` / `netBorrow` (`RxDouble`) from
  `friends_repository.fetchNetBalance()`. Uses `₹` formatting.
- **`ProfileController`** — `displayName`, `user` (from `user_profile` table).

Note: the codebase is currency-inconsistent (expenses use `$`, lend/borrow uses
`₹`). For the home screen we will standardize on **`₹`**, matching the real entry
flow (`add_expense` enters amounts in `₹`).

## Wiring / lifecycle notes

- `DashboardScreen` uses an `IndexedStack`, so Home/Expense/Lend screens build in
  the same frame. `ExpenseController` and `LendBorrowController` are `Get.put` inside
  their own screens. To be safe, `HomeController` will resolve them defensively:
  `Get.isRegistered<X>() ? Get.find<X>() : Get.put(X())`.
- Reactivity: the `Obx` blocks already in `home_screen.dart` will re-read the
  source controllers' observables, so derived getters stay reactive.

---

## Steps (one per iteration)

- [x] **Step 1** — Add reactive helper getters to `ExpenseController`
  (numeric month total, recent-N transactions, 6-month trend spots) so Home can
  consume them without touching private state.
- [ ] **Step 2** — Rewrite `HomeController`: drop the static `.obs` strings and the
  hand-written `transactions` list; add getters that derive from
  `ExpenseController` / `LendBorrowController` / `ProfileController`. Add a
  `refresh()` and wire `onAddExpenseTap` / actions to real navigation/refresh.
- [ ] **Step 3** — Update `home_screen.dart` to consume the new getters
  (greeting, hero total, stat tiles, recent transactions list).
- [ ] **Step 4** — Make the trend chart (`_ChartCard`) dynamic from the 6-month
  trend data instead of literal `FlSpot`s.
- [ ] **Step 5** — Handle empty/loading states (no expenses yet, balances 0) and
  verify with `flutter analyze`.

---

## Progress log

- Plan created.
- Step 1 done: added `monthTotalAmount`, `recentTransactions([count])`,
  `last6MonthsTotals`, `last6MonthsLabels`, and `_amountOf()` helper to
  `ExpenseController`. `flutter analyze` clean.
