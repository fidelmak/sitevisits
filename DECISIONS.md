# Decisions & Architecture Choices

### 1. Source of Truth & Disagreement Handling
- **Source of Truth**: The server (`FlakyTaskApi`) is the ultimate source of truth when online. `SharedPreferences` (`TaskLocalDatasource`) serves as an optimistic local source of truth for offline usage and pending edits.
- **Disagreement Handling**: Unsynced updates are tagged locally with `syncStatus` (`'pending'` or `'not saved retry'`). During fetches, `TaskRepository` merges remote data with local unsynced edits (`_mergeWithLocal`), prioritizing local edits until successfully synced to the server. Once synced, `syncStatus` is cleared and server data governs.

### 2. Failure Handling Walkthrough (`updateStatus`)
- **Step-by-Step Flow**:
  1. User toggles a visit status (e.g. `task_4`).
  2. `TaskBloc` immediately emits `TaskLoaded` with `syncStatus = 'pending'` (optimistic UI update).
  3. `TaskRepository.upDateTask` calls `FlakyTaskApi.updateStatus`, which throws an exception.
  4. `TaskRepository` catches the error, marks `task_4` as `'not saved retry'` in `SharedPreferences`.
  5. `TaskBloc` emits `TaskError("Couldn't update site visit #4")`, followed by `TaskLoaded` with `task_4` having status `'not saved retry'`.
- **User Display**: Floating red `AppSnackBar` displaying `"Couldn't update site visit #4"` with a **Retry** button. The visit card shows a red `"not saved retry"` status badge, and the app bar shows `"1 unsynced"`.
- **State Afterwards**: Fully functional `TaskLoaded` state with local edits preserved.

### 3. FlakyTaskApi Behaviors & Mitigation
- **Random Failures (15% fetch / 30% update errors)**: Wrapped all calls with try-catch blocks. Reads fall back to `SharedPreferences` cache; failed updates save locally as `'not saved retry'`.
- **Artificial Latency (200–1800ms)**: Implemented optimistic BLoC state updates so checkboxes toggle instantly before network resolution.
- **Data Edge Cases**: Handled `null` titles (`json['title'] ?? 'Untitled'`), disabled interactions on `archived` visits (`if (status == Status.archived) return`), and handled missing fields safely.

### 4. State Management Choice & Trade-offs
- **Choice**: `flutter_bloc` (`TaskBloc`, `TaskEvent`, `TaskState`).
- **Why**: Clean separation of business logic, predictable reactive states (`TaskLoading`, `TaskLoaded`, `TaskUpdated`, `TaskError`), easy event handling, and testability with `bloc_test`.
- **Trade-off**: Managing transient side-effects (e.g. error SnackBars) alongside screen state (`TaskLoaded`). Restoring `TaskLoaded` immediately after `TaskError` required precise state mapping to avoid blowing away the `ListView`.

### 5. Testing Strategy
- **What Was Tested**:
  - `TaskBloc` unit tests (`test/task_bloc_test.dart`): Verified event-to-state streams for `GetTask`, optimistic `UpdateTask` (pending state, formatted error `#4`), `SearchTasks`, and `RefreshTasks`.
  - `TaskRepository` & `TaskLocalDatasource` (`test/task_repository_test.dart`): Verified caching, offline fallback reads, `SharedPreferences` persistence, and unsynced task tracking.
  - Smoke test (`test/widget_test.dart`): Verified app UI rendering.
- **Why**: Focused on BLoC and Repository logic because they contain all sync guarantees, error formatting, and local storage rules.

### 6. Scope Omissions & Future 4-Hour Roadmap
- **Omitted**: Automatic background network re-connection listener.
- **Future Roadmap**:
  1. Add `connectivity_plus` listener to automatically retry unsynced tasks when back online.
  2. Implement pagination scroll position preservation during search/load-more.
  3. Add status filter tabs (All / Open / Done / Unsynced).
  4. Implement timestamp-based conflict resolution policies.

### 7. AI Tool Usage & Rejection Example
- **AI Usage**: Used for `bloc_test` syntax boilerplate and test scaffold generation.
- **Rejected Suggestion**: Rejected an AI suggestion to clear the search text field whenever focus was lost (`_handleFocusChange`). Clearing query on focus loss broke search usability when the user scrolled down results or dismissed the keyboard. Replaced it with persistent search text and a manual clear button (`X`).

### 8. Design Deviations & Filled Gaps

- **Status Badges**
- **Empty Search Feedback**
- **Retry Action**
