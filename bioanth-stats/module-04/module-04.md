Module 04
================

Working with Other Data Structures
==================================

Objectives
----------

> The objective of this module is to introduce additional data structures in ***R*** (arrays, matrices, lists, and data frames) and to learn how to extract, filter, and subset data from them.

Preliminaries
-------------

-   GO TO: <https://github.com/difiore/ADA2016>, select the **random-people.csv** file, then press the `RAW` button, highlight, and copy the text to a text editor and save it locally.

-   Install this package in ***R***: {stringr}

The Backstory
-------------

So far, we have seen how to create **vectors**, which is the most fundamental data structure in ***R***. Today, we will explore and learn how to manipulate other data structures, including matrices, arrays, lists, and data frames.

Matrices and Arrays
-------------------

A **matrix** is like a collection of vectors stored together, and like vectors, matrices can only store data of one class (e.g., *numerical* or *character*). Matrices are created using the `matrix()` function,

``` r
m <- matrix(data = c(1, 2, 3, 4), nrow = 2, ncol = 2)
m
```

    ##      [,1] [,2]
    ## [1,]    1    3
    ## [2,]    2    4

Matrices are typically filled column-wise, with the argument, `byrow`, set to FALSE by default, but this can be changed by specifying this argument as TRUE.

``` r
m <- matrix(data = c(1, 2, 3, 4, 5, 6), nrow = 2, ncol = 3, byrow = FALSE)
m
```

    ##      [,1] [,2] [,3]
    ## [1,]    1    3    5
    ## [2,]    2    4    6

``` r
m <- matrix(data = c(1, 2, 3, 4, 5, 6), nrow = 2, ncol = 3, byrow = TRUE)
m
```

    ##      [,1] [,2] [,3]
    ## [1,]    1    2    3
    ## [2,]    4    5    6

You can also create matrices in ***R*** by **binding** vectors of the same length together either row-wise (with the function `rbind()`) or column-wise (with the function `cbind()`).

``` r
v1 <- c(1, 2, 3, 4)
v2 <- c(6, 7, 8, 9)
m1 <- rbind(v1, v2)
m1
```

    ##    [,1] [,2] [,3] [,4]
    ## v1    1    2    3    4
    ## v2    6    7    8    9

``` r
m2 <- cbind(v1, v2)
m2
```

    ##      v1 v2
    ## [1,]  1  6
    ## [2,]  2  7
    ## [3,]  3  8
    ## [4,]  4  9

Metadata about a matrix can be extracted using the `class()`, `dim()`, `names()`, `rownames()`, `colnames()` and other commands. The `dim()` command returns an vector containing the number of rows at index position 1 and the number of columns at index position 2.

``` r
class(m1)
```

    ## [1] "matrix"

``` r
dim(m1)
```

    ## [1] 2 4

``` r
class(m2)
```

    ## [1] "matrix"

``` r
dim(m2)
```

    ## [1] 4 2

``` r
colnames(m2)
```

    ## [1] "v1" "v2"

``` r
rownames(m2)
```

    ## NULL

NOTE: in this example, **rownames** are not defined, since `cbind()` was used to create the matrix

The *structure* (`str()`) command can be applied to any data structure to provide details about that object. This is an incredibly useful function that you will find yourself using over and over again.

``` r
str(m2)
```

    ##  num [1:4, 1:2] 1 2 3 4 6 7 8 9
    ##  - attr(*, "dimnames")=List of 2
    ##   ..$ : NULL
    ##   ..$ : chr [1:2] "v1" "v2"

An **array** is a more general data structure, of which a vector (with 1 implicit dimension) and a matrix (with 2 defined dimensions) are but examples. Arrays can include additional dimensions, but (like vectors and matrices) they can only include elements that are all of the same atomic data class (e.g., `numeric`, `character`). The example below shows the construction of a 3 dimensional array with 5 rows, 6 columns, and 3 "levels"). Visualizing higher and higher dimension arrays, obviously, becomes challenging!

``` r
a <- array(data = 1:90, dim = c(5, 6, 3))
a
```

    ## , , 1
    ## 
    ##      [,1] [,2] [,3] [,4] [,5] [,6]
    ## [1,]    1    6   11   16   21   26
    ## [2,]    2    7   12   17   22   27
    ## [3,]    3    8   13   18   23   28
    ## [4,]    4    9   14   19   24   29
    ## [5,]    5   10   15   20   25   30
    ## 
    ## , , 2
    ## 
    ##      [,1] [,2] [,3] [,4] [,5] [,6]
    ## [1,]   31   36   41   46   51   56
    ## [2,]   32   37   42   47   52   57
    ## [3,]   33   38   43   48   53   58
    ## [4,]   34   39   44   49   54   59
    ## [5,]   35   40   45   50   55   60
    ## 
    ## , , 3
    ## 
    ##      [,1] [,2] [,3] [,4] [,5] [,6]
    ## [1,]   61   66   71   76   81   86
    ## [2,]   62   67   72   77   82   87
    ## [3,]   63   68   73   78   83   88
    ## [4,]   64   69   74   79   84   89
    ## [5,]   65   70   75   80   85   90

