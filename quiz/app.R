

library(shiny)
library(shinyjs)
library(shinyAce)
library(googlesheets4)
library(httr)

# ── Configuration ─────────────────────────────────────────────
EXAM_TITLE <- "Statistics — Midterm"
EXAM_INFO  <- "30 minutes  |  100 points total"
SHEET_ID   <- "1_nDP4pqCKuB9dCJZRqnNPXGSQebuXzckQFvyMaKsIuo"

# ── Authenticate once at startup ──────────────────────────────
if (file.exists("service_account.json")) {
  gs4_auth(path = "service_account.json")
} else {
  warning("service_account.json not found — submissions will NOT be saved.")
}

# ── Questions ─────────────────────────────────────────────────
questions <- list(
  list(
    title = "Question 1  (50 pts)",
    text  = HTML(paste0("Represent the probability distribution for the number of ",
                   "heads when 3 fair coins are tossed, and draw a graph.",
                   "Hint: use <code>plot(x, type = 'h')</code>"))
  ),
  list(
    title = "Question 1  (50 pts)",
    text  = HTML("Find the mean value of x. $$\\sum x = 45,\\ n = 9$$")
  )
)
N <- length(questions)

# ── Get client IP ─────────────────────────────────────────────
get_ip <- function(session) {
  tryCatch({
    info <- session$request
    fwd  <- info$HTTP_X_FORWARDED_FOR
    if (!is.null(fwd) && nzchar(fwd))
      return(trimws(strsplit(fwd, ",")[[1]][1]))
    info$REMOTE_ADDR %||% "unknown"
  }, error = function(e) "unknown")
}

# ── Save to Google Sheets ──────────────────────────────────────
save_submission <- function(sid, sname, ip, codes, outputs) {
  row <- data.frame(
    timestamp    = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
    ip_address   = ip,
    student_id   = sid,
    student_name = sname,
    stringsAsFactors = FALSE
  )
  for (i in seq_len(N)) {
    row[[paste0("q", i, "_code")]]   <- codes[[i]]   %||% ""
    row[[paste0("q", i, "_output")]] <- outputs[[i]] %||% ""
  }
  googlesheets4::sheet_append(SHEET_ID, row)
}

# ── Execute student code: capture text output + render PNG ────
#
#   Approach: open a PNG device, run the code once, close the
#   device.  Text is captured via capture.output().  The saved
#   PNG is later served directly with renderImage — the code is
#   NEVER re-evaluated for plotting, which eliminates device
#   conflicts and sluggishness.
#
run_code <- function(code) {
  if (!nzchar(trimws(code)))
    return(list(text = "(no code submitted)", plot_file = NULL, error = FALSE))

  plot_file  <- tempfile(fileext = ".png")
  txt        <- ""
  err        <- FALSE
  dev_opened <- FALSE

  tryCatch({
    # Open PNG device first, then capture text while drawing
    grDevices::png(plot_file, width = 800, height = 500, res = 96, bg = "white")
    dev_opened <- TRUE
    env   <- new.env(parent = globalenv())
    exprs <- parse(text = code)
    lines <- character(0)
    # 逐條執行，用 withVisible() 模擬 R console 自動印出行為
    for (ex in exprs) {
      out <- utils::capture.output({
        res <- withVisible(eval(ex, envir = env))
        if (res$visible) print(res$value)
      })
      if (length(out) > 0) lines <- c(lines, out)
    }
    txt <- paste(lines, collapse = "\n")
  }, error = function(e) {
    err <<- TRUE
    txt <<- paste0("Error: ", conditionMessage(e))
  })

  # Always close the device
  if (dev_opened) try(grDevices::dev.off(), silent = TRUE)

  has_plot <- file.exists(plot_file) && file.info(plot_file)$size > 1000
  list(
    text      = if (nzchar(txt)) txt else "",
    plot_file = if (has_plot) plot_file else NULL,
    error     = err
  )
}

