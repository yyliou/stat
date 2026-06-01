# ============================================================
#  Statistics Online Quiz — app.R
#  Dependencies:
#    install.packages(c("shiny","shinyjs","shinyAce",
#                       "googlesheets4","httr","jsonlite"))
#  Run locally:  shiny::runApp("quiz/")
#  Deploy:       rsconnect::deployApp("quiz/")
#
#  GOOGLE SHEETS SETUP (one-time):
#    1. Go to https://console.cloud.google.com
#       → Create project → Enable "Google Sheets API"
#       → IAM & Admin → Service Accounts → Create service account
#       → Keys → Add Key → JSON  →  download and rename "service_account.json"
#       → place it in the quiz/ folder alongside app.R
#    2. Create a Google Sheet; share it with the service account email
#       (found inside service_account.json as "client_email")
#       and give it Editor access.
#    3. Copy the Sheet ID from the URL (between /d/ and /edit)
#       and paste it into SHEET_ID below.
# ============================================================

library(shiny)
library(shinyjs)
library(shinyAce)
library(googlesheets4)
library(httr)

# ── Configuration ─────────────────────────────────────────────
EXAM_TITLE <- "Statistics (1) — Midterm"
EXAM_INFO  <- "30 minutes  |  100 points total"
SHEET_ID   <- "1_nDP4pqCKuB9dCJZRqnNPXGSQebuXzckQFvyMaKsIuo"

# ── Authenticate once at startup ──────────────────────────────
if (file.exists("service_account.json")) {
  gs4_auth(path = "service_account.json")
} else {
  warning("service_account.json not found — submissions will NOT be saved to Google Sheets.")
}

# ── Questions ─────────────────────────────────────────────────
questions <- list(
  list(
    title = "Question 1  (50 pts)",
    text  = paste0("Represent the probability distribution for the number of ",
                   "heads when 3 fair coins are tossed, and draw a graph.")
  ),
  list(
    title = "Question 2  (50 pts)",
    text  = "Find the mean of the number of spots that appear when a fair die is rolled."
  ),
  list(
    title = "Question 2  (50 pts)",
    text  = "Find the mean of the number of spots that appear when a fair die is rolled."
  )
)
N <- length(questions)

# ── Get client IP from Shiny session ──────────────────────────
get_ip <- function(session) {
  tryCatch({
    info <- session$request
    # Check X-Forwarded-For first (set by Connect Cloud / proxies)
    fwd <- info$HTTP_X_FORWARDED_FOR
    if (!is.null(fwd) && nzchar(fwd)) {
      return(trimws(strsplit(fwd, ",")[[1]][1]))
    }
    info$REMOTE_ADDR %||% "unknown"
  }, error = function(e) "unknown")
}

# ── Save submission to Google Sheets ──────────────────────────
save_submission <- function(sid, sname, ip, codes, outputs) {
  row <- data.frame(
    timestamp    = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
    ip_address   = ip,
    student_id   = sid,
    student_name = sname,
    stringsAsFactors = FALSE
  )
  for (i in seq_len(N)) {
    row[[paste0("q", i, "_code")]]   <- if (is.null(codes[[i]]))   "" else codes[[i]]
    row[[paste0("q", i, "_output")]] <- if (is.null(outputs[[i]])) "" else outputs[[i]]
  }
  googlesheets4::sheet_append(SHEET_ID, row)
}

# ── Execute student code; capture text + plot ──────────────────
run_code <- function(code) {
  if (!nzchar(trimws(code)))
    return(list(text = "(no code submitted)", plot_file = NULL, error = FALSE))

  plot_file <- tempfile(fileext = ".png")
  txt <- character(0)
  err <- FALSE

  tryCatch({
    grDevices::png(plot_file, width = 680, height = 420, res = 96, bg = "white")
    txt <- utils::capture.output(
      eval(parse(text = code), envir = new.env(parent = globalenv()))
    )
    grDevices::dev.off()
  }, error = function(e) {
    try(grDevices::dev.off(), silent = TRUE)
    txt <<- paste0("Error: ", conditionMessage(e))
    err <<- TRUE
  })

  has_plot <- file.exists(plot_file) && file.info(plot_file)$size > 800
  list(
    text      = paste(txt, collapse = "\n"),
    plot_file = if (has_plot) plot_file else NULL,
    error     = err
  )
}

