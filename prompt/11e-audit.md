# 投影片對照 Bluman 11e 的檢視與修正紀錄

- 舊稿依據：Bluman, A. G. (2012). *Elementary Statistics: A Step by Step Approach* (8th ed.). McGraw-Hill
- 新依據：Bluman, A. G. (2023). *Elementary Statistics: A Step by Step Approach* (11th ed.). McGraw Hill（ISE，ISBN 978-1-265-24812-3）
- 檢視日期：2026-09-19
- 範圍：ch1–ch14，英文版與中文版共 28 個 `.qmd`

檢視項目：(1) 節次結構與編號；(2) 11e 新增／刪除的內容；(3) 例題、數據、表格逐一核對；(4) 定義、公式、用語逐字核對。

## 一、節次結構改變的章

| 章 | 舊稿 | 11e | 處理 |
|---|---|---|---|
| 1 | 六節（1-4 觀察／實驗研究、1-5 統計的誤用、1-6 電腦與軟體） | 五節：1-4 **Experimental Design**（含觀察／實驗研究與統計的使用與誤用）、1-5 **Computers and Calculators** | 合併 1-4／1-5，全章重新編號 |
| 7 | 四節（從「σ 已知的平均數信賴區間」開始） | 五節，新增 **7-1 Confidence Intervals**（估計、點估計、區間估計、信賴水準、誤差界限） | 新增 7-1，其餘 7-2～7-5 重新編號 |
| 9 | 五節 | 六節，新增 **9-1 Testing the Difference Between Two Parameters** | 新增 9-1，其餘重新編號 |
| 14 | 三節 | 四節，新增 **14-4 Big Data** | 新增整節 |
| 2、3、4、5、6、8、10、11、12、13 | — | 節次編號與標題與 11e 相同 | 僅修正節標題文字與子節 |

## 二、11e 新增而舊稿完全沒有的內容

| 章 | 補上的內容 |
|---|---|
| 1 | census、biased sample、sampling error／nonsampling error、volunteer（self-selected）sample、cross-sectional／retrospective／longitudinal study、quasi-experimental study、blinding／double blinding、blocking、completely randomized design、matched-pair design、replication、統計研究七步驟、Hawthorne effect |
| 2 | **Dotplots**（11e 目標 3 明列）、J 型與反 J 型分配、開放組距分配、分組次數分配與直方圖／折線圖／肩形圖的 Procedure Table、複合長條圖與複合時間序列圖、Pareto 圖繪製建議 |
| 3 | **Linear Transformation of Data**（11e 前言明列的新增）、statistic／parameter 定義、四則四捨五入規則、分配形狀、deciles 的定義與換算、resistant statistics、Table 3-3 TOEFL、modified boxplot |
| 4 | Permutation Rule 2（含重複元素）、subjective probability、probability and risk taking、tree diagram、simple／compound event、機率四規則的 11e 版本 |
| 5 | **用組合公式解二項式問題**（11e 前言明列的新增）、**幾何分配**（整個主題）、multinomial／Poisson／hypergeometric／geometric 的實驗要件、Procedure Table、Table 5-1 五種分配彙整 |
| 6 | 常態分配八項性質（舊稿五項）、常態與標準常態的方程式、四張 Procedure Table、**Determining Normality**（Pearson 偏態指數、離群值、常態分位圖）、**Finite Population Correction Factor**、Table 6-1／6-2 |
| 7 | 整個 7-1、四組 assumptions、四則 rounding rule、樣本數公式推導、$\hat p\hat q$ 在 0.5 最大、Table A-5／A-6 查表規則 |
| 8 | Table 8-1 假設常用語（20 句）、三種檢定方法、jury-trial 類比、Figure 8-9 臨界值彙整、兩張 Procedure Table、結果摘要表、P 值判讀準則、power 與 $\beta$ 的完整說明 |
| 9 | 整個 9-1、四組 assumptions、兩套步驟表、合併變異數 t 檢定、加權估計 $\bar p$ 的推導、F 檢定四項使用注意 |
| 10 | **Residual Plots**、**Adjusted $R^2$**、六張 Procedure Table、相關係數五項性質、顯著相關的五種可能解釋、marginal change、outliers／influential points、coefficient of nondetermination、複迴歸五項假設 |
| 11 | 卡方分配四項特性、期望次數兩規則、獨立性檢定與同質性檢定的假設對照、Procedure Table ×2、Yates 校正 |
| 12 | **Bonferroni 檢定**（整個主題）、單因子第四項假設、ANOVA 摘要表 Table 12-1／12-5、交互作用判讀規則、Figure 12-4／12-5 |
| 13 | 六項優點（舊稿只有五項）、六張 Procedure Table、七組 assumptions、右尾符號檢定、runs test 的大樣本 $z$ 公式、Example 13-11 |
| 14 | **整節 14-4 Big Data**（3V+變異性、結構化／非結構化、來源、儲存與分析、MapReduce／Hadoop、UPS ORION、六大應用領域）、Procedure Table: Conducting a Sample Survey、五種問卷題目錯誤、11e 的四種偏誤用語 |