Subsetting
----------

You can select elements from vectors, matrices, and arrays by *subsetting* them using their index position(s) in **bracket notation**. For vectors, you would specify an index value in one dimension. For matrices, you would give the index values in two dimensions. For arrays generally, you would give index values for each dimension in the array.

For example, suppose you have the following vector:

``` r
v <- 1:100
v
```

    ##   [1]   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17
    ##  [18]  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34
    ##  [35]  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51
    ##  [52]  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68
    ##  [69]  69  70  71  72  73  74  75  76  77  78  79  80  81  82  83  84  85
    ##  [86]  86  87  88  89  90  91  92  93  94  95  96  97  98  99 100

You can select the first 15 elements as follows:

``` r
v[1:15]
```

    ##  [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15

You can also give a vector of index values to use to subset:

``` r
v[c(2, 4, 6, 8, 10)]
```

    ## [1]  2  4  6  8 10

You can also use a function or a calculation to subset a vector. What does the following return?

``` r
v <- 101:200
v[seq(from = 1, to = 100, by = 2)]
```

    ##  [1] 101 103 105 107 109 111 113 115 117 119 121 123 125 127 129 131 133
    ## [18] 135 137 139 141 143 145 147 149 151 153 155 157 159 161 163 165 167
    ## [35] 169 171 173 175 177 179 181 183 185 187 189 191 193 195 197 199

#### CHALLENGE:

-   First, create a vector of 1 word character strings comprising the first line of the Gettysburg address: "Four score and seven years ago our fathers brought forth on this continent, a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal."

-   Then, extract every third element of this vector.

    -   **HINT 1:** Take a look at the {stringr} package and the function `str_split()` to see if you can easily divide a single string into a vector of substrings.

    -   **HINT 2:** If you're ambitious, the following function, `gsub("[[:punct:]]","",*string*)`, applied to `*string*`, will remove punction and special characters from that string.

As an example for a matrix, suppose you have the following:

``` r
m <- matrix(data = 1:80, nrow = 8, ncol = 10, byrow = FALSE)
m
```

    ##      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
    ## [1,]    1    9   17   25   33   41   49   57   65    73
    ## [2,]    2   10   18   26   34   42   50   58   66    74
    ## [3,]    3   11   19   27   35   43   51   59   67    75
    ## [4,]    4   12   20   28   36   44   52   60   68    76
    ## [5,]    5   13   21   29   37   45   53   61   69    77
    ## [6,]    6   14   22   30   38   46   54   62   70    78
    ## [7,]    7   15   23   31   39   47   55   63   71    79
    ## [8,]    8   16   24   32   40   48   56   64   72    80

You can extract the element in row 4, column 5 and assign it to a new variable, **x**, as follows:

``` r
x <- m[4, 5]
x
```

    ## [1] 36

You can also extract an entire row or an entire column (or set of rows or set of columns) from a matrix by specifying the desired row or column number(s) and leaving the other value blank.

#### CHALLENGE:

-   Given the matrix, **m**, above, extract the 2nd, 3rd, and 6th columns and assign them to the variable **x**

-   Given the matrix, **m**, above, extract the 6th to 8th row and assign them to the variable **x**

-   Given the matrix, **m**, above, extract the elements from row 2, column 2 to row 6, column 9 and assign them to the variable **x**

#### CHALLENGE:

-   Construct a 4-dimensional, 400 element array (5 x 5 x 4 x 4) named **a** consisting of the numbers 400 to 1 (i.e., a descending series)

-   Given this matrix, what would the following return?

    -   a\[1, 1, 1, 2\]

    -   a\[2, 3, 2, \]

    -   a\[1:5, 1:5, 3, 3\]

Overwriting
-----------

You can replace elements in a vector or matrix, or even entire rows or columns, by identifying the elements to be replaced and then assigning them new values.

Starting with the matrix, **m**, defined above, what will be the effects of operations below? Pay careful attention to row and column index values, vector recycling, and automated conversion/recasting among data classes.