# ── CSS ───────────────────────────────────────────────────────
APP_CSS <- "
/* ── 整體頁面：字型、字級、背景色、文字色 ── */
body {
  font-family: 'Palatino Linotype', 'Book Antiqua', 'Palatino', 'Georgia', serif; /* 調整字型 */
  font-size: 20px;          /* 調整整體基準字級（所有 rem 以此為基礎） */
  background: #f0f2f5;      /* 調整頁面背景色 */
  color: #1a1a1a;           /* 調整全域文字色 */
}
.qz-wrap {
  max-width: 900px;
  margin: 40px auto 80px;
  padding: 0 20px;
}

/* ── 頁首橫幅（深藍色標題列） ── */
.qz-header {
  background: #2c4a6e;      /* 調整頁首背景色 */
  color: #fff;              /* 調整頁首文字色 */
  padding: 22px 34px;
  border-radius: 6px 6px 0 0;
}
.qz-header h2 {
  margin: 0 0 4px;
  font-size: 5rem;          /* 調整考試標題字級 */
  font-weight: 600;
  letter-spacing: .02em;
}
.qz-header p {
  margin: 0;
  opacity: .78;
  font-size: 2rem;       /* 調整頁首副標（時間／總分）字級 */
  font-family: 'Segoe UI', Arial, sans-serif;
}

/* ── 主內容區 ── */
.qz-body {
  background: #fff;         /* 調整主內容區背景色 */
  border: 1px solid #c8d0da;
  border-top: none;
  border-radius: 0 0 6px 6px;
  padding: 36px 44px;
  box-shadow: 0 2px 8px rgba(0,0,0,.06);
}

/* ── 進度條 ── */
.prog-track {
  background: #dde3ea;      /* 調整進度條底色 */
  border-radius: 3px;
  height: 5px;
  margin-bottom: 28px;
  overflow: hidden;
}
.prog-bar {
  background: #2c4a6e;      /* 調整進度條填滿色 */
  height: 100%;
  border-radius: 3px;
  transition: width .3s ease;
}

/* ── 題目文字區（藍色左邊線方塊） ── */
.q-text {
  -webkit-user-select: none;
  -moz-user-select: none;
  user-select: none;
  pointer-events: none;
  background: #f7f9fc;      /* 調整題目區背景色 */
  border-left: 4px solid #2c4a6e; /* 調整題目區左邊線顏色 */
  padding: 16px 22px;
  border-radius: 0 4px 4px 0;
  margin-bottom: 22px;
  font-size: 2.24rem;       /* 調整題目文字字級 */
  line-height: 1.8;
}

/* ── 小標籤（R Code:、Output: 等） ── */
.lbl {
  font-weight: 600;
  font-size: 2rem;          /* 調整標籤字級 */
  color: #333;              /* 調整標籤文字色 */
  margin-bottom: 5px;
  font-family: 'Segoe UI', Arial, sans-serif;
}

/* ── 提示小字（Paste is disabled…） ── */
.note {
  font-size: 1.74rem;       /* 調整提示小字字級 */
  color: #888;              /* 調整提示小字顏色 */
  margin-bottom: 8px;
  font-family: 'Segoe UI', Arial, sans-serif;
}

/* ── Run Code 按鈕 ── */
.btn-run, .btn-run:focus {
  background: #2c4a6e !important;  /* 調整 Run Code 按鈕背景色 */
  color: #fff !important;
  border-color: #2c4a6e !important;
  font-size: 1.94rem !important;   /* 調整 Run Code 按鈕字級 */
}
.btn-run:hover {
  background: #1e3450 !important;  /* 調整 Run Code 按鈕 hover 色 */
  border-color: #1e3450 !important;
}

/* ── 輸出區與圖表區 ── */
.out-wrap { margin-top: 18px; }
.plot-wrap {
  margin-top: 10px;
  border: 1px solid #e0e4ea;  /* 調整圖表外框色 */
  border-radius: 4px;
  background: #fafafa;        /* 調整圖表區背景色 */
  overflow: hidden;
}
.plot-wrap img { display: block; width: 100%; height: auto; }
.plot-wrap .shiny-image-output { width: 100% !important; }