## 三、例題與數據（第一輪；已被下方第二輪取代）

舊稿有大量自編或 8e 版本的例題。修正後**每一個編號例題都對應 11e 的真實例題**（編號、標題、數據、答案一致）；沒有課本對應的 R 示範一律改為不編號的 `## … in R` 投影片，避免佔用例題編號。

| 章 | 例題數 | 置換情形 |
|---|---|---|
| 1 | 6 | Ex 1-1～1-6 全面改為 11e 版本；原 R 模擬改為不編號 |
| 2 | 16 | 2-1 血型→Breakfast Beverages 等，共置換 9 題並新增 dotplot 例 |
| 3 | 38 | 舊稿 39 題資料全為自編，全數改為 11e 的 3-1～3-38 |
| 4 | 54 | 54 題中 29 題數據與 11e 不符，已更正；併在同一張的例題拆開並補 anchor |
| 5 | 35 | 自 5-15 起全面位移（11e 插入「是否為二項實驗」一題），並新增 5-34／5-35 幾何分配 |
| 6 | 19 | 19 題中 15 題置換；新增常態性判定的兩題實資料例 |
| 7 | 15 | 15 題中 10 題置換 |
| 8 | 31 | 多題置換；原本擠在同一張的 8-8～8-11、8-14／8-15、8-21～8-23、8-27／8-28 全部拆開 |
| 9 | 16 | 6 題置換；Ex 9-6 舊稿結論與 11e 相反（舊稿 reject，11e do not reject），已更正 |
| 10 | 17 | 8 題置換；F 檢定自由度由 d.f.N.$=k$ 更正為 11e 的 $n-k$ |
| 11 | 7 | 3 題置換；原 11-1 汽水口味其實是課本的 Technology 節，改為不編號 R 示範 |
| 12 | 6 | 5 題置換，並新增 Example 12-5（Bonferroni） |
| 13 | 11 | 5 題置換，新增 Example 13-11 |
| 14 | 8 | 6 題置換（原稿多為自編） |

## 四、定義與用語的逐字更正（舉例）

- ch1：quantitative variables 由 8e 的「numerical and can be ordered or ranked」改為 11e 的「**can be counted or measured**」；sample 由「subgroup … selected to represent it」改為「**a group of subjects selected from a population**」。
- ch2：frequency distribution 改為「**the organization of raw data in table form, using classes and frequencies**」；histogram 強調 **contiguous vertical bars**；Pareto chart 刪去 11e 沒有的 80/20 說法。
- ch8：全書 **test value → test statistic**；$H_0$ 由「含 =、≤、≥」改為 11e 的「**一律以等號書寫**」；P 值定義補上「**in the direction of the alternative hypothesis**」。
- ch9：independent／dependent samples 改用 11e 的措辭；t 檢定自由度寫為「$n_1-1$ 與 $n_2-1$ **較小者**」。
- ch13：run 的定義改為 11e 的「a succession of identical letters preceded or followed by a different letter or no letter at all」。
- 附錄表代號全面更新：8e 的 Table D／E／F／G／I／J／K／L／M／N → 11e 的 **Table A-1～A-13**。