``` r
m[7, 1] <- 564
m[, 8] <- 2
m[2:5, 4:8] <- 1
m[2:5, 4:8] <- c(20, 19, 18, 17)
m[2:5, 4:8] <- matrix(data = c(20:1), nrow = 4, ncol = 5, byrow = TRUE)
m[, 8] <- c("a", "b")
```

Lists and Data Frames
---------------------

Lists and data frames, unlike vectors, matrices, and arrays, can be used to group together a mix of ***R*** structures and objects. A single list could contain a matrix, vector of character strings, vector of factors, an array, even another list.

Lists are created using the `list()` function where the elements to add to the list are given as arguments to the function, separated by commas. Type in the following example:

``` r
s <- c("this", "is", "a", "vector", "of", "strings")
m <- matrix(data = 1:40, nrow = 5, ncol = 8)  # this is a matrix
b <- FALSE
l <- list(s, m, b)
l
```

    ## [[1]]
    ## [1] "this"    "is"      "a"       "vector"  "of"      "strings"
    ## 
    ## [[2]]
    ##      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
    ## [1,]    1    6   11   16   21   26   31   36
    ## [2,]    2    7   12   17   22   27   32   37
    ## [3,]    3    8   13   18   23   28   33   38
    ## [4,]    4    9   14   19   24   29   34   39
    ## [5,]    5   10   15   20   25   30   35   40
    ## 
    ## [[3]]
    ## [1] FALSE

You can extract elements from a list similarly to how you would from other data structure, except that you use **double brackets** to reference a single element in the list.

``` r
l[[2]]
```

    ##      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
    ## [1,]    1    6   11   16   21   26   31   36
    ## [2,]    2    7   12   17   22   27   32   37
    ## [3,]    3    8   13   18   23   28   33   38
    ## [4,]    4    9   14   19   24   29   34   39
    ## [5,]    5   10   15   20   25   30   35   40

An extension of this notation can be used to access elements contained within an element in the list. For example:

``` r
l[[2]][2, 6]
```

    ## [1] 27

To reference/extract multiple elements from a list, you would use **single bracket** notation, which would itself return a list. This is called "list slicing".

``` r
l[1:2]
```

    ## [[1]]
    ## [1] "this"    "is"      "a"       "vector"  "of"      "strings"
    ## 
    ## [[2]]
    ##      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
    ## [1,]    1    6   11   16   21   26   31   36
    ## [2,]    2    7   12   17   22   27   32   37
    ## [3,]    3    8   13   18   23   28   33   38
    ## [4,]    4    9   14   19   24   29   34   39
    ## [5,]    5   10   15   20   25   30   35   40

``` r
l[c(1, 3)]
```

    ## [[1]]
    ## [1] "this"    "is"      "a"       "vector"  "of"      "strings"
    ## 
    ## [[2]]
    ## [1] FALSE

Using `str()` provides details about the three elements in our list:

``` r
str(l)
```

    ## List of 3
    ##  $ : chr [1:6] "this" "is" "a" "vector" ...
    ##  $ : int [1:5, 1:8] 1 2 3 4 5 6 7 8 9 10 ...
    ##  $ : logi FALSE

You can **name** the elements in a list using the `names()` function, which adds a name attribute to each list item.

``` r
names(l) <- c("string", "matrix", "logical")
names(l)
```

    ## [1] "string"  "matrix"  "logical"

Now, you can use the name of an item in the list to refer to it:

``` r
l$string
```

    ## [1] "this"    "is"      "a"       "vector"  "of"      "strings"

``` r
l$matrix[3, 5]
```

    ## [1] 23

#### CHALLENGE:

-   Create a **list** representing this (simplified) primate taxonomy. **HINT:** you can use **lists** as elements in a list.

-   Primates
    -   Haplorhini
        -   Anthropoidea
            -   Platyrrhini
                -   Cebidae
                -   Atelidae
                -   Pitheciidae
            -   Catarrhini
                -   Cercopithecidae
                -   Hylobatidae
                -   Hominidae
        -   Tarsioidea
            -   Tarsiidae
    -   Strepsirhini
        -   Lorisoidea
            -   Lorisidae
            -   Galagidae
        -   Lemuroidea
            -   Cheirogaleidae
            -   Lepilemuridae
            -   Indriidae
            -   Lemuridae
            -   Daubentoniidae

A **data frame** is the perhaps the most useful (and most familiar) data structure that we can operate with in ***R*** as it most closely aligns with how we tend to represent tabular data, with rows as *cases* or *observations* and columns as *variables* describing those observations (e.g., a measurement of a particular type). Variables tend to be measured using the same units and thus fall into the same data class and can be thought of as analogous to vectors.

The `data.frame()` command can be used to create dataframes from scratch.

