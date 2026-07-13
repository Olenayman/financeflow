# FinanceFlow

FinanceFlow is a responsive Flutter web application for tracking personal income and expenses. The app helps users add entries, categorize them, review saved data, inspect a detail route for each entry, and view statistics over totals, categories, and time.

## Deployed App

Deployed URL: `TBD`

Replace `TBD` with the final web deployment link before submitting the project.

## How To Use

1. Open the deployed web app in a modern browser.
2. Go to the Entries screen.
3. Select Add entry.
4. Fill in the title, amount, category, type, and date, then save the entry.
5. Open an entry from the list to view its detail screen at `/entry/:id`.
6. Go to the Statistics screen to review totals and breakdowns.

## Project Features

- Add income and expense entries with a form
- Categorize entries by label
- View all saved entries
- Open a path-based detail screen for each entry using `/entry/:id`
- Review statistics for totals, categories, and time-based spending
- Persist data locally with shared_preferences
- Use go_router for navigation
- Responsive layout for mobile, tablet, and larger screens

## Submission Notes

- The project uses [lib/main.dart](lib/main.dart) as the Flutter app entry point.
- A mirror entrypoint for the handout zip layout is provided in [src/main.dart](src/main.dart).
- The submission zip should include this README at the root and avoid binary files.
- The deployment URL must be filled in before final submission.

## Packages Used

- shared_preferences
- go_router