## 五、課本本身的疑似誤植（第一輪紀錄；第二輪例題改為自編後已不適用，相關 Caution 投影片已刪除）

| 位置 | 情形 | 處理 |
|---|---|---|
| Ex 1-1(d) | 解答寫 1300 children，題目是 1350 | 採 1350 |
| Ex 5-25 | 多項式係數印為 3360、答案 0.06；實為 1680、0.0302 | 印正確值，另加 `## Caution` 說明課本印錯 |
| Ex 5-24 | 文字說「變異數 277.5」，計算為 227.5 | 全用 227.5 |
| Ex 8-10 | 解答文字說查 d.f.=18，題目是 14，答案 ±2.977 是 d.f.=14 | 採 d.f.=14 |
| Ex 9-10 | 算出 0.0089 後寫成 0.0899 | 採 0.0089 |
| Ex 10-8 | 題目寫 $\alpha=0.01$，解答用 $\alpha=0.05$ 的臨界值 ±0.754 | 照書呈現，並讓 R 推導 0.754 |
| Ex 12-2 | 文字說抽 5 棟，資料與計算是 6 棟 | 寫 6 棟 |
| Ex 13-6 | 第 4 步印 24.025、P=0.00006，與自身公式（9.654）及 MINITAB（0.0081）矛盾 | 採 9.654，另加 Caution |
| Ex 13-11 | $\sigma_G$ 代入式寫成 $(21+24)$，分母數字是 $(20+25)$ 的 | 採正確代入 |

另有多處課本先四捨五入再計算，導致與 R 精確值差在小數最後一位（如 Ex 6-6 0.7486／0.7475、Ex 7-10 0.570／0.5695、Ex 9-2 z=1.06／0.94、Ex 11-5 30.698／30.696）。一律以**課本值為答案**，並在投影片上註明 R 的精確值與差異原因。

## 六、檢查結果

28 個檔案全部通過：

1. Callout 平衡檢查（本資料夾 `slide-format.Rmd` 第 12 節的檢查程式）— 0 issues。
2. 中英結構對齊 — 標題層級序列、`{#example-…}` anchor、R chunk label 完全一致；無重複 label／anchor；無失效的例題交互連結。
3. 正文無 Unicode 數學符號。
4. `quarto render` 全部成功（28 個 deck），無 KaTeX 錯誤，中英版投影片張數相同。

## 七、尚待手動處理

- `sylla/stat1.Rmd`、`sylla/stat2.Rmd` 已改為 11e，需重新 knit 產生 PDF。
- 課程進度維持 Statistics (1) = Ch 1–7、Statistics (2) = Ch 8–12（未受 11e 節次變動影響，syllabus 只列章不列節）。
- 各章 `chX.html` 已於第二輪在雲端重新 render 並寫回（見下）。

---

# 第二輪：例題全面自編與 R 解答 Clean Code 化（2026-09-20）

第一輪把每個例題都對齊課本的真實例題（編號、標題、數據、答案一致）。為避免抄襲疑慮，第二輪把**例題內容全部改成自編**。

## 一、原則

- **保留**：例題編號與位置、每題的教學點與統計結構（方法、小題數、單雙尾、reject／do not reject 的結論、相近的樣本數與難度）、例題之間的互相引用。
- **改寫**：標題、情境、所有數字、人名地名與資料來源行。情境改為國際商管／台灣在地題材（電商訂單、超商來客、外送配送時間、旅館住房率、捷運運量、港口貨櫃、工廠良率、客服來電、夜市攤位等）；機率與抽樣這類本來就中性的題材維持通用情境（骰子、抽牌、抽樣）。
- **不偽造來源**：自編資料一律標示 *(hypothetical data)*／*（模擬資料）*，不掛任何真實機構名稱。全書 `Source:` 行已全數清除。
- **課本值與 R 值的落差消失**：資料既然是自己的，答案就是 R 算出來的值。第一輪為了對齊課本而保留的「課本印 X、R 算出 Y」Caution 投影片與刻意先四捨五入再計算的程式，全部刪除。