``` r
df <- data.frame(firstName = c("Nitin", "Silvy", "Ingrid", "Claire"), program = c("iSchool", 
    "Anthro", "Anthro", "EEB"), sex = c("M", "F", "F", "F"), yearInProgram = c(1, 
    2, 2, 3))
df
```

    ##   firstName program sex yearInProgram
    ## 1     Nitin iSchool   M             1
    ## 2     Silvy  Anthro   F             2
    ## 3    Ingrid  Anthro   F             2
    ## 4    Claire     EEB   F             3

More commonly we read tabular data into ***R***, which typically results in the table being represented as a data frame. This will read from the file "random-people.csv" stored on a user's desktop.

``` r
df <- read.csv("~/Desktop/random-people.csv", sep = ",", header = TRUE, stringsAsFactors = FALSE)
# only print select columns
df[, c(1, 3, 4, 11, 12)]
```

    ##    gender name.first  name.last login.password            dob
    ## 1    male        ted     wright          rolex   11/8/73 1:33
    ## 2    male    quentin    schmitt         norton   5/24/51 3:16
    ## 3  female      laura   johansen        stevens  5/22/77 21:03
    ## 4    male     ismael    herrero         303030    8/1/58 9:13
    ## 5  female     susana     blanco          aloha  12/18/55 3:21
    ## 6    male      mason     wilson         topdog   6/23/60 9:19
    ## 7    male       lutz    strauio       close-up   7/20/80 3:51
    ## 8  female     kaylee     gordon       atlantis  3/24/48 12:22
    ## 9    male     baraek limoncuocu         tobias   5/8/92 22:01
    ## 10   male     basile     perrin          ellie   2/28/65 0:37
    ## 11   male      ruben      lopez           beth   5/27/76 3:30
    ## 12   male   valtteri   waisanen       nocturne 12/24/80 10:40
    ## 13 female    vanessa     brewer       gladiato  1/15/68 17:39
    ## 14 female   kimberly      brown       nebraska    1/9/86 8:54
    ## 15 female     loreen   baettner         rovers    9/3/49 4:56
    ## 16 female      becky    wallace          bambi   3/30/59 5:03
    ## 17   male     hector   gonzalez        calgary  12/10/53 6:48
    ## 18 female       ella       neva       f00tball  7/18/91 14:30
    ## 19   male      simon    barnaby         buddie   6/18/89 5:06
    ## 20   male        max      moser    penetrating  8/12/61 12:13

``` r
str(df)
```

    ## 'data.frame':    20 obs. of  17 variables:
    ##  $ gender           : chr  "male" "male" "female" "male" ...
    ##  $ name.title       : chr  "mr" "mr" "ms" "mr" ...
    ##  $ name.first       : chr  "ted" "quentin" "laura" "ismael" ...
    ##  $ name.last        : chr  "wright" "schmitt" "johansen" "herrero" ...
    ##  $ location.street  : chr  "2020 royal ln" "2433 rue dubois" "2142 elmelunden" "3897 calle del barquillo" ...
    ##  $ location.city    : chr  "coffs harbour" "vitry-sur-seine" "silkeboeg" "gandia" ...
    ##  $ location.state   : chr  "tasmania" "indre-et-loire" "hovedstaden" "ceuta" ...
    ##  $ location.postcode: chr  "4126" "99856" "16264" "61349" ...
    ##  $ email            : chr  "ted.wright@example.com" "quentin.schmitt@example.com" "laura.johansen@example.com" "ismael.herrero@example.com" ...
    ##  $ login.username   : chr  "organicleopard402" "bluegoose191" "orangebird528" "heavyswan518" ...
    ##  $ login.password   : chr  "rolex" "norton" "stevens" "303030" ...
    ##  $ dob              : chr  "11/8/73 1:33" "5/24/51 3:16" "5/22/77 21:03" "8/1/58 9:13" ...
    ##  $ date.registered  : chr  "5/5/07 20:26" "4/11/11 7:05" "5/16/14 15:53" "2/17/06 16:53" ...
    ##  $ phone            : chr  "01-0349-5128" "05-72-65-32-21" "81616775" "974-117-403" ...
    ##  $ cell             : chr  "0449-989-455" "06-83-24-92-41" "697-993-20" "665-791-673" ...
    ##  $ picture.large    : chr  "https://randomuser.me/api/portraits/men/48.jpg" "https://randomuser.me/api/portraits/men/53.jpg" "https://randomuser.me/api/portraits/women/70.jpg" "https://randomuser.me/api/portraits/men/79.jpg" ...
    ##  $ nat              : chr  "AU" "FR" "DK" "ES" ...