/* ── 導覽按鈕列 ── */
.nav-row {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-top: 30px;
}
.nav-row .spacer { flex: 1; }

/* ── 說明條列（登入頁指引） ── */
.inst-list { font-size: 2.06rem; }  /* 調整指引條列字級 */
.inst-list li { margin-bottom: 10px; line-height: 1.75; }

/* ── 公告提示框（黃色警示） ── */
.notice {
  background: #fdf6e3;      /* 調整提示框背景色 */
  border-left: 4px solid #c8960c; /* 調整提示框左邊線色 */
  padding: 11px 16px;
  border-radius: 0 4px 4px 0;
  font-size: 1.94rem;       /* 調整提示框字級 */
  margin: 12px 0 18px;
}
.notice.warn {
  background: #fff3cd;      /* 調整警告框背景色 */
  border-color: #c8960c;
  font-size: 1.94rem;       /* 調整警告框字級 */
}

/* ── 完成頁面 ── */
.done-box { text-align: center; padding: 50px 20px; }
.done-icon { font-size: 7rem; color: #28a745; }  /* 調整完成圖示大小／顏色 */
.done-box h3 { margin: 14px 0 8px; font-size: 2.8rem; }  /* 調整完成標題字級 */
.done-box p { color: #555; font-size: 2rem; }            /* 調整完成說明文字字級 */

/* ── 所有導覽按鈕（統一字級） ── */
.btn-primary, .btn-secondary, .btn-danger, .btn-lg {
  font-size: 1.94rem !important;   /* 調整所有按鈕字級 */
}
.btn-primary {
  background: #2c4a6e !important;  /* 調整主要按鈕背景色 */
  border-color: #2c4a6e !important;
}
.btn-primary:hover { background: #1e3450 !important; }  /* 調整主要按鈕 hover 色 */

/* ── 程式輸出文字區 ── */
pre.shiny-text-output {
  font-size: 1.86rem !important;  /* 調整輸出文字字級 */
  border: 1px solid #e0e4ea;
  border-radius: 4px;
  background: #fafafa;            /* 調整輸出區背景色 */
  padding: 10px 14px;
}
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
    tags$script(HTML(APP_JS)),
    # MathJax 設定：啟用 \(...\) 與 $$...$$ 語法
    tags$script(HTML(
      "window.MathJax = { tex: { inlineMath: [['\\\\(','\\\\)']], displayMath: [['$$','$$']] } };"
    )),
    tags$script(src = "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js",
                async = NA)
  ),

  div(class = "qz-wrap",

    div(class = "qz-header",
      tags$h2(EXAM_TITLE),
      tags$p(EXAM_INFO)
    ),

    div(class = "qz-body",

      # ── Page: Login & Instructions ───────────────────────
      div(id = "pg-login",
        tags$h3(HTML("<strong>Exam Instructions</strong>")),
        tags$hr(),
        tags$ul(class = "inst-list",
          tags$li(HTML("Ensure that you enter your <strong>correct Student ID and full name</strong>, as these cannot be changed once you begin.")),
          tags$li(HTML("The exam has <strong>2 questions</strong>, 50 points each.")),
          tags$li(HTML("<strong>Copy and Paste are disabled.</strong> All R code must be typed manually.")),
          tags$li(HTML("Click <strong>Run Code</strong> to execute your answer before advancing. You may return to revise a previous question."))
        ),
        div(class = "notice",
          "Screenshots are strictly prohibited. Anyone caught taking screenshots will be deemed cheating and receive a score of zero."
        ),
        fluidRow(
          column(5, textInput("inp_sid",  "Student ID", placeholder = "e.g. D10627008")),
          column(5, textInput("inp_name", "Full Name",  placeholder = "e.g. Yu-You Liou"))
        ),
        br(),
        actionButton("btn_start", "Begin Exam", class = "btn btn-primary btn-lg")
      ),

      # ── Pages: Questions ──────────────────────────────────
      lapply(seq_len(N), function(i) {
        div(id = paste0("pg-q", i), style = "display:none;",

          div(class = "prog-track",
            div(class = "prog-bar",
                style = sprintf("width:%.0f%%", (i - 1) / N * 100))
          ),
          tags$p(style = "color:#777; font-size:2.7rem; margin-bottom:6px;",
            sprintf("Question %d of %d", i, N)),
          tags$h4(style = "font-size:2.7rem; font-weight:700; margin:6px 0 14px;",
                  questions[[i]]$title),
          div(class = "q-text", questions[[i]]$text),

          div(class = "lbl", "R Code"),
          div(class = "note", ""),
          aceEditor(
            outputId        = paste0("ace_q", i),
            value           = "",
            mode            = "r",
            theme           = "tomorrow",
            height          = "360px",
            fontSize        = 30,
            showLineNumbers = TRUE,
            debounce        = 200,
            autoComplete    = "disabled"
          ),
          br(),
          actionButton(paste0("btn_run", i), "Run Code",
                       class = "btn btn-run", icon = icon("play")),

          div(class = "out-wrap",
            div(class = "lbl", style = "margin-top:14px;", "Output"),
            verbatimTextOutput(paste0("txt_out", i), placeholder = TRUE),
            # Plot: served from pre-saved PNG — no re-evaluation
            div(class = "plot-wrap",
              imageOutput(paste0("plt_out", i), width = "100%", height = "400px")
            )
          ),

          div(class = "nav-row",
            if (i > 1)
              actionButton(paste0("btn_prev", i), "Previous",
                           class = "btn btn-secondary",
                           icon  = icon("arrow-left")),
            div(class = "spacer"),
            actionButton(paste0("btn_next", i),
                         if (i == N) "Review & Submit" else "Next",
                         class = "btn btn-primary",
                         icon  = if (i == N) icon("check") else icon("arrow-right"))
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
    ip         = "unknown",
    codes      = vector("list", N),
    outputs    = vector("list", N),
    plot_files = vector("list", N),   # paths to PNG files saved by run_code()
    ran        = logical(N),
    errored    = logical(N)
  )

  observe({ rv$ip <- get_ip(session) })

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
      rv$codes[[i]]      <- code
      rv$outputs[[i]]    <- res$text
      rv$plot_files[[i]] <- res$plot_file   # store PNG path (or NULL)
      rv$ran[i]          <- TRUE
      rv$errored[i]      <- res$error
    })

    # Text output
    output[[paste0("txt_out", i)]] <- renderText({
      if (!isTRUE(rv$ran[i]))
        return("[ Output appears here after running your code ]")
      out <- rv$outputs[[i]]
      if (is.null(out) || !nzchar(out)) "(no text output)" else out
    })

    # Plot output — serve the PNG already saved by run_code()
    # renderImage does NOT re-run the student's code.
    output[[paste0("plt_out", i)]] <- renderImage({
      pf <- rv$plot_files[[i]]
      if (isTRUE(rv$ran[i]) && !is.null(pf) && file.exists(pf)) {
        list(src = pf, contentType = "image/png",
             style = "max-width:100%; height:auto; display:block;")
      } else {
        # Transparent 1×1 placeholder so renderImage never errors
        blank <- file.path(tempdir(), "blank.png")
        if (!file.exists(blank)) {
          grDevices::png(blank, width = 1, height = 1)
          grDevices::dev.off()
        }
        list(src = blank, contentType = "image/png",
             style = "display:none;")
      }
    }, deleteFile = FALSE)

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
      if (isTRUE(rv$errored[i])) {
        showNotification(
          sprintf("Question %d has an error. Please fix your code before proceeding.", i),
          type = "error", duration = 4)
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

  observeEvent(input$btn_back_review, { go(paste0("pg-q", N)) })

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

# rsconnect::deployApp("/Users/oliverliou/pCloud Drive/!-git/teach/stat/quiz/")