## 二、非例題區塊的殘留課本資料也一併換掉

| 章 | 原本 | 改成 |
|---|---|---|
| 1 | 維吉尼亞理工學院仰臥起坐實驗 | 超商結帳話術的四週實驗（40 家門市） |
| 1 | 休士頓退伍軍人醫院膝痛模擬手術 | 旅館「新助眠方案」的三組實驗 |
| 1 | 奶油 vs. 乳瑪琳的 1960／1980／1998 研究 | 兩份對自助結帳結論相反的研究，差別在於比較的對象不同 |
| 1 | 吸菸與健康報告的 Hammond-Horn 研究細節（187,783 人、45 個月） | 只保留「找到關係、不等於因果」的要點，刪去借來的研究細節 |
| 2 | Nielsen 的美國成人看電視時數複合長條圖 | 三種零售業態的平日／週末平均來客數 |
| 2 | NHTSA 的油耗「拉長尺度」表 | 物流中心每位快遞員每小時配送件數 2019–2024 |
| 2 | 課本圖 2-13 美國高齡勞參率複合時間序列 | 航空公司短程／長程航線的載客率 2018–2024 |
| 2 | 超級盃廣告費 4.2 萬→560 萬美元的二維圖示 | 物流公司每日包裹量 20,000→60,000 件 |
| 3 | 表 3-3 TOEFL 百分等級（ETS，1,178,193 名應試者） | 表 3-3 商學院英語分級測驗百分等級（自編） |
| 10 | 1979 年預測美國 2003 年石油耗盡、汽油每加侖 10 美元 | 用 8–18 坪門市配適的迴歸線去預測 60 坪旗艦店的外推風險 |
| 14 | 槍枝登記問卷用字差異的 91/7 與 33/61 | 塑膠袋政策的兩種問法，78/18 對 34/59 |
| 14 | 14-4 Big Data 的 20/80 拆分、UPS ORION 的 8,500 萬加侖／哩、具名廠商與 MapReduce/Hadoop | 以自己的話說明概念，改用自編的「配送車隊路線規劃」說明，不引用任何公司的數字 |

保留的真實名稱只有術語本身的由來：Hawthorne effect（1924 年西方電器霍桑廠）、Pareto、Tukey 的 *Exploratory Data Analysis*、Von Neumann 與 Ulam。

## 三、R 解答依 Clean Code 重寫

| 類型 | 做法 |
|---|---|
| 命名 | 一律 snake_case 且有意義：`sample_mean`、`critical_value`、`daily_orders`，不再有 `m`、`cv`、`x1`、`tmp` |
| 單一職責 | 一個 chunk 只做一件事，準備資料／計算／輸出分開，長度盡量不超過 15 行 |
| 不造輪子 | 改用 `sd`、`var`、`quantile`、`IQR`、`pnorm`、`qt`、`lm`、`aov`、`chisq.test`、`kruskal.test`、`wilcox.test`、`dbinom`、`dhyper`、`dgeom`；只有投影片本身在教手算公式時，才留一個短而有名字的輔助函式，並在同一張投影片用內建函式驗證 |
| 去迴圈 | `for`／`repeat`／`replicate` 能向量化的全部改寫，例如 ch14 的「擲到第一次出現 6」從 `repeat` 迴圈改成 `rgeom()`；ch5 的二項分配圖從 `do.call(rbind, lapply(...))` 改成具名函式加 `bind_rows()` |
| 去 `cat()` | 全書不再用 `cat()` 拼字串輸出數學式或結論；直接印值或用 `knitr::kable(df, align = "c")`，文字結論寫在投影片散文裡 |
| 註解 | 只解釋「為什麼」，「做什麼」的註解全刪 |
| 不重複 | 同一份資料後面例題要再用就沿用前面 chunk 的物件；ch4 的 52 張牌原本被重打四次，現在只建立一次 |
| 留得更乾淨 | 刪掉沒用到的變數與只為湊輸出而存在的中間物件；ch3、ch6 手刻的分位數函式改用 `quantile()` 後刪除 |