As for other data structures, you can select and subset data frames using **bracket notation**. You can also select named columns from a data frame the **$** operator.

``` r
df[, 3]
```

    ##  [1] "ted"      "quentin"  "laura"    "ismael"   "susana"   "mason"   
    ##  [7] "lutz"     "kaylee"   "baraek"   "basile"   "ruben"    "valtteri"
    ## [13] "vanessa"  "kimberly" "loreen"   "becky"    "hector"   "ella"    
    ## [19] "simon"    "max"

``` r
str(df[, 3])
```

    ##  chr [1:20] "ted" "quentin" "laura" "ismael" "susana" ...

``` r
# returns a vector of data in column 3
```

``` r
df$name.last
```

    ##  [1] "wright"     "schmitt"    "johansen"   "herrero"    "blanco"    
    ##  [6] "wilson"     "strauio"    "gordon"     "limoncuocu" "perrin"    
    ## [11] "lopez"      "waisanen"   "brewer"     "brown"      "baettner"  
    ## [16] "wallace"    "gonzalez"   "neva"       "barnaby"    "moser"

``` r
str(df$name.last)
```

    ##  chr [1:20] "wright" "schmitt" "johansen" "herrero" "blanco" ...

``` r
# returns a vector of data for column *name.last*
```

``` r
df[3]
```

    ##    name.first
    ## 1         ted
    ## 2     quentin
    ## 3       laura
    ## 4      ismael
    ## 5      susana
    ## 6       mason
    ## 7        lutz
    ## 8      kaylee
    ## 9      baraek
    ## 10     basile
    ## 11      ruben
    ## 12   valtteri
    ## 13    vanessa
    ## 14   kimberly
    ## 15     loreen
    ## 16      becky
    ## 17     hector
    ## 18       ella
    ## 19      simon
    ## 20        max

``` r
str(df[3])
```

    ## 'data.frame':    20 obs. of  1 variable:
    ##  $ name.first: chr  "ted" "quentin" "laura" "ismael" ...

``` r
# returns a data frame of data from column 3
```

``` r
df["name.last"]
```

    ##     name.last
    ## 1      wright
    ## 2     schmitt
    ## 3    johansen
    ## 4     herrero
    ## 5      blanco
    ## 6      wilson
    ## 7     strauio
    ## 8      gordon
    ## 9  limoncuocu
    ## 10     perrin
    ## 11      lopez
    ## 12   waisanen
    ## 13     brewer
    ## 14      brown
    ## 15   baettner
    ## 16    wallace
    ## 17   gonzalez
    ## 18       neva
    ## 19    barnaby
    ## 20      moser

``` r
str(df["name.last"])
```

    ## 'data.frame':    20 obs. of  1 variable:
    ##  $ name.last: chr  "wright" "schmitt" "johansen" "herrero" ...

``` r
# returns a data frame of data for column *name.last*
```

You can add rows (additional cases) or columns (additional variables) to a data frame using `rbind()` and `cbind()`.

