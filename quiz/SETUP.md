# Statistics Quiz — Setup Guide

---

## quiz.html  (static page, no server needed)

### Step 1 — Create a Google Sheet

Open Google Sheets and create a new blank spreadsheet.

### Step 2 — Add the Apps Script backend

In the Sheet: **Extensions → Apps Script**. Delete any existing code and paste:

```javascript
function doPost(e) {
  try {
    const data  = JSON.parse(e.postData.contents);
    const sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();

    // Build header row on first submission
    if (sheet.getLastRow() === 0) {
      const header = ['Timestamp', 'Student ID', 'Name'];
      const n = data.n_questions || 2;
      for (let i = 1; i <= n; i++) {
        header.push(`Q${i} Code`, `Q${i} Output`);
      }
      sheet.appendRow(header);
    }

    const row = [data.timestamp, data.student_id, data.student_name];
    const n = data.n_questions || 2;
    for (let i = 1; i <= n; i++) {
      row.push(data[`q${i}_code`] || '', data[`q${i}_output`] || '');
    }
    sheet.appendRow(row);

    return ContentService
      .createTextOutput(JSON.stringify({ status: 'ok' }))
      .setMimeType(ContentService.MimeType.JSON);

  } catch (err) {
    return ContentService
      .createTextOutput(JSON.stringify({ status: 'error', message: err.toString() }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}
```

Click **Save** (Ctrl+S).

### Step 3 — Deploy as Web App

**Deploy → New deployment → Web app**
- Execute as: **Me**
- Who has access: **Anyone**

Click **Deploy** → copy the **Web App URL**.

### Step 4 — Paste the URL into quiz.html

Open `quiz.html` and replace line ~323:
```javascript
const APPS_SCRIPT_URL = 'https://script.google.com/macros/s/YOUR_SCRIPT_ID/exec';
```
with the URL you just copied.

### Step 5 — Host quiz.html on GitHub Pages

Push `quiz.html` to any public GitHub repo → Settings → Pages → Deploy from branch.
Share the GitHub Pages URL with students.

---

## app.R  (Shiny version — requires server)


## 1. Install dependencies (run once in R)

```r
install.packages(c("shiny", "shinyjs", "shinyAce", "png", "grid"))
```

## 2. Run locally (for testing)

```r
shiny::runApp("quiz/")
```

## 3. Deploy to shinyapps.io

```r
install.packages("rsconnect")
rsconnect::setAccountInfo(name   = "YOUR_ACCOUNT",
                          token  = "YOUR_TOKEN",
                          secret = "YOUR_SECRET")
rsconnect::deployApp("quiz/")
```

Get your token from: https://www.shinyapps.io → Account → Tokens

## 4. Student answers (backend)

All submissions are saved to:

```
quiz/answers/student_answers.csv    ← one row per student
quiz/answers/{student_id}_q1.png   ← Q1 plot (if any)
quiz/answers/{student_id}_q2.png   ← Q2 plot (if any)
```

> **shinyapps.io note:** The free tier does not persist files between
> app restarts. For a real exam, either:
> - Use a paid tier with a persistent volume, **or**
> - Replace `save_submission()` in app.R with a Google Sheets write
>   using the `googlesheets4` package (contact me for the snippet).

## 5. Adding / editing questions

Edit the `questions` list near the top of `app.R`:

```r
questions <- list(
  list(id = 1, title = "Question 1 (50 pts)", text = "..."),
  list(id = 2, title = "Question 2 (50 pts)", text = "...")
)
```

Add more list items to add more questions. `N` is computed automatically.

## 6. Anti-cheat features included

| Feature | Method |
|---|---|
| Question text cannot be selected | CSS `user-select: none` |
| Right-click disabled | JS `contextmenu` preventDefault |
| Paste blocked in code editor | JS capture-phase `paste` + `keydown` listeners on `.ace_text-input` |
| Must run code before advancing | Server-side gate on `rv$ran[i]` |
| Submit confirmation dialog | JS `confirm()` on button `onclick` |
| Submit is irreversible | Page transition to done; no back button |