## 四、render 與交付

- 在雲端以 **Quarto 1.9.38（與本機同版）+ R 4.3 + tidyverse**、`zh_TW.UTF-8` locale、Noto Sans CJK TC 字型 render 全部 28 個 deck，全部成功、零 chunk 錯誤、零 KaTeX 錯誤，中英版投影片張數完全相同。
- `chX.html`、`chX-zh.html` 與 144 個 `chX_files/figure-revealjs/*.png` 已寫回各章資料夾。`libs/` 未更動（與本機既有版本 checksum 相同）。
- 清掉 162 個已無人引用的舊圖檔（含 `unnamed-chunk-*.png` 等更早留下的孤兒檔）。

## 五、四項檢查（28 個檔案全數通過）

1. Callout 平衡 — 0 issues。
2. 中英結構對齊 — 標題層級序列、anchor、chunk label 完全一致，無重複、無失效連結。
3. 正文無 Unicode 數學符號。
4. render 成功，且投影片上寫的每個答案都等於該 chunk 實際印出的值。

---

# 第三輪：版面溢出修正（2026-09-20）

使用者回報有投影片內容卡到下緣被切掉（ch1「How Are Data Collected?」的調查方式表格，最後一列的 "possible" 被裁掉）。

## 一、量測方法

投影片版面固定 1050×700 px，且 `scrollable: false`，超出的部分會被**直接裁掉**而不是出現捲軸。用 headless Chromium 逐張量測：以 `Reveal.slide()` 切到每一張，比較該張投影片內所有子元素的最低 `getBoundingClientRect().bottom` 與投影片本身的下緣，差值除以 `Reveal.getScale()` 得到實際超出的像素。

量測時有一個陷阱：投影片的 KaTeX 是從 CDN 載入的，離線的瀏覽器不會把 `$$...$$` 轉成公式，於是量到的是原始碼字串的高度，而不是排版後公式的高度。第一次量測就踩到這個坑，修完之後在本機把 KaTeX 換成離線版重量一次，又找出 16 張因為公式排版後變高而溢出的投影片。

## 二、修正結果

| 輪次 | 條件 | 溢出張數 |
|---|---|---|
| 初次量測 | 公式未排版 | 80 |
| 第一次修正後 | 公式未排版 | 0 |
| 改用離線 KaTeX 重量 | 公式已排版 | 16 |
| 第二次修正後 | 公式已排版 | **0**（全書 2,952 張） |

主要成因與處理方式：

- **Overview 的 Section／Topics 表**（ch4、ch7、ch8、ch9、ch10、ch13、ch14，最嚴重 ch9 超出 540 px）：Topics 欄原本寫成完整句子。改成關鍵詞片語；ch7、ch8、ch9、ch13 因為一列即使只有一行也要 85 px，六列表格放不下，額外拆成「Overview」與「Overview (continued)」兩張。
- **過長的表格**（ch1 的測量尺度表與調查方式表、ch3 的表 3-3、ch4 的撲克牌機率表、ch2 的圖形彙整表）：精簡儲存格文字或拆成兩、三張。
- **Key Takeaways 條目太多**（ch10、ch12、ch13、ch14、ch6）：拆成兩張，標題相同。
- **例題的題目敘述或解題內容太滿**：依既有的 `---` 慣例拆頁，或把圖的 `out.width` 調小（ch6 的常態曲線圖 70%→55%，ch4 的樹狀圖 80%→68%）。
- **公式排版後變高**（ch3、ch6、ch7、ch13）：把兩個短公式用 `\qquad` 排成一行，或把其中一個移到下一張。

修正過程只動版面：沒有更動任何數字、答案、資料、定義、公式、節次結構或例題編號，也沒有加 `scrollable: true`、自訂 CSS 或縮小字級。中英版同步拆頁，張數仍完全一致。