``` r
df <- cbind(df, id = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 
    17, 18, 19, 20))
df <- cbind(df, school = c("UT", "UT", "A&M", "A&M", "UT", "Rice", "Texas Tech", 
    "UT", "UT", "Texas State", "A&M", "UT", "Rice", "UT", "A&M", "Texas Tech", 
    "A&M", "UT", "Texas State", "A&M"))
df
```

    ##    gender name.title name.first  name.last            location.street
    ## 1    male         mr        ted     wright              2020 royal ln
    ## 2    male         mr    quentin    schmitt            2433 rue dubois
    ## 3  female         ms      laura   johansen            2142 elmelunden
    ## 4    male         mr     ismael    herrero   3897 calle del barquillo
    ## 5  female         ms     susana     blanco    2208 avenida de america
    ## 6    male         mr      mason     wilson           4576 wilson road
    ## 7    male         mr       lutz    strauio             5707 eichenweg
    ## 8  female       miss     kaylee     gordon            5475 camden ave
    ## 9    male         mr     baraek limoncuocu             2664 baedat cd
    ## 10   male         mr     basile     perrin   3683 avenue jean-jaurias
    ## 11   male   monsieur      ruben      lopez        4204 rue principale
    ## 12   male         mr   valtteri   waisanen             9850 hemeentie
    ## 13 female        mrs    vanessa     brewer          3436 henry street
    ## 14 female       miss   kimberly      brown            8654 manor road
    ## 15 female       miss     loreen   baettner              2234 erlenweg
    ## 16 female       miss      becky    wallace          5965 the crescent
    ## 17   male   monsieur     hector   gonzalez           5104 rue pasteur
    ## 18 female         ms       ella       neva             4620 visiokatu
    ## 19   male         mr      simon    barnaby             2206 simcoe st
    ## 20   male         mr        max      moser 3045 koenigsberger strasse
    ##      location.city         location.state location.postcode
    ## 1    coffs harbour               tasmania              4126
    ## 2  vitry-sur-seine         indre-et-loire             99856
    ## 3        silkeboeg            hovedstaden             16264
    ## 4           gandia                  ceuta             61349
    ## 5         mastoles            extremadura             29445
    ## 6          dunedin               taranaki             91479
    ## 7            emden            brandenburg             13341
    ## 8            flint                 oregon             84509
    ## 9            siirt                  tokat             86146
    ## 10      versailles               dordogne             25177
    ## 11      montricher                 aargau              7993
    ## 12          halsua          south karelia             58124
    ## 13       celbridge                 fingal             30030
    ## 14          bangor                borders          HI92 8RY
    ## 15 chemnitzer land          niedersachsen             27167
    ## 16             ely         west yorkshire           GR8 0UP
    ## 17         bercher             st. gallen              1745
    ## 18          kerava         finland proper             26385
    ## 19          odessa            nova scotia             90889
    ## 20          weimar mecklenburg-vorpommern             18553
    ##                              email    login.username login.password
    ## 1           ted.wright@example.com organicleopard402          rolex
    ## 2      quentin.schmitt@example.com      bluegoose191         norton
    ## 3       laura.johansen@example.com     orangebird528        stevens
    ## 4       ismael.herrero@example.com      heavyswan518         303030
    ## 5        susana.blanco@example.com    silverkoala701          aloha
    ## 6         mason.wilson@example.com    organicduck470         topdog
    ## 7         lutz.strauio@example.com    purplemouse467       close-up
    ## 8        kaylee.gordon@example.com beautifulgoose794       atlantis
    ## 9  baraek.limoncuoculu@example.com whitebutterfly599         tobias
    ## 10       basile.perrin@example.com organicmeercat418          ellie
    ## 11         ruben.lopez@example.com      crazybear348           beth
    ## 12   valtteri.waisanen@example.com        redswan919       nocturne
    ## 13      vanessa.brewer@example.com  purpleleopard113       gladiato
    ## 14      kimberly.brown@example.com  crazyelephant996       nebraska
    ## 15     loreen.baettner@example.com     blacktiger499         rovers
    ## 16       becky.wallace@example.com   crazypeacock937          bambi
    ## 17     hector.gonzalez@example.com     organiccat637        calgary
    ## 18           ella.neva@example.com  orangegorilla786       f00tball
    ## 19       simon.barnaby@example.com     redmeercat724         buddie
    ## 20           max.moser@example.com     bigladybug459    penetrating
    ##               dob date.registered          phone           cell
    ## 1    11/8/73 1:33    5/5/07 20:26   01-0349-5128   0449-989-455
    ## 2    5/24/51 3:16    4/11/11 7:05 05-72-65-32-21 06-83-24-92-41
    ## 3   5/22/77 21:03   5/16/14 15:53       81616775     697-993-20
    ## 4     8/1/58 9:13   2/17/06 16:53    974-117-403    665-791-673
    ## 5   12/18/55 3:21   10/3/02 17:55    917-199-202    612-612-929
    ## 6    6/23/60 9:19    12/1/08 8:31 (137)-326-5772 (700)-060-1523
    ## 7    7/20/80 3:51   4/10/11 20:44   0802-1871274   0170-4221269
    ## 8   3/24/48 12:22     5/5/13 8:14 (817)-962-1275 (831)-325-1142
    ## 9    5/8/92 22:01    9/12/04 0:56 (023)-879-4331 (837)-014-1113
    ## 10   2/28/65 0:37    4/12/07 4:50 04-16-53-97-17 06-63-08-15-52
    ## 11   5/27/76 3:30   4/17/06 17:40 (931)-692-1073 (747)-833-3781
    ## 12 12/24/80 10:40   9/22/03 20:47     02-227-661  042-153-83-79
    ## 13  1/15/68 17:39    2/5/05 21:02   041-167-2755   081-154-0245
    ## 14    1/9/86 8:54    12/3/11 0:41   017684 80873   0799-553-944
    ## 15    9/3/49 4:56   3/24/16 17:27   0693-0473309   0176-2769900
    ## 16   3/30/59 5:03    7/15/08 2:42   015395 04615   0740-849-325
    ## 17  12/10/53 6:48   3/19/04 20:51 (569)-609-0669 (032)-958-9790
    ## 18  7/18/91 14:30    3/17/14 7:13     02-351-279  043-436-42-30
    ## 19   6/18/89 5:06  12/24/12 12:08   618-983-5566   088-025-2948
    ## 20  8/12/61 12:13    7/19/03 1:08   0503-3338884   0175-7158431
    ##                                       picture.large nat id      school
    ## 1    https://randomuser.me/api/portraits/men/48.jpg  AU  1          UT
    ## 2    https://randomuser.me/api/portraits/men/53.jpg  FR  2          UT
    ## 3  https://randomuser.me/api/portraits/women/70.jpg  DK  3         A&M
    ## 4    https://randomuser.me/api/portraits/men/79.jpg  ES  4         A&M
    ## 5  https://randomuser.me/api/portraits/women/18.jpg  ES  5          UT
    ## 6    https://randomuser.me/api/portraits/men/60.jpg  NZ  6        Rice
    ## 7    https://randomuser.me/api/portraits/men/31.jpg  DE  7  Texas Tech
    ## 8  https://randomuser.me/api/portraits/women/65.jpg  US  8          UT
    ## 9    https://randomuser.me/api/portraits/men/94.jpg  TR  9          UT
    ## 10   https://randomuser.me/api/portraits/men/82.jpg  FR 10 Texas State
    ## 11   https://randomuser.me/api/portraits/men/84.jpg  CH 11         A&M
    ## 12   https://randomuser.me/api/portraits/men/80.jpg  FI 12          UT
    ## 13 https://randomuser.me/api/portraits/women/15.jpg  IE 13        Rice
    ## 14 https://randomuser.me/api/portraits/women/49.jpg  GB 14          UT
    ## 15 https://randomuser.me/api/portraits/women/50.jpg  DE 15         A&M
    ## 16 https://randomuser.me/api/portraits/women/67.jpg  GB 16  Texas Tech
    ## 17    https://randomuser.me/api/portraits/men/9.jpg  CH 17         A&M
    ## 18 https://randomuser.me/api/portraits/women/68.jpg  FI 18          UT
    ## 19   https://randomuser.me/api/portraits/men/61.jpg  CA 19 Texas State
    ## 20   https://randomuser.me/api/portraits/men/49.jpg  DE 20         A&M