# ── CSS ───────────────────────────────────────────────────────
APP_CSS <- "
body { 
  font-family: 'Palatino Linotype', 'Book Antiqua', 'Palatino', 'Georgia', serif; 
  background: #f4f6f9; 
  font-size: 20px; /* name id */
}
.qz-wrap { max-width: 860px; margin: 36px auto 80px; padding: 0 16px; }
.qz-header {
  background: #2c4a6e; color: #fff;
  padding: 20px 28px; border-radius: 8px 8px 0 0; /* 邊邊圓角 */
}
.qz-header h2 { margin: 0 0 6px; font-size: 5rem; } /* 標題 */
.qz-header p  { margin: 0; opacity: .8; font-size: 2rem; } /* 副標題 */
.qz-body {
  background: #fff; border: 1px solid #d1d9e0; border-top: none;
  border-radius: 0 0 8px 8px; padding: 30px 36px;
  box-shadow: 0 2px 10px rgba(0,0,0,.07);
}
.prog-track { background:#e2e8f0; border-radius:4px; height:6px;
              margin-bottom:24px; overflow:hidden; }
.prog-bar   { background:#2c4a6e; height:100%; border-radius:4px;
              transition:width .3s ease; }
.q-text {
  -webkit-user-select:none; -moz-user-select:none;
  user-select:none; pointer-events:none;
  background:#f0f5fb; border-left:4px solid #2c4a6e;
  padding:16px 20px; border-radius:0 6px 6px 0; /* 微調內距增加呼吸感 */
  margin-bottom:18px; 
  font-size: 1.75rem; /* 題目 */
  line-height: 1.75;  /* 配合字型與字級，微調行高至 1.75 提高閱讀舒適度 */
}
.lbl  { font-weight:600; font-size: 1.75rem; color:#444; margin-bottom:6px; } /* 原 .87rem */
.note { font-size: 2rem; color:#999; margin-bottom:8px; } /* 原 .79rem */
.btn-run, .btn-run:focus {
  background:#2c4a6e !important; color:#fff !important;
  border-color:#2c4a6e !important;
}
.btn-run:hover { background:#1e3450 !important; border-color:#1e3450 !important; }
.out-wrap { margin-top:16px; }
.nav-row  { display:flex; align-items:center; gap:10px; margin-top:26px; }
.nav-row .spacer { flex:1; }
.inst-list li { margin-bottom:10px; line-height:1.8; font-size: 1.75rem; } /* 調大列表文字 */
.notice {
  background:#fff8e1; border-left:4px solid #f5a623;
  padding:12px 16px; border-radius:0 4px 4px 0;
  font-size: 1.75rem; margin:10px 0 14px; /* 原 .9rem */
}
.notice.warn { background:#fff3cd; border-color:#f0ad4e; font-size: 1.75rem; } /* 原 .92rem */
.done-box  { text-align:center; padding:44px 20px; }
.done-icon { font-size:3.5rem; color:#28a745; }
.done-box h3 { margin:12px 0 6px; font-size: 1.75rem; }
.done-box p  { color:#666; font-size: 1.75rem; }
.btn-primary { background:#2c4a6e !important; border-color:#2c4a6e !important; }
.btn-primary:hover { background:#1e3450 !important; }
"

# ── Anti-paste / anti-copy JavaScript ─────────────────────────
APP_JS <- "
document.addEventListener('contextmenu', function(e) { e.preventDefault(); });
document.addEventListener('paste', function(e) {
  var t = e.target;
  if (t && t.classList && t.classList.contains('ace_text-input')) {
    e.preventDefault(); e.stopImmediatePropagation();
  }
}, true);
document.addEventListener('keydown', function(e) {
  var t = e.target;
  if (t && t.classList && t.classList.contains('ace_text-input')) {
    if ((e.ctrlKey || e.metaKey) && (e.key === 'v' || e.key === 'V')) {
      e.preventDefault(); e.stopImmediatePropagation();
    }
  }
}, true);
"

# ── UI ────────────────────────────────────────────────────────
ui <- fluidPage(
  useShinyjs(),
  tags$head(
    tags$meta(charset = "UTF-8"),
    tags$title(EXAM_TITLE),
    tags$style(HTML(APP_CSS)),
    tags$script(HTML(APP_JS))
  ),

  div(class = "qz-wrap",

    div(class = "qz-header",
      tags$h2(EXAM_TITLE),
      tags$p(EXAM_INFO)
    ),

    div(class = "qz-body",

      # ── Page: Login & Instructions ───────────────────────
      div(id = "pg-login",
        tags$h3("Exam Instructions"),
        tags$hr(),
        tags$ul(class = "inst-list",
          tags$li("Enter your student ID and full name to begin."),
          tags$li(HTML("The exam has <strong>2 questions</strong>, 50 points each.")),
          tags$li(HTML("<strong>Paste is disabled.</strong> All R code must be typed manually.")),
          tags$li(HTML("Click <strong>Run Code</strong> to execute your answer before advancing. You may return to revise a previous question.")),
          tags$li(HTML("Clicking <strong>Submit</strong> is <strong>irreversible</strong>."))
        ),
        div(class = "notice",
          "Do not copy question text, take screenshots, or use external resources during the exam."
        ),
        fluidRow(
          column(5, textInput("inp_sid",  "Student ID:", placeholder = "e.g. D10627008")),
          column(5, textInput("inp_name", "Full Name:",  placeholder = "e.g. Yu-You Liou"))
        ),
        br(),
        actionButton("btn_start", "Begin Exam", class = "btn btn-primary btn-lg")
      ),

      # ── Pages: Questions (pre-rendered, toggled via shinyjs) ─
      lapply(seq_len(N), function(i) {
        div(id = paste0("pg-q", i), style = "display:none;",

          div(class = "prog-track",
            div(class = "prog-bar",
                style = sprintf("width:%.0f%%", (i - 1) / N * 100))
          ),
          tags$p(style = "color:#888; font-size:1.75rem; margin-bottom:5px;",
            sprintf("Question %d of %d", i, N)),
          tags$h4(questions[[i]]$title),
          div(class = "q-text", questions[[i]]$text),

          div(class = "lbl", "R Code:"),
          # div(class = "note", "Paste is disabled — please type your code."),
          aceEditor(
            outputId        = paste0("ace_q", i),
            value           = "",
            mode            = "r",
            theme           = "tomorrow",
            height          = "210px",
            fontSize        = 14,
            showLineNumbers = TRUE,
            debounce        = 200,
            autoComplete    = "disabled"
          ),
          br(),
          actionButton(paste0("btn_run", i), "Run Code",
                       class = "btn btn-run", icon = icon("play")),

          div(class = "out-wrap",
            div(class = "lbl", style = "margin-top:12px;", "Output:"),
            verbatimTextOutput(paste0("txt_out", i), placeholder = TRUE),
            plotOutput(paste0("plt_out", i), height = "350px")
          ),

          div(class = "nav-row",
            if (i > 1)
              actionButton(paste0("btn_prev", i), "Previous",
                           class = "btn btn-secondary",
                           icon = icon("arrow-left")),
            div(class = "spacer"),
            actionButton(paste0("btn_next", i),
                         if (i == N) "Review & Submit" else "Next",
                         class = "btn btn-primary",
                         icon = if (i == N) icon("check") else icon("arrow-right"))
          )
        )
      }),

      # ── Page: Review & Submit ────────────────────────────
      div(id = "pg-review", style = "display:none;",
        tags$h3("Review & Submit"),
        div(class = "notice warn",
          "Verify all questions have been answered and executed. Submission is irreversible."
        ),
        tableOutput("review_table"),
        div(class = "nav-row",
          actionButton("btn_back_review", "Revise",
                       class = "btn btn-secondary", icon = icon("arrow-left")),
          div(class = "spacer"),
          actionButton("btn_final_submit", "Submit",
                       class = "btn btn-danger btn-lg", icon = icon("check"),
                       onclick = "if(!confirm('Submit now? This cannot be undone.')) return false;")
        )
      ),

      # ── Page: Done ───────────────────────────────────────
      div(id = "pg-done", style = "display:none;",
        div(class = "done-box",
          div(class = "done-icon", icon("circle-check")),
          tags$h3("Submission Complete"),
          tags$p("Your responses have been recorded. You may close this window."),
          br(),
          uiOutput("done_info")
        )
      )

    ) # qz-body
  )   # qz-wrap
)

# ── Server ────────────────────────────────────────────────────
server <- function(input, output, session) {

  rv <- reactiveValues(
    ip      = "unknown",
    codes   = vector("list", N),
    outputs = vector("list", N),
    ran     = logical(N),
    errored = logical(N)
  )

  # Capture IP on session start
  observe({
    rv$ip <- get_ip(session)
  })

  all_pages <- c("pg-login", paste0("pg-q", seq_len(N)), "pg-review", "pg-done")
  go <- function(pg) { for (p in all_pages) hide(p); show(pg) }

  # ── Login ────────────────────────────────────────────────
  observeEvent(input$btn_start, {
    if (nchar(trimws(input$inp_sid)) < 2 || nchar(trimws(input$inp_name)) < 1) {
      showNotification("Please enter a valid Student ID and Full Name.",
                       type = "warning", duration = 3)
      return()
    }
    go("pg-q1")
  })

  # ── Per-question observers ───────────────────────────────
  lapply(seq_len(N), function(i) {

    # Run Code
    observeEvent(input[[paste0("btn_run", i)]], {
      code <- isolate(input[[paste0("ace_q", i)]])
      if (is.null(code)) code <- ""
      res <- run_code(code)
      rv$codes[[i]]   <- code
      rv$outputs[[i]] <- res$text
      rv$ran[i]       <- TRUE
      rv$errored[i]   <- res$error
    })

    # Text output
    output[[paste0("txt_out", i)]] <- renderText({
      if (!isTRUE(rv$ran[i]))
        return("[ Output appears here after running your code ]")
      rv$outputs[[i]]
    })

    # Plot output
    output[[paste0("plt_out", i)]] <- renderPlot({
      req(isTRUE(rv$ran[i]))
      code <- isolate(rv$codes[[i]])
      req(!is.null(code), nzchar(trimws(code)))
      eval(parse(text = code), envir = new.env(parent = globalenv()))
    }, bg = "white")

    # Next
    observeEvent(input[[paste0("btn_next", i)]], {
      code <- input[[paste0("ace_q", i)]]
      if (!is.null(code)) rv$codes[[i]] <- code
      if (!isTRUE(rv$ran[i])) {
        showNotification(
          sprintf("Please run your code for Question %d before proceeding.", i),
          type = "warning", duration = 3)
        return()
      }
      if (i < N) go(paste0("pg-q", i + 1)) else go("pg-review")
    })

    # Previous
    if (i > 1) {
      observeEvent(input[[paste0("btn_prev", i)]], {
        code <- input[[paste0("ace_q", i)]]
        if (!is.null(code)) rv$codes[[i]] <- code
        go(paste0("pg-q", i - 1))
      })
    }
  })

  # ── Review table ─────────────────────────────────────────
  output$review_table <- renderTable({
    data.frame(
      Q        = seq_len(N),
      Title    = sapply(questions, `[[`, "title"),
      Executed = ifelse(rv$ran,     "Yes", "No"),
      Error    = ifelse(rv$errored, "Yes", "—"),
      stringsAsFactors = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%", align = "l")

  observeEvent(input$btn_back_review, {
    go(paste0("pg-q", N))
  })

  # ── Final submit ─────────────────────────────────────────
  observeEvent(input$btn_final_submit, {
    tryCatch(
      save_submission(
        sid     = input$inp_sid,
        sname   = input$inp_name,
        ip      = rv$ip,
        codes   = rv$codes,
        outputs = rv$outputs
      ),
      error = function(e)
        showNotification(paste("Submission error:", e$message),
                         type = "error", duration = 8)
    )
    go("pg-done")
  })

  # ── Done info ────────────────────────────────────────────
  output$done_info <- renderUI({
    tags$table(style = "margin:0 auto; text-align:left;",
      tags$tr(tags$td(style = "padding:4px 16px; font-weight:600;", "Student ID:"),
              tags$td(input$inp_sid)),
      tags$tr(tags$td(style = "padding:4px 16px; font-weight:600;", "Name:"),
              tags$td(input$inp_name)),
      tags$tr(tags$td(style = "padding:4px 16px; font-weight:600;", "Submitted:"),
              tags$td(format(Sys.time(), "%Y-%m-%d %H:%M:%S")))
    )
  })
}

shinyApp(ui, server)