## 三、順手修掉的兩個問題

- ch4 有 26 處數學式以 `$_nC_r$` 這種裸下標開頭，KaTeX 會報錯並直接印出原始碼。全部改成 `${}_nC_r$`。
- `ch5-zh.qmd` 檔尾有 102 個 NUL 位元組，已清除。

## 四、最終狀態

- 全書 28 個 deck、2,952 張投影片：**0 張溢出、0 處未排版的 LaTeX**，中英版每章張數相同。
- Callout 平衡、中英結構對齊、無 Unicode 數學符號：28 個檔案全數通過。
- `chX.html` 與 144 個圖檔已重新 render 並寫回各章資料夾；清掉 166 個已無人引用的舊圖檔。
- 投影片格式規範 `slide-format.Rmd` 的驗收清單新增「版面不得溢出」與「LaTeX 不得落在 `$...$` 之外」兩節。

## 五、一個仍待決定的事項

投影片的 KaTeX 是從 `cdn.jsdelivr.net` 載入的（Quarto 的預設）。若在沒有網路的教室放映，數學式會顯示成 `\alpha` 這樣的原始碼。若要避免，可在 YAML 改成指向本機的 KaTeX 複本。目前維持原狀。

---

# 第四輪：字型基準錯誤導致的漏網溢出（2026-09-20）

## 一、問題

第三輪回報「全書 2,952 張零溢出」之後，使用者實際放映 ch1 仍看到兩張卡到邊：
「How Are Data Collected?」與「Table 1-2: Examples of Measurement Scales」。

原因是**量測用的字型不對**。Reveal 的 `serif` 佈景要的是
`"Palatino Linotype", "Book Antiqua", Palatino, FreeSerif, serif`；macOS 有
Palatino，Linux 容器沒有，於是退回 DejaVu Serif。DejaVu 比 Palatino窄，同一段
文字少換一行，容器量到「剛好不溢出」的版面，在使用者的 Mac 上就多一行而被裁掉。

裝上 `fonts-urw-base35`（提供 **P052**＝URW Palladio，與 Palatino metric 相容）
並在 fontconfig 把 Palatino / Palatino Linotype / Book Antiqua / serif 都 alias
到它之後重新截圖，容器的畫面與使用者的截圖逐字吻合，確認診斷無誤。

同時修正量測方法本身的三個缺陷：

1. **沒有算 footer 淨空**。內容只要壓到頁尾那行字就算卡到，所以下限改成
   `min(投影片框下緣, footer 上緣)`。
2. **拿 `section` 自己的邊界當框**。`center: true` 時 section 會縮到內容大小，
   拿子元素跟它比永遠是 0。改成跟 `.slides` 容器的 `top + 700 × scale` 比。
3. **把隱藏元素算進去**。KaTeX 的 `.katex-mathml`（無障礙用的隱藏副本）與
   KaTeX 的 SVG `<path>`（伸縮符號的幾何寬達數千 px，由父層裁切）都要排除，
   否則右緣會量出 +8000 px 這種假警報。

## 二、結果

以 Palatino 字型基準重量，門檻設為「餘裕至少 7 px」：

| 狀態 | 真正被裁切（overV > 0） | 餘裕不足 7 px |
|---|---|---|
| 修正前 | 25 張 | 50 張 |
| 修正後 | **0** | **0** |

全書 28 個 deck、**2,970 張**投影片（因拆頁較第三輪多 18 張），最緊的一張仍有
8 px 餘裕。無任何未排版的 LaTeX。

各章修法（僅列被修的章）：

- **ch1**：表 1-2 標題縮短（原本折成兩行，H2 就吃掉 154 px）；「How Are Data
  Collected?」併段並精簡電話訪問列；「Uses and Misuses」末句精簡。
- **ch2**：兩張圖的 `out.width` 調小（52%→44%、46%→40%）；形狀彙整表的括號同義詞縮寫。
- **ch3**：表 3-4 的 Definition 欄精簡，讓四列各佔一行（列數不變）。
- **ch4**：Overview 的 Topics 改關鍵詞；三事件加法公式改 `\begin{aligned}` 折三行；
  Key Formulas 的分母文字縮短（右緣 +91 → 0）。