Alternatively, you can extend a data frame by adding a new variable directly using the **$** operator, like this:

``` r
df$school <- c("UT", "UT", "A&M", "A&M", "UT", "Rice", "Texas Tech", "UT", "UT", 
    "Texas State", "A&M", "UT", "Rice", "UT", "A&M", "Texas Tech", "A&M", "UT", 
    "Texas State", "A&M")
```

NOTE: `cbind()` results in **school** being added as a *factor* while using the **$** operator results in **school** being added as a *character* vector. You can see this by using the `str()` command.

A *factor* is another atomic data class for ***R*** for dealing efficiently with nominal variables, usually character strings. Internally, ***R*** assigns integer values to each unique string (e.g., 1 for "female", 2 for "male", etc.).

Filtering
---------

Logical vectors also be used to subset data frames. Here, we subset the data frame for only those rows where the variable **school** is "COLA".

``` r
new_df <- df[df$school == "UT", ]
new_df
```

    ##    gender name.title name.first  name.last         location.street
    ## 1    male         mr        ted     wright           2020 royal ln
    ## 2    male         mr    quentin    schmitt         2433 rue dubois
    ## 5  female         ms     susana     blanco 2208 avenida de america
    ## 8  female       miss     kaylee     gordon         5475 camden ave
    ## 9    male         mr     baraek limoncuocu          2664 baedat cd
    ## 12   male         mr   valtteri   waisanen          9850 hemeentie
    ## 14 female       miss   kimberly      brown         8654 manor road
    ## 18 female         ms       ella       neva          4620 visiokatu
    ##      location.city location.state location.postcode
    ## 1    coffs harbour       tasmania              4126
    ## 2  vitry-sur-seine indre-et-loire             99856
    ## 5         mastoles    extremadura             29445
    ## 8            flint         oregon             84509
    ## 9            siirt          tokat             86146
    ## 12          halsua  south karelia             58124
    ## 14          bangor        borders          HI92 8RY
    ## 18          kerava finland proper             26385
    ##                              email    login.username login.password
    ## 1           ted.wright@example.com organicleopard402          rolex
    ## 2      quentin.schmitt@example.com      bluegoose191         norton
    ## 5        susana.blanco@example.com    silverkoala701          aloha
    ## 8        kaylee.gordon@example.com beautifulgoose794       atlantis
    ## 9  baraek.limoncuoculu@example.com whitebutterfly599         tobias
    ## 12   valtteri.waisanen@example.com        redswan919       nocturne
    ## 14      kimberly.brown@example.com  crazyelephant996       nebraska
    ## 18           ella.neva@example.com  orangegorilla786       f00tball
    ##               dob date.registered          phone           cell
    ## 1    11/8/73 1:33    5/5/07 20:26   01-0349-5128   0449-989-455
    ## 2    5/24/51 3:16    4/11/11 7:05 05-72-65-32-21 06-83-24-92-41
    ## 5   12/18/55 3:21   10/3/02 17:55    917-199-202    612-612-929
    ## 8   3/24/48 12:22     5/5/13 8:14 (817)-962-1275 (831)-325-1142
    ## 9    5/8/92 22:01    9/12/04 0:56 (023)-879-4331 (837)-014-1113
    ## 12 12/24/80 10:40   9/22/03 20:47     02-227-661  042-153-83-79
    ## 14    1/9/86 8:54    12/3/11 0:41   017684 80873   0799-553-944
    ## 18  7/18/91 14:30    3/17/14 7:13     02-351-279  043-436-42-30
    ##                                       picture.large nat id school
    ## 1    https://randomuser.me/api/portraits/men/48.jpg  AU  1     UT
    ## 2    https://randomuser.me/api/portraits/men/53.jpg  FR  2     UT
    ## 5  https://randomuser.me/api/portraits/women/18.jpg  ES  5     UT
    ## 8  https://randomuser.me/api/portraits/women/65.jpg  US  8     UT
    ## 9    https://randomuser.me/api/portraits/men/94.jpg  TR  9     UT
    ## 12   https://randomuser.me/api/portraits/men/80.jpg  FI 12     UT
    ## 14 https://randomuser.me/api/portraits/women/49.jpg  GB 14     UT
    ## 18 https://randomuser.me/api/portraits/women/68.jpg  FI 18     UT

