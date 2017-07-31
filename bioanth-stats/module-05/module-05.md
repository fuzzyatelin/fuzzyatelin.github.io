Module 05
================

Getting Data into ***R***
=========================

Objectives
----------

> The objective of this module to learn how to download data sets from various local and online sources.

Preliminaries
-------------

-   GO TO: <https://github.com/difiore/ADA2016>, select the `.txt` version of *Country-Data-2016*, then press the `RAW` button, highlight, and copy the text to a text editor and save it locally. Do the same for the `.csv` version.

This data set consists of basic statistics (area, current population size, birth rate, death rate, life expectancy, and form of government) for 249 countries taken from [WorldData.info](https://www.worlddata.info) that I have combined with data from the International Union for the Conservation of Nature (IUCN)'s [Red List Summary Statistics](http://www.iucnredlist.org/about/summary-statistics) about the number of threatened animal species by country.

-   From the same page, select the `.xlsx` version of **CPDS-1960-2014-reduced**, then press `DOWNLOAD` and save it locally. Also download these data in `.txt` and `.csv` formats using the procedure described above.

This is a version of the *Comparative Political Data Set (CPDS)*, which is "a collection of political and institutional country-level data provided by Prof. Dr. Klaus Armingeon and collaborators at the University of Berne. It consists of annual data for 36 democratic countries for the period of 1960 to 2014 or since their transition to democracy" (Armingeon et al. 2016). The full dataset consists of 300 variables, which I have pared down to a smaller set of economical and population size variables.

> **CITATION:** Armingeon K, Isler C, Knöpfel L, Weisstanner D, and Engler S. 2016. Comparative Political Data Set 1960-2014. Bern: Institute of Political Science, University of Berne.

-   Install these packages in ***R***: {readr}, {curl}, {readxl}, {XLConnect}, {rdrop2}, {repmis}

The Backstory
-------------

So far, we have seen how to create a variety of data structures by hand (e.g., using the `c()` function), but for larger data sets we will need mechanisms to import data into ***R***. There are many methods for importing tabular data, stored in various formats (like text files, spreadsheets, and databases).

The Tao of Text
---------------

Plain text files are, arguably, the best way to store data (and scripts and other documents) as they are a standard format that has been around longer than most operating systems and are unlikely to change anytime soon.

-   Plain text does not have a version and does not age
-   Plain text files are platform and software agnostic
-   Plain text files can be opened by a wide variety of programs
-   Plain text can easily be copied and pasted into a wide range of software
-   Plain text files tend to be smaller and quicker to open then proprietary formats
-   Plain text files are easy to transmit over the web
-   Many mature and efficient software tools exist for indexing, parsing, searching, and modifying text
-   The content of plain text files looks the same on any system
-   Various flavors of **Markdown** can be used for styling plain text files, if needed
-   Plain text remains itself outside of the digital context

Loading Different Types of Plain Text Files
-------------------------------------------

In ***R***, we can load a data set from a plain text file using the `read.table()` function from the {base} package, with the path to the file as the first (`file=`) argument for the function. An additional argument (`header=`) can be used to specify whether the first row of the data file consists of column/field names.

The generic `read.table()` function can be used to read data files where columns are separated by tabs, commas, white space, or some other delimeter. The `sep=` argument tells ***R*** what character is used as a delimiter. The `skip=` argument can be used to start reading a file after a set number of rows.

There are format-specific variants of `read.table()` (e.g., `read.csv()`) that have different defaults and may be quicker for certain file types. Note that when using this function from the {base} package, the argument `stringsAsFactors` is set to be TRUE by default, and we need to set it as FALSE if we want character strings to be loaded as actual strings.

Let's read in one of the data sets that you have copied and stored locally: **CPDS-1960-2014-reduced.txt**.

### Reading from a local file

The `file.choose()` command is useful and gives you a familiar dialog box to select a file. You can use this to specify the path to a locally-stored file.

``` r
f <- file.choose()
```

The file paths below refer to where I have saved the downloaded data, on my **Desktop**. You will need to change this if you have saved your downloaded data to a different location.

#### Loading tab-separated (`.tsv`, `.txt`) text with {base} ***R*** functions

**NOTE:** In the following snippet, you can change the `sep=` argument as needed to use other delimiters

``` r
f <- "~/Desktop/CPDS-1960-2014-reduced.txt"
d <- read.table(f, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
head(d)  # lists the first 6 lines of data
```

    ##   year   country gov_right1 gov_cent1 gov_left1 gov_party      elect vturn
    ## 1 1960 Australia        100         0         0         1             95.5
    ## 2 1961 Australia        100         0         0         1 09/12/1961  95.3
    ## 3 1962 Australia        100         0         0         1             95.3
    ## 4 1963 Australia        100         0         0         1 30/11/1963  95.7
    ## 5 1964 Australia        100         0         0         1             95.7
    ## 6 1965 Australia        100         0         0         1             95.7
    ##   womenpar realgdpgr inflation debt_hist deficit ttl_labf labfopar unemp
    ## 1        0        NA      3.73     40.15    0.46  4215.00       NA  1.25
    ## 2        0     -0.64      2.29     38.62   -0.36  4286.00       NA  2.46
    ## 3        0      5.77     -0.32     38.75   -0.79  4382.00       NA  2.32
    ## 4        0      6.01      0.64     37.34   -0.51  4484.00       NA  1.87
    ## 5        0      6.26      2.87     35.31   -0.08  4610.80    67.24  1.45
    ## 6        0      4.99      3.41     53.99   -0.73  4745.95    67.66  1.36
    ##       pop pop15_64 pop65 elderly
    ## 1 10275.0   6296.5 874.9    8.51
    ## 2 10508.2   6428.6 894.6    8.51
    ## 3 10700.5   6571.5 913.6    8.54
    ## 4 10906.9   6710.9 933.0    8.55
    ## 5 11121.6   6857.3 948.1    8.52
    ## 6 11340.9   7014.6 966.3    8.52

**NOTE:** With bracket notation, you can modify how many lines the `head()` function will return: e.g., `head(d)[1:10])`

``` r
tail(d)  # shows the last 6 lines of data
```

    ##      year country gov_right1 gov_cent1 gov_left1 gov_party      elect
    ## 1573 2009     USA      16.36     83.64         0         1           
    ## 1574 2010     USA      11.76     88.24         0         1 02/11/2010
    ## 1575 2011     USA       8.80     91.20         0         1           
    ## 1576 2012     USA       5.88     94.12         0         1 06/11/2012
    ## 1577 2013     USA       5.88     94.12         0         1           
    ## 1578 2014     USA       8.40     91.60         0         1 04/11/2014
    ##      vturn womenpar realgdpgr inflation debt_hist deficit ttl_labf
    ## 1573  53.2     16.8     -2.78     -0.36     93.47  -12.83 155454.0
    ## 1574  39.8     16.8      2.53      1.64    102.66  -12.18 155220.3
    ## 1575  39.8     16.8      1.60      3.16    108.25  -10.75 154949.3
    ## 1576  50.9     18.0      2.22      2.07    111.48   -9.00 156368.6
    ## 1577  50.9     17.8      1.49      1.46    111.45   -5.49 156761.2
    ## 1578  35.6     19.3      2.43      1.62    111.70   -5.13 157268.8
    ##      labfopar unemp      pop pop15_64    pop65 elderly
    ## 1573    75.49   9.3 306771.5 206060.8 39623.18   12.92
    ## 1574    74.80   9.6 309347.1 207665.3 40479.35   13.09
    ## 1575    74.12   8.9 311721.6 209179.2 41366.63   13.27
    ## 1576    74.53   8.1 314112.1 209823.0 43164.91   13.74
    ## 1577    74.41   7.4 316498.0 210673.5 44723.04   14.13
    ## 1578       NA   6.2 318857.0 211545.9 46243.21   14.50

``` r
class(d)  # shows that tables are typically loaded as data frames
```

    ## [1] "data.frame"

Or, alternatively...

``` r
d <- read.delim(f, header = TRUE, stringsAsFactors = FALSE)
head(d)
```

    ##   year   country gov_right1 gov_cent1 gov_left1 gov_party      elect vturn
    ## 1 1960 Australia        100         0         0         1             95.5
    ## 2 1961 Australia        100         0         0         1 09/12/1961  95.3
    ## 3 1962 Australia        100         0         0         1             95.3
    ## 4 1963 Australia        100         0         0         1 30/11/1963  95.7
    ## 5 1964 Australia        100         0         0         1             95.7
    ## 6 1965 Australia        100         0         0         1             95.7
    ##   womenpar realgdpgr inflation debt_hist deficit ttl_labf labfopar unemp
    ## 1        0        NA      3.73     40.15    0.46  4215.00       NA  1.25
    ## 2        0     -0.64      2.29     38.62   -0.36  4286.00       NA  2.46
    ## 3        0      5.77     -0.32     38.75   -0.79  4382.00       NA  2.32
    ## 4        0      6.01      0.64     37.34   -0.51  4484.00       NA  1.87
    ## 5        0      6.26      2.87     35.31   -0.08  4610.80    67.24  1.45
    ## 6        0      4.99      3.41     53.99   -0.73  4745.95    67.66  1.36
    ##       pop pop15_64 pop65 elderly
    ## 1 10275.0   6296.5 874.9    8.51
    ## 2 10508.2   6428.6 894.6    8.51
    ## 3 10700.5   6571.5 913.6    8.54
    ## 4 10906.9   6710.9 933.0    8.55
    ## 5 11121.6   6857.3 948.1    8.52
    ## 6 11340.9   7014.6 966.3    8.52

#### Loading comma-separated (`.csv`) text with {base} ***R*** functions

``` r
f <- "~/Desktop/CPDS-1960-2014-reduced.csv"
d <- read.table(f, header = TRUE, sep = ",", stringsAsFactors = FALSE)
head(d)
```

    ##   year   country gov_right1 gov_cent1 gov_left1 gov_party      elect vturn
    ## 1 1960 Australia        100         0         0         1             95.5
    ## 2 1961 Australia        100         0         0         1 09/12/1961  95.3
    ## 3 1962 Australia        100         0         0         1             95.3
    ## 4 1963 Australia        100         0         0         1 30/11/1963  95.7
    ## 5 1964 Australia        100         0         0         1             95.7
    ## 6 1965 Australia        100         0         0         1             95.7
    ##   womenpar realgdpgr inflation debt_hist deficit ttl_labf labfopar unemp
    ## 1        0        NA      3.73     40.15    0.46  4215.00       NA  1.25
    ## 2        0     -0.64      2.29     38.62   -0.36  4286.00       NA  2.46
    ## 3        0      5.77     -0.32     38.75   -0.79  4382.00       NA  2.32
    ## 4        0      6.01      0.64     37.34   -0.51  4484.00       NA  1.87
    ## 5        0      6.26      2.87     35.31   -0.08  4610.80    67.24  1.45
    ## 6        0      4.99      3.41     53.99   -0.73  4745.95    67.66  1.36
    ##       pop pop15_64 pop65 elderly
    ## 1 10275.0   6296.5 874.9    8.51
    ## 2 10508.2   6428.6 894.6    8.51
    ## 3 10700.5   6571.5 913.6    8.54
    ## 4 10906.9   6710.9 933.0    8.55
    ## 5 11121.6   6857.3 948.1    8.52
    ## 6 11340.9   7014.6 966.3    8.52

Or, alternatively...

``` r
d <- read.csv(f, header = TRUE, stringsAsFactors = FALSE)
head(d)
```

    ##   year   country gov_right1 gov_cent1 gov_left1 gov_party      elect vturn
    ## 1 1960 Australia        100         0         0         1             95.5
    ## 2 1961 Australia        100         0         0         1 09/12/1961  95.3
    ## 3 1962 Australia        100         0         0         1             95.3
    ## 4 1963 Australia        100         0         0         1 30/11/1963  95.7
    ## 5 1964 Australia        100         0         0         1             95.7
    ## 6 1965 Australia        100         0         0         1             95.7
    ##   womenpar realgdpgr inflation debt_hist deficit ttl_labf labfopar unemp
    ## 1        0        NA      3.73     40.15    0.46  4215.00       NA  1.25
    ## 2        0     -0.64      2.29     38.62   -0.36  4286.00       NA  2.46
    ## 3        0      5.77     -0.32     38.75   -0.79  4382.00       NA  2.32
    ## 4        0      6.01      0.64     37.34   -0.51  4484.00       NA  1.87
    ## 5        0      6.26      2.87     35.31   -0.08  4610.80    67.24  1.45
    ## 6        0      4.99      3.41     53.99   -0.73  4745.95    67.66  1.36
    ##       pop pop15_64 pop65 elderly
    ## 1 10275.0   6296.5 874.9    8.51
    ## 2 10508.2   6428.6 894.6    8.51
    ## 3 10700.5   6571.5 913.6    8.54
    ## 4 10906.9   6710.9 933.0    8.55
    ## 5 11121.6   6857.3 948.1    8.52
    ## 6 11340.9   7014.6 966.3    8.52

#### Using the {readr} package

The {readr} package provides alternative functions to read in delimited text files. It runs faster than the {base} package functions. It reads in an initial set of 1000 rows of the from the table to try to impute the data class for of each column. You can also specify the data class of each column with the `col_types()` function.

``` r
require(readr)
```

    ## Loading required package: readr

``` r
f <- "~/Desktop/CPDS-1960-2014-reduced.txt"
d <- read_tsv(f, col_names = TRUE)  # for tab-separated files
```

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_double(),
    ##   year = col_integer(),
    ##   country = col_character(),
    ##   gov_party = col_integer(),
    ##   elect = col_character()
    ## )

    ## See spec(...) for full column specifications.

``` r
head(d)
```

    ## # A tibble: 6 × 20
    ##    year   country gov_right1 gov_cent1 gov_left1 gov_party      elect
    ##   <int>     <chr>      <dbl>     <dbl>     <dbl>     <int>      <chr>
    ## 1  1960 Australia        100         0         0         1       <NA>
    ## 2  1961 Australia        100         0         0         1 09/12/1961
    ## 3  1962 Australia        100         0         0         1       <NA>
    ## 4  1963 Australia        100         0         0         1 30/11/1963
    ## 5  1964 Australia        100         0         0         1       <NA>
    ## 6  1965 Australia        100         0         0         1       <NA>
    ## # ... with 13 more variables: vturn <dbl>, womenpar <dbl>,
    ## #   realgdpgr <dbl>, inflation <dbl>, debt_hist <dbl>, deficit <dbl>,
    ## #   ttl_labf <dbl>, labfopar <dbl>, unemp <dbl>, pop <dbl>,
    ## #   pop15_64 <dbl>, pop65 <dbl>, elderly <dbl>

``` r
class(d)
```

    ## [1] "tbl_df"     "tbl"        "data.frame"

``` r
# returns d as a data frame, but also as other table-based data structures
```

Or, alternatively...

``` r
d <- read_delim(f, delim = "\t", col_names = TRUE)
```

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_double(),
    ##   year = col_integer(),
    ##   country = col_character(),
    ##   gov_party = col_integer(),
    ##   elect = col_character()
    ## )

    ## See spec(...) for full column specifications.

``` r
head(d)
```

    ## # A tibble: 6 × 20
    ##    year   country gov_right1 gov_cent1 gov_left1 gov_party      elect
    ##   <int>     <chr>      <dbl>     <dbl>     <dbl>     <int>      <chr>
    ## 1  1960 Australia        100         0         0         1       <NA>
    ## 2  1961 Australia        100         0         0         1 09/12/1961
    ## 3  1962 Australia        100         0         0         1       <NA>
    ## 4  1963 Australia        100         0         0         1 30/11/1963
    ## 5  1964 Australia        100         0         0         1       <NA>
    ## 6  1965 Australia        100         0         0         1       <NA>
    ## # ... with 13 more variables: vturn <dbl>, womenpar <dbl>,
    ## #   realgdpgr <dbl>, inflation <dbl>, debt_hist <dbl>, deficit <dbl>,
    ## #   ttl_labf <dbl>, labfopar <dbl>, unemp <dbl>, pop <dbl>,
    ## #   pop15_64 <dbl>, pop65 <dbl>, elderly <dbl>

``` r
require(readr)
f <- "~/Desktop/CPDS-1960-2014-reduced.csv"
d <- read_csv(f, col_names = TRUE)  # for comma-separated files
```

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_double(),
    ##   year = col_integer(),
    ##   country = col_character(),
    ##   gov_party = col_integer(),
    ##   elect = col_character()
    ## )

    ## See spec(...) for full column specifications.

``` r
head(d)
```

    ## # A tibble: 6 × 20
    ##    year   country gov_right1 gov_cent1 gov_left1 gov_party      elect
    ##   <int>     <chr>      <dbl>     <dbl>     <dbl>     <int>      <chr>
    ## 1  1960 Australia        100         0         0         1       <NA>
    ## 2  1961 Australia        100         0         0         1 09/12/1961
    ## 3  1962 Australia        100         0         0         1       <NA>
    ## 4  1963 Australia        100         0         0         1 30/11/1963
    ## 5  1964 Australia        100         0         0         1       <NA>
    ## 6  1965 Australia        100         0         0         1       <NA>
    ## # ... with 13 more variables: vturn <dbl>, womenpar <dbl>,
    ## #   realgdpgr <dbl>, inflation <dbl>, debt_hist <dbl>, deficit <dbl>,
    ## #   ttl_labf <dbl>, labfopar <dbl>, unemp <dbl>, pop <dbl>,
    ## #   pop15_64 <dbl>, pop65 <dbl>, elderly <dbl>

Or, alternatively...

``` r
d <- read_delim(f, delim = ",", col_names = TRUE)
```

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_double(),
    ##   year = col_integer(),
    ##   country = col_character(),
    ##   gov_party = col_integer(),
    ##   elect = col_character()
    ## )

    ## See spec(...) for full column specifications.

``` r
head(d)
```

    ## # A tibble: 6 × 20
    ##    year   country gov_right1 gov_cent1 gov_left1 gov_party      elect
    ##   <int>     <chr>      <dbl>     <dbl>     <dbl>     <int>      <chr>
    ## 1  1960 Australia        100         0         0         1       <NA>
    ## 2  1961 Australia        100         0         0         1 09/12/1961
    ## 3  1962 Australia        100         0         0         1       <NA>
    ## 4  1963 Australia        100         0         0         1 30/11/1963
    ## 5  1964 Australia        100         0         0         1       <NA>
    ## 6  1965 Australia        100         0         0         1       <NA>
    ## # ... with 13 more variables: vturn <dbl>, womenpar <dbl>,
    ## #   realgdpgr <dbl>, inflation <dbl>, debt_hist <dbl>, deficit <dbl>,
    ## #   ttl_labf <dbl>, labfopar <dbl>, unemp <dbl>, pop <dbl>,
    ## #   pop15_64 <dbl>, pop65 <dbl>, elderly <dbl>

Loading ***Excel*** Files
-------------------------

While you should never need to use ***Excel***, sometimes you will no doubt be given a spreadsheet file with some data in it that you want to read in ***R***. There are several packages available that provide functions for loading data into ***R*** from ***Excel*** spreadsheet files: {readxl}, {XLConnect}, {gdata}, and {xlsx}. The first two of these are fast, easy to use, and work well. {gdata} is a bit slower and requires that you have PERL installed someone on your computer (which it is likely to be by default). {xlsx} is much slower.

**NOTE:** always use `str()` to check if your variables come in as the correct data class.

#### Using the {readxl} package

``` r
require(readxl)
```

    ## Loading required package: readxl

``` r
f <- "~/Desktop/CPDS-1960-2014-reduced.xlsx"
d <- read_excel(f, sheet = 1, col_names = TRUE)
head(d)
```

    ## # A tibble: 6 × 20
    ##    year   country gov_right1 gov_cent1 gov_left1 gov_party      elect
    ##   <dbl>     <chr>      <dbl>     <dbl>     <dbl>     <dbl>     <dttm>
    ## 1  1960 Australia        100         0         0         1       <NA>
    ## 2  1961 Australia        100         0         0         1 1961-12-09
    ## 3  1962 Australia        100         0         0         1       <NA>
    ## 4  1963 Australia        100         0         0         1 1963-11-30
    ## 5  1964 Australia        100         0         0         1       <NA>
    ## 6  1965 Australia        100         0         0         1       <NA>
    ##   vturn
    ##   <dbl>
    ## 1  95.5
    ## 2  95.3
    ## 3  95.3
    ## 4  95.7
    ## 5  95.7
    ## 6  95.7
    ## # ... with 12 more variables: womenpar <dbl>, realgdpgr <dbl>,
    ## #   inflation <dbl>, debt_hist <dbl>, deficit <dbl>, ttl_labf <dbl>,
    ## #   labfopar <dbl>, unemp <dbl>, pop <dbl>, pop15_64 <dbl>, pop65 <dbl>,
    ## #   elderly <dbl>

``` r
str(d)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    1578 obs. of  20 variables:
    ##  $ year      : num  1960 1961 1962 1963 1964 ...
    ##  $ country   : chr  "Australia" "Australia" "Australia" "Australia" ...
    ##  $ gov_right1: num  100 100 100 100 100 100 100 100 100 100 ...
    ##  $ gov_cent1 : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ gov_left1 : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ gov_party : num  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ elect     : POSIXct, format: NA "1961-12-09" ...
    ##  $ vturn     : num  95.5 95.3 95.3 95.7 95.7 95.7 95.1 95.1 95.1 95 ...
    ##  $ womenpar  : num  0 0 0 0 0 0 0.8 0.8 0.8 0 ...
    ##  $ realgdpgr : num  NA -0.643 5.767 6.009 6.258 ...
    ##  $ inflation : num  3.729 2.288 -0.319 0.641 2.866 ...
    ##  $ debt_hist : num  40.1 38.6 38.7 37.3 35.3 ...
    ##  $ deficit   : num  0.4582 -0.3576 -0.7938 -0.5062 -0.0804 ...
    ##  $ ttl_labf  : num  4215 4286 4382 4484 4611 ...
    ##  $ labfopar  : num  NA NA NA NA 67.2 ...
    ##  $ unemp     : num  1.25 2.46 2.32 1.87 1.45 ...
    ##  $ pop       : num  10275 10508 10700 10907 11122 ...
    ##  $ pop15_64  : num  6296 6429 6572 6711 6857 ...
    ##  $ pop65     : num  875 895 914 933 948 ...
    ##  $ elderly   : num  8.51 8.51 8.54 8.55 8.52 ...

#### Using the {XLConnect} package

``` r
require(XLConnect)
```

    ## Loading required package: XLConnect

    ## Loading required package: XLConnectJars

    ## XLConnect 0.2-12 by Mirai Solutions GmbH [aut],
    ##   Martin Studer [cre],
    ##   The Apache Software Foundation [ctb, cph] (Apache POI, Apache Commons
    ##     Codec),
    ##   Stephen Colebourne [ctb, cph] (Joda-Time Java library),
    ##   Graph Builder [ctb, cph] (Curvesapi Java library)

    ## http://www.mirai-solutions.com ,
    ## http://miraisolutions.wordpress.com

``` r
f <- "~/Desktop/CPDS-1960-2014-reduced.xlsx"
d <- readWorksheetFromFile(f, sheet = 1, header = TRUE)
head(d)
```

    ##   year   country gov_right1 gov_cent1 gov_left1 gov_party      elect vturn
    ## 1 1960 Australia        100         0         0         1       <NA>  95.5
    ## 2 1961 Australia        100         0         0         1 1961-12-09  95.3
    ## 3 1962 Australia        100         0         0         1       <NA>  95.3
    ## 4 1963 Australia        100         0         0         1 1963-11-30  95.7
    ## 5 1964 Australia        100         0         0         1       <NA>  95.7
    ## 6 1965 Australia        100         0         0         1       <NA>  95.7
    ##   womenpar realgdpgr  inflation debt_hist     deficit ttl_labf labfopar
    ## 1        0        NA  3.7288136  40.14869  0.45821359  4215.00       NA
    ## 2        0    -0.643  2.2875817  38.61921 -0.35762461  4286.00       NA
    ## 3        0     5.767 -0.3194888  38.74667 -0.79382246  4382.00       NA
    ## 4        0     6.009  0.6410256  37.34465 -0.50621226  4484.00       NA
    ## 5        0     6.258  2.8662420  35.30536 -0.08039021  4610.80 67.23930
    ## 6        0     4.987  3.4055728  53.99463 -0.73164443  4745.95 67.65817
    ##      unemp     pop pop15_64 pop65  elderly
    ## 1 1.246594 10275.0   6296.5 874.9 8.514842
    ## 2 2.455488 10508.2   6428.6 894.6 8.513351
    ## 3 2.319219 10700.5   6571.5 913.6 8.537919
    ## 4 1.867158 10906.9   6710.9 933.0 8.554218
    ## 5 1.448287 11121.6   6857.3 948.1 8.524853
    ## 6 1.363485 11340.9   7014.6 966.3 8.520488

``` r
str(d)
```

    ## 'data.frame':    1578 obs. of  20 variables:
    ##  $ year      : num  1960 1961 1962 1963 1964 ...
    ##  $ country   : chr  "Australia" "Australia" "Australia" "Australia" ...
    ##  $ gov_right1: num  100 100 100 100 100 100 100 100 100 100 ...
    ##  $ gov_cent1 : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ gov_left1 : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ gov_party : num  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ elect     : POSIXct, format: NA "1961-12-09" ...
    ##  $ vturn     : num  95.5 95.3 95.3 95.7 95.7 95.7 95.1 95.1 95.1 95 ...
    ##  $ womenpar  : num  0 0 0 0 0 0 0.8 0.8 0.8 0 ...
    ##  $ realgdpgr : num  NA -0.643 5.767 6.009 6.258 ...
    ##  $ inflation : num  3.729 2.288 -0.319 0.641 2.866 ...
    ##  $ debt_hist : num  40.1 38.6 38.7 37.3 35.3 ...
    ##  $ deficit   : num  0.4582 -0.3576 -0.7938 -0.5062 -0.0804 ...
    ##  $ ttl_labf  : num  4215 4286 4382 4484 4611 ...
    ##  $ labfopar  : num  NA NA NA NA 67.2 ...
    ##  $ unemp     : num  1.25 2.46 2.32 1.87 1.45 ...
    ##  $ pop       : num  10275 10508 10700 10907 11122 ...
    ##  $ pop15_64  : num  6296 6429 6572 6711 6857 ...
    ##  $ pop65     : num  875 895 914 933 948 ...
    ##  $ elderly   : num  8.51 8.51 8.54 8.55 8.52 ...

The {XLConnect} package can also write data frames back out to ***Excel*** worksheets. If the file does not exist, it is created. If it does exist, data is cleared and overwritten. The second process is MUCH slower. I have included a conditional statement (`if(){}`) which will implement the `file.remove()` command here, if needed.

``` r
f <- "~/Desktop/output.xlsx"
if (file.exists(f)) {
    file.remove(f)
}
```

    ## [1] TRUE

``` r
writeWorksheetToFile(f, d, sheet = "myData", clearSheets = TRUE)
```

For futher information on using {XLConnect} check out [this blog post](http://altons.github.io/r/2015/02/13/quick-intro-to-xlconnect/#worksheet).

Loading Files Stored on a Remote Server
---------------------------------------

We can also load files stored on a server elsewhere on the web, e.g., ***Dropbox*** or ***GitHub***.

To read `.csv` or `.txt` files directly from ***GitHub***, use the {curl} or {readr} packages.

GO TO: <https://github.com/difiore/ADA2016>, select the `.csv` version of the **CPDS-1960-2014-reduced** file, then press `RAW` and copy the URL from the address box of your browser window... this is what you need to use as an argument for the functions below (you will repeat this for the `.txt` version later on)

### Importing data from a file on a remote server using {curl}

For a comma-separated value (`.csv`) text file...

``` r
library(curl)
```

    ## 
    ## Attaching package: 'curl'

    ## The following object is masked from 'package:readr':
    ## 
    ##     parse_date

``` r
f <- curl("https://raw.githubusercontent.com/difiore/ADA2016/master/CPDS-1960-2014-reduced.csv")
d <- read.csv(f, header = TRUE, sep = ",", stringsAsFactors = FALSE)
head(d)
```

    ##   year   country gov_right1 gov_cent1 gov_left1 gov_party      elect vturn
    ## 1 1960 Australia        100         0         0         1             95.5
    ## 2 1961 Australia        100         0         0         1 09/12/1961  95.3
    ## 3 1962 Australia        100         0         0         1             95.3
    ## 4 1963 Australia        100         0         0         1 30/11/1963  95.7
    ## 5 1964 Australia        100         0         0         1             95.7
    ## 6 1965 Australia        100         0         0         1             95.7
    ##   womenpar realgdpgr inflation debt_hist deficit ttl_labf labfopar unemp
    ## 1        0        NA      3.73     40.15    0.46  4215.00       NA  1.25
    ## 2        0     -0.64      2.29     38.62   -0.36  4286.00       NA  2.46
    ## 3        0      5.77     -0.32     38.75   -0.79  4382.00       NA  2.32
    ## 4        0      6.01      0.64     37.34   -0.51  4484.00       NA  1.87
    ## 5        0      6.26      2.87     35.31   -0.08  4610.80    67.24  1.45
    ## 6        0      4.99      3.41     53.99   -0.73  4745.95    67.66  1.36
    ##       pop pop15_64 pop65 elderly
    ## 1 10275.0   6296.5 874.9    8.51
    ## 2 10508.2   6428.6 894.6    8.51
    ## 3 10700.5   6571.5 913.6    8.54
    ## 4 10906.9   6710.9 933.0    8.55
    ## 5 11121.6   6857.3 948.1    8.52
    ## 6 11340.9   7014.6 966.3    8.52

``` r
# returns a data frame
```

For a tab-delimited (`.tsv` or `txt`) text file...

``` r
f <- curl("https://raw.githubusercontent.com/difiore/ADA2016/master/CPDS-1960-2014-reduced.txt")
d <- read.table(f, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
head(d)
```

    ##   year   country gov_right1 gov_cent1 gov_left1 gov_party      elect vturn
    ## 1 1960 Australia        100         0         0         1             95.5
    ## 2 1961 Australia        100         0         0         1 09/12/1961  95.3
    ## 3 1962 Australia        100         0         0         1             95.3
    ## 4 1963 Australia        100         0         0         1 30/11/1963  95.7
    ## 5 1964 Australia        100         0         0         1             95.7
    ## 6 1965 Australia        100         0         0         1             95.7
    ##   womenpar realgdpgr inflation debt_hist deficit ttl_labf labfopar unemp
    ## 1        0        NA      3.73     40.15    0.46  4215.00       NA  1.25
    ## 2        0     -0.64      2.29     38.62   -0.36  4286.00       NA  2.46
    ## 3        0      5.77     -0.32     38.75   -0.79  4382.00       NA  2.32
    ## 4        0      6.01      0.64     37.34   -0.51  4484.00       NA  1.87
    ## 5        0      6.26      2.87     35.31   -0.08  4610.80    67.24  1.45
    ## 6        0      4.99      3.41     53.99   -0.73  4745.95    67.66  1.36
    ##       pop pop15_64 pop65 elderly
    ## 1 10275.0   6296.5 874.9    8.51
    ## 2 10508.2   6428.6 894.6    8.51
    ## 3 10700.5   6571.5 913.6    8.54
    ## 4 10906.9   6710.9 933.0    8.55
    ## 5 11121.6   6857.3 948.1    8.52
    ## 6 11340.9   7014.6 966.3    8.52

``` r
# returns a data frame
```

### Importing data from a file on a remote server using {readr}

``` r
library(readr)
f <- "https://raw.githubusercontent.com/difiore/ADA2016/master/CPDS-1960-2014-reduced.csv"
d <- read_csv(f, col_names = TRUE)
```

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_double(),
    ##   year = col_integer(),
    ##   country = col_character(),
    ##   gov_party = col_integer(),
    ##   elect = col_character()
    ## )

    ## See spec(...) for full column specifications.

``` r
head(d)
```

    ## # A tibble: 6 × 20
    ##    year   country gov_right1 gov_cent1 gov_left1 gov_party      elect
    ##   <int>     <chr>      <dbl>     <dbl>     <dbl>     <int>      <chr>
    ## 1  1960 Australia        100         0         0         1       <NA>
    ## 2  1961 Australia        100         0         0         1 09/12/1961
    ## 3  1962 Australia        100         0         0         1       <NA>
    ## 4  1963 Australia        100         0         0         1 30/11/1963
    ## 5  1964 Australia        100         0         0         1       <NA>
    ## 6  1965 Australia        100         0         0         1       <NA>
    ## # ... with 13 more variables: vturn <dbl>, womenpar <dbl>,
    ## #   realgdpgr <dbl>, inflation <dbl>, debt_hist <dbl>, deficit <dbl>,
    ## #   ttl_labf <dbl>, labfopar <dbl>, unemp <dbl>, pop <dbl>,
    ## #   pop15_64 <dbl>, pop65 <dbl>, elderly <dbl>

``` r
# returns a 'tibble', a new version of a data frame
```

``` r
f <- "https://raw.githubusercontent.com/difiore/ADA2016/master/CPDS-1960-2014-reduced.txt"
d <- read_tsv(f, col_names = TRUE)
```

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_double(),
    ##   year = col_integer(),
    ##   country = col_character(),
    ##   gov_party = col_integer(),
    ##   elect = col_character()
    ## )

    ## See spec(...) for full column specifications.

``` r
head(d)
```

    ## # A tibble: 6 × 20
    ##    year   country gov_right1 gov_cent1 gov_left1 gov_party      elect
    ##   <int>     <chr>      <dbl>     <dbl>     <dbl>     <int>      <chr>
    ## 1  1960 Australia        100         0         0         1       <NA>
    ## 2  1961 Australia        100         0         0         1 09/12/1961
    ## 3  1962 Australia        100         0         0         1       <NA>
    ## 4  1963 Australia        100         0         0         1 30/11/1963
    ## 5  1964 Australia        100         0         0         1       <NA>
    ## 6  1965 Australia        100         0         0         1       <NA>
    ## # ... with 13 more variables: vturn <dbl>, womenpar <dbl>,
    ## #   realgdpgr <dbl>, inflation <dbl>, debt_hist <dbl>, deficit <dbl>,
    ## #   ttl_labf <dbl>, labfopar <dbl>, unemp <dbl>, pop <dbl>,
    ## #   pop15_64 <dbl>, pop65 <dbl>, elderly <dbl>

``` r
# returns a 'tibble', a new version of a data frame
```

### Importing data from a file hosted on ***Dropbox***

To load data from a `.csv` located file in a *personal* ***Dropbox*** account you can use the {rdrop2} package.

**NOTE:** The following code block cannot be "knit" to show you the output because it requires an interactive ***R*** environment for `drop_auth()`, `drop_search()`, etc.

``` r
require(rdrop2)
drop_auth()  # opens a browser dialog box to ask for authorization...
drop_dir()  # lists the contents of your dropbox folder
f <- "CPDS-1960-2014-reduced.csv"  # name of the file to read from
f <- drop_search(f)  # searches your dropbox directory for file or directory names; this can be slow
f <- f$path  # $path is the location of the results returned above
d <- drop_read_csv(f, header = TRUE, sep = ",", stringsAsFactors = FALSE)
head(d)
str(d)
```

This same process can be done to load data from other types of delimited files in ***Dropbox*** by setting the appropriate `sep=` argument.

You can also read text files from someone else's ***Dropbox*** account using a link that they have shared with you.

``` r
link <- "https://www.dropbox.com/s/5x2go0xxgkf0ig1/CPDS-1960-2014-reduced.csv?dl=0"
```

**NOTE:** Shared ***Dropbox*** links like this one will take you to a webpage that has the data embedded... to get the raw data you need to change the end of the link from **dl=0** to **dl=1** or **raw=1**. That's what the next line of code does:

``` r
link <- gsub(pattern = "dl=0", replacement = "dl=1", x = link)
d <- read.csv(link, header = TRUE, sep = ",", stringsAsFactors = FALSE)
head(d)
```

    ##   year   country gov_right1 gov_cent1 gov_left1 gov_party      elect vturn
    ## 1 1960 Australia        100         0         0         1             95.5
    ## 2 1961 Australia        100         0         0         1 09/12/1961  95.3
    ## 3 1962 Australia        100         0         0         1             95.3
    ## 4 1963 Australia        100         0         0         1 30/11/1963  95.7
    ## 5 1964 Australia        100         0         0         1             95.7
    ## 6 1965 Australia        100         0         0         1             95.7
    ##   womenpar realgdpgr inflation debt_hist deficit ttl_labf labfopar unemp
    ## 1        0        NA      3.73     40.15    0.46  4215.00       NA  1.25
    ## 2        0     -0.64      2.29     38.62   -0.36  4286.00       NA  2.46
    ## 3        0      5.77     -0.32     38.75   -0.79  4382.00       NA  2.32
    ## 4        0      6.01      0.64     37.34   -0.51  4484.00       NA  1.87
    ## 5        0      6.26      2.87     35.31   -0.08  4610.80    67.24  1.45
    ## 6        0      4.99      3.41     53.99   -0.73  4745.95    67.66  1.36
    ##       pop pop15_64 pop65 elderly
    ## 1 10275.0   6296.5 874.9    8.51
    ## 2 10508.2   6428.6 894.6    8.51
    ## 3 10700.5   6571.5 913.6    8.54
    ## 4 10906.9   6710.9 933.0    8.55
    ## 5 11121.6   6857.3 948.1    8.52
    ## 6 11340.9   7014.6 966.3    8.52

``` r
str(d)
```

    ## 'data.frame':    1578 obs. of  20 variables:
    ##  $ year      : int  1960 1961 1962 1963 1964 1965 1966 1967 1968 1969 ...
    ##  $ country   : chr  "Australia" "Australia" "Australia" "Australia" ...
    ##  $ gov_right1: num  100 100 100 100 100 100 100 100 100 100 ...
    ##  $ gov_cent1 : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ gov_left1 : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ gov_party : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ elect     : chr  "" "09/12/1961" "" "30/11/1963" ...
    ##  $ vturn     : num  95.5 95.3 95.3 95.7 95.7 95.7 95.1 95.1 95.1 95 ...
    ##  $ womenpar  : num  0 0 0 0 0 0 0.8 0.8 0.8 0 ...
    ##  $ realgdpgr : num  NA -0.64 5.77 6.01 6.26 4.99 2.93 7.19 5.3 6.25 ...
    ##  $ inflation : num  3.73 2.29 -0.32 0.64 2.87 3.41 3.29 3.48 2.52 3.28 ...
    ##  $ debt_hist : num  40.1 38.6 38.8 37.3 35.3 ...
    ##  $ deficit   : num  0.46 -0.36 -0.79 -0.51 -0.08 -0.73 -1.81 -1.81 -1.35 -0.15 ...
    ##  $ ttl_labf  : num  4215 4286 4382 4484 4611 ...
    ##  $ labfopar  : num  NA NA NA NA 67.2 ...
    ##  $ unemp     : num  1.25 2.46 2.32 1.87 1.45 1.36 1.69 1.82 1.65 1.57 ...
    ##  $ pop       : num  10275 10508 10700 10907 11122 ...
    ##  $ pop15_64  : num  6296 6429 6572 6711 6857 ...
    ##  $ pop65     : num  875 895 914 933 948 ...
    ##  $ elderly   : num  8.51 8.51 8.54 8.55 8.52 8.52 8.5 8.47 8.44 8.37 ...

You can also use the `source_data()` function from the {repmis} package ("Miscellaneous Tools for Reproducible Research") to load data from a file on ***Dropbox***. This function detects column types and gives a few more warnings than others if it encounters somthing odd.

``` r
require(repmis)
```

    ## Loading required package: repmis

``` r
d <- source_data(link, header = TRUE, sep = ",")  # use the same updated link to the raw data as above
```

    ## Downloading data from: https://www.dropbox.com/s/5x2go0xxgkf0ig1/CPDS-1960-2014-reduced.csv?dl=1

    ## SHA-1 hash of the downloaded data file is:
    ## cb733faba9bdc71bbf10b71996043365a5755240

``` r
head(d)
```

    ##   year   country gov_right1 gov_cent1 gov_left1 gov_party      elect vturn
    ## 1 1960 Australia        100         0         0         1             95.5
    ## 2 1961 Australia        100         0         0         1 09/12/1961  95.3
    ## 3 1962 Australia        100         0         0         1             95.3
    ## 4 1963 Australia        100         0         0         1 30/11/1963  95.7
    ## 5 1964 Australia        100         0         0         1             95.7
    ## 6 1965 Australia        100         0         0         1             95.7
    ##   womenpar realgdpgr inflation debt_hist deficit ttl_labf labfopar unemp
    ## 1        0        NA      3.73     40.15    0.46  4215.00       NA  1.25
    ## 2        0     -0.64      2.29     38.62   -0.36  4286.00       NA  2.46
    ## 3        0      5.77     -0.32     38.75   -0.79  4382.00       NA  2.32
    ## 4        0      6.01      0.64     37.34   -0.51  4484.00       NA  1.87
    ## 5        0      6.26      2.87     35.31   -0.08  4610.80    67.24  1.45
    ## 6        0      4.99      3.41     53.99   -0.73  4745.95    67.66  1.36
    ##       pop pop15_64 pop65 elderly
    ## 1 10275.0   6296.5 874.9    8.51
    ## 2 10508.2   6428.6 894.6    8.51
    ## 3 10700.5   6571.5 913.6    8.54
    ## 4 10906.9   6710.9 933.0    8.55
    ## 5 11121.6   6857.3 948.1    8.52
    ## 6 11340.9   7014.6 966.3    8.52

``` r
str(d)
```

    ## 'data.frame':    1578 obs. of  20 variables:
    ##  $ year      : int  1960 1961 1962 1963 1964 1965 1966 1967 1968 1969 ...
    ##  $ country   : chr  "Australia" "Australia" "Australia" "Australia" ...
    ##  $ gov_right1: num  100 100 100 100 100 100 100 100 100 100 ...
    ##  $ gov_cent1 : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ gov_left1 : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ gov_party : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ elect     : chr  "" "09/12/1961" "" "30/11/1963" ...
    ##  $ vturn     : num  95.5 95.3 95.3 95.7 95.7 95.7 95.1 95.1 95.1 95 ...
    ##  $ womenpar  : num  0 0 0 0 0 0 0.8 0.8 0.8 0 ...
    ##  $ realgdpgr : num  NA -0.64 5.77 6.01 6.26 4.99 2.93 7.19 5.3 6.25 ...
    ##  $ inflation : num  3.73 2.29 -0.32 0.64 2.87 3.41 3.29 3.48 2.52 3.28 ...
    ##  $ debt_hist : num  40.1 38.6 38.8 37.3 35.3 ...
    ##  $ deficit   : num  0.46 -0.36 -0.79 -0.51 -0.08 -0.73 -1.81 -1.81 -1.35 -0.15 ...
    ##  $ ttl_labf  : num  4215 4286 4382 4484 4611 ...
    ##  $ labfopar  : num  NA NA NA NA 67.2 ...
    ##  $ unemp     : num  1.25 2.46 2.32 1.87 1.45 1.36 1.69 1.82 1.65 1.57 ...
    ##  $ pop       : num  10275 10508 10700 10907 11122 ...
    ##  $ pop15_64  : num  6296 6429 6572 6711 6857 ...
    ##  $ pop65     : num  875 895 914 933 948 ...
    ##  $ elderly   : num  8.51 8.51 8.54 8.55 8.52 8.52 8.5 8.47 8.44 8.37 ...

### Importing data from files in ***UT Box***

Finally, you can also load tabular data from ***UT Box*** using a *direct link* that someone has shared with you (these links are those that come from the *Advanced Settings* menu).

``` r
link <- "https://utexas.box.com/shared/static/h83gdk6wpy5r8cifftaci3cexc52t4fr.csv"
d <- read.csv(link, sep = ",", header = TRUE, stringsAsFactors = FALSE)
head(d)
```

    ##   year   country gov_right1 gov_cent1 gov_left1 gov_party      elect vturn
    ## 1 1960 Australia        100         0         0         1             95.5
    ## 2 1961 Australia        100         0         0         1 09/12/1961  95.3
    ## 3 1962 Australia        100         0         0         1             95.3
    ## 4 1963 Australia        100         0         0         1 30/11/1963  95.7
    ## 5 1964 Australia        100         0         0         1             95.7
    ## 6 1965 Australia        100         0         0         1             95.7
    ##   womenpar realgdpgr inflation debt_hist deficit ttl_labf labfopar unemp
    ## 1        0        NA      3.73     40.15    0.46  4215.00       NA  1.25
    ## 2        0     -0.64      2.29     38.62   -0.36  4286.00       NA  2.46
    ## 3        0      5.77     -0.32     38.75   -0.79  4382.00       NA  2.32
    ## 4        0      6.01      0.64     37.34   -0.51  4484.00       NA  1.87
    ## 5        0      6.26      2.87     35.31   -0.08  4610.80    67.24  1.45
    ## 6        0      4.99      3.41     53.99   -0.73  4745.95    67.66  1.36
    ##       pop pop15_64 pop65 elderly
    ## 1 10275.0   6296.5 874.9    8.51
    ## 2 10508.2   6428.6 894.6    8.51
    ## 3 10700.5   6571.5 913.6    8.54
    ## 4 10906.9   6710.9 933.0    8.55
    ## 5 11121.6   6857.3 948.1    8.52
    ## 6 11340.9   7014.6 966.3    8.52

``` r
str(d)
```

    ## 'data.frame':    1578 obs. of  20 variables:
    ##  $ year      : int  1960 1961 1962 1963 1964 1965 1966 1967 1968 1969 ...
    ##  $ country   : chr  "Australia" "Australia" "Australia" "Australia" ...
    ##  $ gov_right1: num  100 100 100 100 100 100 100 100 100 100 ...
    ##  $ gov_cent1 : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ gov_left1 : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ gov_party : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ elect     : chr  "" "09/12/1961" "" "30/11/1963" ...
    ##  $ vturn     : num  95.5 95.3 95.3 95.7 95.7 95.7 95.1 95.1 95.1 95 ...
    ##  $ womenpar  : num  0 0 0 0 0 0 0.8 0.8 0.8 0 ...
    ##  $ realgdpgr : num  NA -0.64 5.77 6.01 6.26 4.99 2.93 7.19 5.3 6.25 ...
    ##  $ inflation : num  3.73 2.29 -0.32 0.64 2.87 3.41 3.29 3.48 2.52 3.28 ...
    ##  $ debt_hist : num  40.1 38.6 38.8 37.3 35.3 ...
    ##  $ deficit   : num  0.46 -0.36 -0.79 -0.51 -0.08 -0.73 -1.81 -1.81 -1.35 -0.15 ...
    ##  $ ttl_labf  : num  4215 4286 4382 4484 4611 ...
    ##  $ labfopar  : num  NA NA NA NA 67.2 ...
    ##  $ unemp     : num  1.25 2.46 2.32 1.87 1.45 1.36 1.69 1.82 1.65 1.57 ...
    ##  $ pop       : num  10275 10508 10700 10907 11122 ...
    ##  $ pop15_64  : num  6296 6429 6572 6711 6857 ...
    ##  $ pop65     : num  875 895 914 933 948 ...
    ##  $ elderly   : num  8.51 8.51 8.54 8.55 8.52 8.52 8.5 8.47 8.44 8.37 ...

Or, alternatively, using {repmis}...

``` r
require(repmis)
d <- source_data(link, header = TRUE, sep = ",")
```

    ## Downloading data from: https://utexas.box.com/shared/static/h83gdk6wpy5r8cifftaci3cexc52t4fr.csv

    ## SHA-1 hash of the downloaded data file is:
    ## cb733faba9bdc71bbf10b71996043365a5755240

``` r
head(d)
```

    ##   year   country gov_right1 gov_cent1 gov_left1 gov_party      elect vturn
    ## 1 1960 Australia        100         0         0         1             95.5
    ## 2 1961 Australia        100         0         0         1 09/12/1961  95.3
    ## 3 1962 Australia        100         0         0         1             95.3
    ## 4 1963 Australia        100         0         0         1 30/11/1963  95.7
    ## 5 1964 Australia        100         0         0         1             95.7
    ## 6 1965 Australia        100         0         0         1             95.7
    ##   womenpar realgdpgr inflation debt_hist deficit ttl_labf labfopar unemp
    ## 1        0        NA      3.73     40.15    0.46  4215.00       NA  1.25
    ## 2        0     -0.64      2.29     38.62   -0.36  4286.00       NA  2.46
    ## 3        0      5.77     -0.32     38.75   -0.79  4382.00       NA  2.32
    ## 4        0      6.01      0.64     37.34   -0.51  4484.00       NA  1.87
    ## 5        0      6.26      2.87     35.31   -0.08  4610.80    67.24  1.45
    ## 6        0      4.99      3.41     53.99   -0.73  4745.95    67.66  1.36
    ##       pop pop15_64 pop65 elderly
    ## 1 10275.0   6296.5 874.9    8.51
    ## 2 10508.2   6428.6 894.6    8.51
    ## 3 10700.5   6571.5 913.6    8.54
    ## 4 10906.9   6710.9 933.0    8.55
    ## 5 11121.6   6857.3 948.1    8.52
    ## 6 11340.9   7014.6 966.3    8.52

``` r
str(d)
```

    ## 'data.frame':    1578 obs. of  20 variables:
    ##  $ year      : int  1960 1961 1962 1963 1964 1965 1966 1967 1968 1969 ...
    ##  $ country   : chr  "Australia" "Australia" "Australia" "Australia" ...
    ##  $ gov_right1: num  100 100 100 100 100 100 100 100 100 100 ...
    ##  $ gov_cent1 : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ gov_left1 : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ gov_party : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ elect     : chr  "" "09/12/1961" "" "30/11/1963" ...
    ##  $ vturn     : num  95.5 95.3 95.3 95.7 95.7 95.7 95.1 95.1 95.1 95 ...
    ##  $ womenpar  : num  0 0 0 0 0 0 0.8 0.8 0.8 0 ...
    ##  $ realgdpgr : num  NA -0.64 5.77 6.01 6.26 4.99 2.93 7.19 5.3 6.25 ...
    ##  $ inflation : num  3.73 2.29 -0.32 0.64 2.87 3.41 3.29 3.48 2.52 3.28 ...
    ##  $ debt_hist : num  40.1 38.6 38.8 37.3 35.3 ...
    ##  $ deficit   : num  0.46 -0.36 -0.79 -0.51 -0.08 -0.73 -1.81 -1.81 -1.35 -0.15 ...
    ##  $ ttl_labf  : num  4215 4286 4382 4484 4611 ...
    ##  $ labfopar  : num  NA NA NA NA 67.2 ...
    ##  $ unemp     : num  1.25 2.46 2.32 1.87 1.45 1.36 1.69 1.82 1.65 1.57 ...
    ##  $ pop       : num  10275 10508 10700 10907 11122 ...
    ##  $ pop15_64  : num  6296 6429 6572 6711 6857 ...
    ##  $ pop65     : num  875 895 914 933 948 ...
    ##  $ elderly   : num  8.51 8.51 8.54 8.55 8.52 8.52 8.5 8.47 8.44 8.37 ...

Downloading Files from a Remote Server
--------------------------------------

The {rdrop2} package can be used to **download** a file from a personal ***Dropbox*** account to your local computer, rather than just connecting to a ***Dropbox*** file to read the data stored there. This should work with any file type.

**NOTE:** The following code block cannot be "knit" to show you the output because it requires an interactive ***R*** environment for `drop_search()`, etc.

``` r
filename <- "CPDS-1960-2014-reduced.csv"  # name of file to download
f <- drop_search(filename)  # searches your dropbox directory for that file or directory name
f <- f$path  # $path is the location of the results returned above
drop_get(f, local_file = paste0("~/Desktop/", filename), overwrite = TRUE, progress = TRUE)
# this will save the file to the desktop
```

The `progress=TRUE` argument gives you a reassuring progress bar. By default, this argument is set to FALSE.

**NOTE:** The process also works for other file types, e.g., ***Excel*** files:

``` r
filename <- "CPDS-1960-2014-reduced.xlsx"
f <- drop_search(filename)  # searches your dropbox directory for file or directory names
f <- f$path  # $path is the location of the results returned above
drop_get(f, local_file = paste0("~/Desktop/", filename), overwrite = TRUE, progress = TRUE)
# again, saves to the desktop
```