- **ch5**：Overview 表改欄寬比例；表 5-1 拆成彙整表＋公式續頁（右緣 +102 → 0）。
- **ch6**：Overview 精簡；`np≥5`／`nq≥5` 那張把圖拆到續頁；範例 6-11、6-12 在
  Step 2／Step 3 之間拆頁。
- **ch7**：`z` 或 `t` 對照表的 Situation 欄併行；`t` 分配與卡方分配導言精簡。
- **ch8**：Key Takeaways 九條拆成兩張。
- **ch9**：9-3 節標題縮短為「Testing the Difference Between Two Means
  (Independent Samples)」；範例 9-6 的導言併入 callout 標題；F 分配導言精簡。
- **ch10**：Overview 拆成兩張。
- **ch11**：訂艙系統示範拆頁；付款資料表下方段落精簡。
- **ch12**：兩個變異數估計值拆頁；表 12-1 說明精簡；範例 12-2 步驟 4、5 併句。
- **ch13**：連串檢定拆成兩張；範例 13-6 的三個並排公式改成兩個 display 式
  （右緣 +14 → 0）；另七張精簡文字。

一樣只動版面：沒有更動任何數字、答案、資料、定義、公式、節次結構或例題編號，
沒有用 `scrollable: true`、自訂 CSS、縮小字級或 `{.smaller}`。所有拆頁中英同步，
每章中英張數相同、標題層級序列／anchor／chunk label 逐項對應。

圖檔檔名與內容均未變動（`out.width` 只影響 HTML 的顯示寬度，不影響 PNG），
因此只重新寫回 28 個 `.qmd` 與 28 個 `.html`。

## 三、規範更新

`slide-format.Rmd` 的「Layout」一節改寫，明確要求量測時必須同時滿足：
Palatino metric 字型、KaTeX 真的有排版、footer 淨空；並註明要排除
`.katex-mathml` 與 SVG 元素、要跟 `.slides` 容器而非 `section` 比較。

---

# 第五輪：R 程式碼極簡化（2026-10-08）

使用者指出投影片上的 R code 太複雜（例如 ch2 的肩形圖與莖葉圖）：這是教學用投影片，code 務必要非常簡單，只要結果對就好。第二輪依 Clean Code 寫成的具名輔助函式、`kable` 表格、pipe 鏈與大量繪圖修飾，全部改寫。

## 一、原則

- 投影片在教公式時，就把題目數字直接代入公式寫一次，例如 `(122.5 - 118) / (12 / sqrt(35))`；變數只在數值會重複使用時才建立，名稱用 `z`、`t_stat`、`chi_sq`、`p_hat`、`x_bar`、`se` 這類短而直白的名字。
- 計算一律用 base R（`table`、`cut`、`cumsum`、`mean`、`sd`、`quantile`、`pnorm`／`qnorm`、`dbinom`、`chisq.test`、`aov`、`lm` 等），每個結果各印一行。
- 全面移除：自訂函式、apply／`do.call`、迴圈、pipe、`tibble`／`mutate` 鏈、`knitr::kable`、`paste`／`sprintf`／`cat`、把數值包成具名向量再輸出、`round()`（四捨五入後的答案寫在投影片文字裡）。
- 右尾面積一律寫 `1 - pnorm(z)`、`1 - pt(...)`、`1 - pchisq(...)`、`1 - pf(...)`，不用 `lower.tail = FALSE`；正文提到 `lower.tail` 的 R 寫法也一併改掉。
- 圖：最基本的 ggplot2（`ggplot() + geom_xxx() + labs()`），不設顏色、粗細、`scale_*`、`theme()`；只保留本身就是教學重點的元素（截斷縱軸、參考線、常態曲線下的陰影）。`theme_set(theme_minimal())` 只寫在隱藏的 setup chunk。base 繪圖只用在 `pie()`、`stem()`、`stripchart()`、`plot(TukeyHSD())`。
- 只是列出參考表、沒有任何計算的 chunk 改成 Markdown 表格。
- 數字、答案、例題編號、定義與正文意思都不變；新程式印出的每個數值都與舊輸出相同（差別只在不再四捨五入）。模擬題保留相同的 `set.seed()` 與亂數呼叫順序，模擬結果完全不變。