In this case, ***R*** evaluates the expression \`df$school == "UT" and returns a logical vector equal in length to the number of rows in **df**. It then subsets **df** based on that vector, returning only rows that evaluate to **TRUE**.

We can also choose to only return particular columns when we subset.

``` r
new_df <- df[df$school == "UT", c("name.last", "name.first", "school")]
new_df
```

    ##     name.last name.first school
    ## 1      wright        ted     UT
    ## 2     schmitt    quentin     UT
    ## 5      blanco     susana     UT
    ## 8      gordon     kaylee     UT
    ## 9  limoncuocu     baraek     UT
    ## 12   waisanen   valtteri     UT
    ## 14      brown   kimberly     UT
    ## 18       neva       ella     UT

Factors, Conversion and Coercion, and Special Data Values
---------------------------------------------------------

We were introduced to the **factor** data class above. Again, factors are numeric codes that ***R*** can use internally that correspond to character value "levels".

When we load in data from an external source (as we will do in our next module), ***R*** tends to import character string data as factors, assigning to each unique string to an integer numeric code and assigning the string as a "label" for that code. Using factors can make some code run much more quickly (e.g., ANOVA, ANCOVA, and other forms of regression using categorical variables).

You can convert *factor* to *character* data (and vice versa) using the `as.character()` or `as.factor()` commands. You can also convert/coerce any vector to a different class using similar constructs (e.g., `as.numeric()`), although not all such conversions are really meaningful. Converting *factor* data to *numeric* results in the the converted data having the value of ***R***'s internal numeric code for the factor level, while converting *character* data to *numeric* results in the data being coerced into the special data value of `NA` (see below) for missing data.

Finally, ***R*** has three special data values that it uses in a variety of situations.

-   `NA` (for *not available*) is used for missing data. Many statistical functions offer the possibility to include as an argument `na.rm=TRUE` ("remove NAs") so that `NA`s are excluded from a calculation.
-   `Inf` (and `-Inf`) is used when the result of a numerical calculation is too extreme for ***R*** to express
-   `NaN` (for *not a number*) is used when ***R*** cannot express the results of a calculation , e.g., when you try to take the square root of a negative number

#### CHALLENGE:

-   Store the following numbers as a 5 x 3 matrix: 3, 0, 1 ,23, 1, 2, 33, 1, 1, 42, 0, 1, 41, 0, 2. Be sure to fill the matrix ROWWISE.

-   Then, do the following:

    -   Coerce the matrix to a data frame.
    -   As a data frame, coerce the second column to be *logical-valued*
    -   As a data frame, coerce the third column to be *factor-valued*

When you are done, use the `str()` command to show the data type for each variable in your dataframe.