## 二、使用者點名的兩處

- **肩形圖（Example 2-6）**：原本是 `delivery_freq$Cumulative` 加兩條 `geom_segment()` 虛線與自訂顏色；改為 `cumsum(c(0, 3, 9, 16, 12, 6, 3, 1))` 建資料框，再 `geom_line() + geom_point() + labs()`。
- **莖葉圖（Example 2-14～2-16）**：原本是自訂函式 `leaves_by_stem()`（`vapply` + `paste`）加 `kable`；改為直接 `stem(evening_customers, scale = 2)`、`stem(pallets)`、`stem(taipei)` 與 `stem(taichung)`。背對背莖葉圖由兩個 `stem()` 的結果手排成 Markdown 表格。

## 三、結果

| 項目 | 修改前 | 修改後 |
|---|---|---|
| 可見 R 程式碼（英文版，非空白行） | 2,461 行 | 1,734 行 |
| 自訂函式／pipe／`kable`／`round()` | 散見各章 | 0 |
| 投影片總數（中英合計） | 2,970 張 | 2,954 張 |

各章投影片增減（中英同步）：ch1 75→74、ch2 109→106、ch3 156→155、ch4 160→157、ch6 109→111、ch7 89→88、ch9 94→96、ch10 117→114，其餘各章不變。減少的多是原本只負責「印出 `kable` 表格」或「把畫好的圖物件印出來」的投影片；增加的是 ch6 圖 6-1 的四個子圖改為一張一圖、兩張常態分位圖分開放，以及 ch9 例題 9-9 與 9-10 改成一值一行後拆頁。

其他值得一提的改動：

- **ch4 例題 4-4 樹狀圖**：畫樹狀圖不是本課要教的 R 技能，繪圖程式改為隱藏（`echo=FALSE`），解題頁只留圖與樣本空間，兩張解題頁併為一張。
- **ch10 例題 10-8**：拿掉由 $t$ 臨界值反推 $r$ 臨界值的公式（投影片未教），只留 `cor.test()`；臨界值 0.754 由正文的 Table A-8 給出。
- **ch13 連串檢定**：自訂的 `count_runs()` 改為 `length(rle(x)$lengths)`，三處正文提到 `count_runs()` 的地方同步改寫。
- **ch6 Key R Functions**：右尾面積只列 `1 - pnorm(z)`。

## 四、檢查（28 個 deck 全數通過）

1. render 成功、無警告；中英版每章投影片張數相同，標題層級、anchor、chunk label 逐一對應，例題交互連結無失效。
2. 中英版程式碼除了翻譯過的圖表文字與註解外完全相同。
3. 每個改過的 chunk 都逐一比對新舊輸出，數值一致；正文數字與輸出相符。
4. Callout 平衡、正文無 Unicode 數學符號。
5. 版面以 Palatino metric 字型與離線 KaTeX 量測：2,954 張全部至少 7 px 餘裕，沒有程式碼區塊需要水平捲軸。

## 五、交付

- 28 個 `.qmd`、28 個 `.html` 與 158 張圖寫回各章資料夾；刪除 14 張已無人引用的舊圖；`libs/` 未更動。
- 中文版的圖：本次 render 環境的 knitr（1.45）不會自動對圖檔啟用 showtext，圖內中文字會變得很小；只在 render 用的暫存複本加上 `knitr::opts_chunk$set(fig.showtext = TRUE)`，原始檔不變，輸出的中文字大小與先前版本相同。
- `prompt/slide-format.Rmd` 的「R style」、「R Code Standards」、假設檢定範例與驗收清單改為上述原則，避免日後再寫出複雜的程式。
