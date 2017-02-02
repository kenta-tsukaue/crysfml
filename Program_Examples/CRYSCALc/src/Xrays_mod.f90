!     Last change:  TR   27 Nov 2006    2:30 pm
 module Xrays_data

 use atome_module ,     ONLY : atom
 USE wavelength_module, ONLY : tabulated_target_nb

 contains
 subroutine definition_data_X

 implicit none
  INTEGER :: i
! ref.: Tables Internationales vol.C  1995, p.200-206
!
! cam: coefficient d'absorption massique en cm2/g              p. 200-206
! tics: total interaction cross section en barns (10-24 cm2)   p. 193-199

 do i = 1, tabulated_target_nb
  atom(1:201)%cam(i)  = -1.
  atom(1:201)%tics(i) = -1.
 enddo

! 1.  Ag

 ! mass attenuation coefficients
 atom(  1: 10)%cam(1) = (/    0.367 ,   0.193 ,   0.179 ,    0.209 ,   0.267 ,  &
                              0.374 ,   0.503 ,   0.685 ,    0.879 ,   1.23 /)
 atom( 11: 20)%cam(1) = (/    1.56  ,   2.09  ,   2.59  ,    3.35  ,   4.01  ,  &
                              5.02  ,   5.79  ,   6.46  ,    8.19  ,   9.79 /)
 atom( 21: 30)%cam(1) = (/   10.6   ,  11.9   ,  13.3   ,   15.4   ,  17.0   ,  &
                             19.4   ,  21.2   ,  24.4   ,   25.6   ,  28.2  /)
 atom( 31: 40)%cam(1) = (/   29.8   ,  32.1   ,  34.8   ,   36.8   ,  40.3   ,  &
                             42.5   ,  45.9   ,  49.1   ,   52.9   ,  55.9  /)
 atom( 41: 50)%cam(1) = (/   59.8   ,  72.0   ,  66.0   ,   11.4   ,  12.3   ,  &
                             13.0   ,  14.0   ,  14.6   ,   15.6   ,  16.4  /)
 atom( 51: 60)%cam(1) = (/   17.3   ,  17.9   ,  19.4   ,   20.2   ,  21.5   ,  &
                             22.4   ,  23.8   ,  25.3   ,   26.9   ,  28.1  /)
 atom( 61: 70)%cam(1) = (/   29.9   ,  30.8   ,  32.4   ,   33.4   ,  35.1   ,  &
                             36.5   ,  38.1   ,  39.9   ,   41.8   ,  43.2  /)
 atom( 71: 80)%cam(1) = (/   45.1   ,  46.7   ,  48.7   ,   50.5   ,  52.5   ,  &
                             54.1   ,  56.3   ,  58.3   ,   60.7   ,  62.6  /)
 atom( 81: 90)%cam(1) = (/   64.5   ,  66.6   ,  69.1   ,   72.3   ,  75.1   ,  &
                             72.1   ,  77.0   ,  79.3   ,   82.4   ,  83.9  /)
 atom( 91: 98)%cam(1) = (/   87.8   ,  88.6   ,  92.5   ,   56.0   ,  59.5   ,  &
                             64.3   ,  61.0   ,  69.2 /)
 atom(201)%cam(1) = atom(1)%cam(1)


 atom(  1: 10)%tics(1) = (/            0.614,       1.28,      2.06,      3.13,      4.79 ,  &
                                       7.45 ,      11.7,      18.2 ,     27.7 ,     41.2 /)
 atom( 11: 20)%tics(1) = (/           59.6  ,     84.2 ,     116.  ,    156.  ,    206.   ,  &
                                     267.   ,    341.  ,     429.  ,    532.  ,    652.  /)
 atom( 21: 30)%tics(1) = (/          789.   ,    947.  ,    1120.  ,   1330.  ,   1550.   ,  &
                                    1800.   ,   2070.  ,    2380.  ,   2710.  ,   3070.  /)
 atom( 31: 40)%tics(1) = (/         3460.   ,   3870.  ,    4330.  ,   4820.  ,   5350.   ,  &
                                    5920.   ,   6520.  ,    7150.  ,   7800.  ,   8470.  /)
 atom( 41: 50)%tics(1) = (/         9220.   ,  11500.  ,   10700.  ,   1920.  ,   2100.   ,  &
                                    2300.   ,   2510.  ,    2730.  ,   2970.  ,   3230.  /)
 atom( 51: 60)%tics(1) = (/         3500.   ,   3780.  ,    4090.  ,   4410.  ,   4750.   ,  &
                                    5110.   ,   5490.  ,    5880.  ,   6300.  ,   6740.  /)
 atom( 61: 70)%tics(1) = (/         7200.   ,   7680.  ,    8190.  ,   8720.  ,   9270.   ,  &
                                    9850.   ,  10400.  ,   11100.  ,  11700.  ,  12400.  /)
 atom( 71: 80)%tics(1) = (/        13100.   ,  13900.  ,   14600.  ,  15400.  ,   16200.   , &
                                   17100.   ,  18000.  ,   18900.  ,  19900.  ,  20900.  /)
 atom( 81: 90)%tics(1) = (/        21900.   ,  22900.  ,   24000.  ,  25100.  ,  26200.   ,  &
                                   27300.   ,  28500.  ,   29800.  ,  31100.  ,  32300.  /)
 atom( 91: 98)%tics(1) = (/        34200.   ,  35000.  ,   29900.  ,  22700.  ,  25000.   ,  &
                                   24600.   ,  25000.  ,   28900. /)
 atom(201)%tics(1) = atom(1)%tics(1)


! 2. Mo
 atom(  1: 10)%cam(2) =  (/    0.373,    0.202,    0.198,    0.256,     0.368,  &
                               0.576,    0.845,    1.22 ,    1.63 ,     2.35 /)
 atom( 11: 20)%cam(2) =  (/    3.03 ,    4.09 ,    5.11 ,    6.64 ,     7.97 ,  &
                               9.99 ,   10.5  ,   12.8  ,   16.2  ,    19.3  /)
 atom( 21: 30)%cam(2) =  (/   20.8  ,   23.4  ,    26.0 ,   29.9  ,    33.1  ,  &
                              37.6  ,   41.0  ,   46.9  ,   49.1  ,    54.0  /)
 atom( 31: 40)%cam(2) =  (/   57.0  ,   61.2  ,   66.1  ,   69.5  ,    75.6  ,  &
                              79.3  ,   85.1  ,   90.6  ,   97.0  ,    16.3  /)
 atom( 41: 50)%cam(2) =  (/   17.7  ,   18.8  ,   20.4  ,   21.7  ,    23.3  ,  &
                              24.7  ,   26.5  ,   27.8  ,   29.5  ,    31.0  /)
 atom( 51: 60)%cam(2) =  (/   32.7  ,   33.8  ,   36.7  ,   38.2  ,    40.7  ,  &
                              42.3  ,   44.9  ,   47.7  ,   50.7  ,    53.0  /)
 atom( 61: 70)%cam(2) =  (/   56.3  ,   57.8  ,   60.9  ,   62.6  ,    65.8  ,  &
                              68.3  ,   71.3  ,   74.4  ,   77.9  ,    80.4  /)
 atom( 71: 80)%cam(2) =  (/   84.0  ,   86.9  ,   90.4  ,   93.8  ,    97.4  ,  &
                              100.  ,  104.   ,  107.   ,  112.   ,   115.   /)
 atom( 81: 90)%cam(2) =  (/   118.  ,  122.   ,  126.   ,  132.   ,   117.   ,  &
                              108.  ,   87.   ,   88.   ,   90.8  ,    96.5  /)
 atom( 91: 98)%cam(2) =  (/   101.  ,  102.   ,   42.2  ,   39.9  ,    48.1  ,  &
                               49.0 ,   49.0  ,   50.0/)
 atom(201)%cam(2) = atom(1)%cam(2)

 atom(  1: 10)%tics(2) = (/     0.624,     1.34,      2.28,      3.38,      6.61,  &
                               11.5  ,    19.6 ,     32.5 ,     51.5 ,     78.6 /)
 atom( 11: 20)%tics(2) = (/   116.   ,   165.  ,    229.  ,    310.  ,    410.  ,  &
                              532.   ,   678.  ,    851.  ,   1050.  ,   1290.  /)
 atom( 21: 30)%tics(2) = (/  1560.   ,  1860.  ,   2200.  ,   2580.  ,   3020.  ,  &
                             3490.   ,  4010.  ,   4570.  ,   5180.  ,   5860.  /)
 atom( 31: 40)%tics(2) = (/  6600.   ,  7380.  ,   8220.  ,   9110.  ,  10000.  ,  &
                            11000.   , 12100.  ,  13200.  ,  14300.  ,   2470.  /)
 atom( 41: 50)%tics(2) = (/  2730.   ,  3000.  ,   3320.  ,   3640.  ,   3990.  ,  &
                             4360.   ,  4760.  ,   5180.  ,   5630.  ,   6110.  /)
 atom( 51: 60)%tics(2) = (/  6620.   ,  7160.  ,   7730.  ,   8340.  ,   8980.  ,  &
                             9650.   , 10400.  ,  11100.  ,  11900.  ,  12700.  /)
 atom( 61: 70)%tics(2) = (/ 13500.   , 14400.  ,  15400.  ,  16300.  ,  17400.  ,  &
                            18400.   , 19500.  ,  20700.  ,  21900.  ,  23100.  /)
 atom( 71: 80)%tics(2) = (/ 24400.   , 25800.  ,  27200.  ,  28600.  ,  30100.  ,  &
                            31600.   , 33100.  ,  34800.  ,  36500.  ,  38200.  /)
 atom( 81: 90)%tics(2) = (/ 40100.   , 41900.  ,  43800.  ,  45800.  ,  40700.  ,  &
                            39800.   , 32200.  ,  33000.  ,  54000.  ,  37000.  /)
 atom( 91: 98)%tics(2) = (/ 38700.   , 40300.  ,  25700.  ,  16200.  ,  18900.  ,  &
                            20100.   , 20100.  ,  20900./)
 atom(201)%tics(2) = atom(1)%tics(2)

 ! 3. Cu
 atom(  1: 10)%cam(3) = (/   0.391,    0.292 ,      0.500,    1.11,     2.31 , &
                             4.51 ,    7.44  ,    11.5   ,   15.8 ,    22.9  /)
 atom( 11: 20)%cam(3) = (/  29.7  ,   40.0   ,    49.6   ,   63.7 ,    75.5  , &
                            93.3  ,  106.    ,   116.    ,  145.  ,   170.   /)
 atom( 21: 30)%cam(3) = (/ 180.0  ,  200.    ,   219.    ,  247.  ,   270.   , &
                           302.   ,  321.    ,    48.8   ,   51.8 ,    57.9  /)
 atom( 31: 40)%cam(3) = (/  62.1  ,   67.9   ,    74.7   ,   80.0 ,    89.0  , &
                            95.2  ,  104.    ,   113.    ,  124.  ,   139.   /)
 atom( 41: 50)%cam(3) = (/ 145.   ,  154.    ,   166.    ,  176.  ,   189.   , &
                           199.   ,  213.    ,   222.    ,  236.  ,   247.   /)
 atom( 51: 60)%cam(3) = (/ 259.   ,  267.    ,   288.    ,  299.  ,   317.   , &
                           325.   ,  348.    ,   368.    ,  390.  ,   404.   /)
 atom( 61: 70)%cam(3) = (/ 426.   ,  434.    ,   434.    ,  403.  ,   321.   , &
                           362.   ,  129.    ,   132.    ,  140.  ,   142.   /)
 atom( 71: 80)%cam(3) = (/ 156.   ,  155.    ,   158.    ,  168.  ,   187.   , &
                           184.   ,  191.    ,   188.    ,  201.  ,   188.   /)
 atom( 81: 90)%cam(3) = (/ 226.   ,  235.    ,   244.    ,  254.  ,   248.   , &
                           267.   ,  277.    ,   273.    ,  317.  ,   306.   /)
 atom( 91: 98)%cam(3) = (/ 271.   ,  288.    ,   314.    ,  280.  ,   322.   , &
                           338.   ,  352.    ,   360./)
 atom(201)%cam(3) = atom(1)%cam(3)

 atom(  1: 10)%tics(3) = (/     0.655,       1.94,      5.76,      16.6,      41.5, &
                               89.9  ,     173.  ,    304.  ,     498. ,     768. /)
 atom( 11: 20)%tics(3) = (/  1140.   ,    1610.  ,   2220.  ,    2970. ,    3880. , &
                             4970.   ,    6240.  ,   7720.  ,    9400. ,   11300. /)
 atom( 21: 30)%tics(3) = (/ 13500.   ,   15900.  ,  18500.  ,   21300. ,   24600. , &
                            28000.   ,   31400.  ,   4760.  ,    5470. ,    6290. /)
 atom( 31: 40)%tics(3) = (/  7190.   ,    8190.  ,   9290.  ,   10500. ,   11800. , &
                            13200.   ,   14800.  ,  16500.  ,   18300. ,   20300. /)
 atom( 41: 50)%tics(3) = (/ 22300.   ,   24600.  ,  27000.  ,   29500. ,   32300. , &
                            35200.   ,   38200.  ,  41500.  ,   45000. ,   48600. /)
 atom( 51: 60)%tics(3) = (/ 52500.   ,   56500.  ,  60700.  ,   65200. ,   70000. , &
                            75000.   ,   80300.  ,  85700.  ,   91200. ,   96800. /)
 atom( 61: 70)%tics(3) = (/102000.   ,  108000.  , 110000.  ,  105000. ,   84700. , &
                            97700.   ,   34700.  ,  36700.  ,   39300. ,   41000. /)
 atom( 71: 80)%tics(3) = (/ 45000.   ,   46000.  ,  48500.  ,   51300. ,   57200. , &
                            58000.   ,   62400.  ,  63400.  ,   66900. ,   66800. /)
 atom( 81: 90)%tics(3) = (/ 75400.   ,   79800.  ,  84300.  ,   88100. ,   86500. , &
                            97200.   ,  102000.  , 102000.  ,  143000. ,  118000. /)
 atom( 91: 98)%tics(3) = (/106000.   ,  112000.  , 123000.  ,  113000. ,  144000. , &
                           138000.   ,  143000.  , 150000./)
 atom(201)%tics(3) = atom(1)%tics(3)

! 4. Ni

 atom(  1: 10)%cam(4) = (/      0.394 ,     0.314 ,     0.584 ,    1.35  ,     2.87 ,   &
                                5.62  ,     9.29  ,    14.3   ,    19.7  ,    28.5  /)
 atom( 11: 20)%cam(4) = (/     36.9   ,    49.6   ,    61.3   ,    78.7  ,    93.0  ,   &
                              115.    ,   130.    ,   143.    ,   177.   ,   208.   /)
 atom( 21: 30)%cam(4) = (/    220.    ,   240.    ,   266.    ,   318.   ,   325.   ,   &
                              362.    ,    51.3   ,    59.7   ,    63.3  ,    70.8  /)
 atom( 31: 40)%cam(4) = (/     75.9   ,    82.9   ,    91.1   ,    97.6  ,   109.   ,   &
                              116.    ,   127.    ,   138.    ,   151.   ,   163.   /)
 atom( 41: 50)%cam(4) = (/    176.    ,   188.    ,   202.    ,   214.   ,   229.   ,   &
                              241.    ,   259.    ,   269.    ,   286.   ,   299.   /)
 atom( 51: 60)%cam(4) = (/    314.    ,   323.    ,   349.    ,   362.   ,   383.   ,   &
                              396.    ,   419.    ,   442.    ,   468.   ,   484.   /)
 atom( 61: 70)%cam(4) = (/    511.    ,   371.    ,   375.    ,   356.   ,   149.   ,   &
                              146.    ,   155.    ,   158.    ,   169.   ,   169.   /)
 atom( 71: 80)%cam(4) = (/    189.    ,   187.    ,   190.    ,   203.   ,   222.   ,   &
                              221.    ,   230.    ,   227.    ,   243.   ,   230.   /)
 atom( 81: 90)%cam(4) = (/    271.    ,   283.    ,   295.    ,   305.   ,   299.   ,   &
                              321.    ,   332.    ,   329.    ,   399.   ,   369.   /)
 atom( 91: 98)%cam(4) = (/    325.    ,   347.    ,   355.    ,   336.   ,   352.   ,   &
                               360.   ,   443.    ,   469.   /)
 atom(201)%cam(4) = atom(1)%cam(4)


 atom(  1: 10)%tics(4) = (/        0.659 ,        2.09 ,       6.73 ,      20.2 ,      51.4 , &
                                 112.    ,      216.   ,     380.   ,     620.  ,     956. /)
 atom( 11: 20)%tics(4) = (/     1410.    ,     2000.   ,    2750.   ,    3670.  ,    4780.  , &
                                6110.    ,     7660.   ,    9460.   ,    11500. ,   13800. /)
 atom( 21: 30)%tics(4) = (/    16400.    ,    19100.   ,   22500.   ,    27400. ,   29700.  , &
                               33500.    ,     5020.   ,    5820.   ,    6680.  ,    7680. /)
 atom( 31: 40)%tics(4) = (/     8790.    ,    10000.   ,   11300.   ,   12800.  ,   14400.  , &
                               16100.    ,    18000.   ,   20100.   ,   22300.  ,   24700. /)
 atom( 41: 50)%tics(4) = (/    27200.    ,    29900.   ,   32800.   ,   35900.  ,   39200.  , &
                               42700.    ,    46400.   ,   50300.   ,   54500.  ,   58900. /)
 atom( 51: 60)%tics(4) = (/    63500.    ,    68400.   ,   73500.   ,   78800.  ,   84500.  , &
                               90400.    ,    96600.   ,  103000.   ,  109000.  ,  116000. /)
 atom( 61: 70)%tics(4) = (/   123000.    ,    92800.    ,  94600.   ,   92800.  ,   38700.  , &
                               38800.    ,    41400.  ,    44200.   ,   47400.  ,   49300. /)
 atom( 71: 80)%tics(4) = (/    53500.    ,    56600.   ,   58400.   ,   61900.  ,   68800.  , &
                               69700.    ,    75100.   ,   76200.   ,   80300.  ,   80200. /)
 atom( 81: 90)%tics(4) = (/    91100.    ,    96400.   ,  102000.   ,   106000. ,  104000.  , &
                              117000.    ,    123000.  ,  123000.   ,  167000.  ,  142000. /)
 atom( 91: 98)%tics(4) = (/   127000.    ,   133000.   ,  140000.   ,  136000.  ,  148000.  , &
                              147000.    ,   148000.   ,  161000. /)
 atom(201)%tics(4) = atom(1)%tics(4)

 ! 5. Co

 atom(  1: 10)%cam(5) = (/    0.397 ,     0.343 ,    0.396 ,    1.67 ,    3.59 , &
                              7.07  ,    11.7   ,   18.    ,   24.7  ,   35.8   /)
 atom( 11: 20)%cam(5) = (/   46.2   ,    61.9   ,   76.4   ,   97.8  ,  115.   , &
                            142.    ,   161.    ,  176.    ,  218.   ,  255.    /)
 atom( 21: 30)%cam(5) = (/  269.    ,   291.    ,  323.    ,  408.   ,  393.   , &
                             57.2   ,    63.2   ,   73.5   ,   78.0  ,  87.1   /)
 atom( 31: 40)%cam(5) = (/   93.4   ,   102.0   ,  112.    ,  120.   ,  133.   , &
                            142.    ,   156.    ,  170.    ,  185.   ,  200.   /)
 atom( 41: 50)%cam(5) = (/  216.    ,   230.    ,  247.    ,  262.   ,  280.   , &
                            295.    ,   316.    ,  329.    ,  349.   ,  364.   /)
 atom( 51: 60)%cam(5) = (/  383.    ,   394.    ,  425.    ,  440.   ,  465.   , &
                            480.    ,   507.    ,  535.    ,  565.   ,  505.   /)
 atom( 61: 70)%cam(5) = (/  400.    ,   176.    ,  419.    ,  161.   ,  180.   , &
                            176.    ,   187.    ,  191.    ,  206.   ,  206.   /)
 atom( 71: 80)%cam(5) = (/  229.    ,   227.    ,  231.    ,  246.   ,  268.   , &
                            268.    ,   278.    ,  276.    ,  295.   ,  273.   /)
 atom( 81: 90)%cam(5) = (/  331.    ,   343.    ,  355.    ,  370.   ,  363.   , &
                            392.    ,   403.    ,  398.    ,  461.   ,  406.   /)
 atom( 91: 98)%cam(5) = (/  394.    ,   420.    ,  430.    ,  408.   ,  426.   , &
                            437.    ,   443.    ,  469. /)
 atom(201)%cam(5) = atom(1)%cam(5)

 atom(  1: 10)%tics(5) = (/      0.664 ,      2.28 ,      7.99 ,     25. ,     64.5 , &
                               141.    ,    272.   ,    478.   ,    779. ,   1200. /)
 atom( 11: 20)%tics(5) = (/   1760.    ,   2500.   ,   3420.   ,   4560. ,   5930.  , &
                              7560.    ,   9460.   ,  11700.   ,  14100. ,  16900. /)
 atom( 21: 30)%tics(5) = (/  20100.    ,  23100.   ,  27500.   ,  35300. ,  35800.  , &
                              5310.    ,   6180.   ,   7160.   ,   8230. ,   9460. /)
 atom( 31: 40)%tics(5) = (/  10800.    ,  12300.   ,  13900.   ,  15700. ,  17700.  , &
                             19800.    ,  22200.   ,  24700.   ,  27300. ,  30200. /)
 atom( 41: 50)%tics(5) = (/  33300.    ,  36600.   ,  40200.   ,  43900. ,  47900.  , &
                             52100.    ,  56600.   ,  61400.   ,  66400. ,  71800. /)
 atom( 51: 60)%tics(5) = (/  77400.    ,  83400.   ,  89600.   ,  96000. , 103000.  , &
                            109000.    , 117000.   , 124000.   , 132000. , 121000. /)
 atom( 61: 70)%tics(5) = (/  96300.    ,  42000.   , 106000.   ,  35500. ,  47200.  , &
                             47200.    ,  50200.   ,  53300.   ,  57700. ,  59800. /)
 atom( 71: 80)%tics(5) = (/  65300.    ,  69000.   ,  69200.   ,  75100. ,  83300.  , &
                             84400.    ,  91100.   ,  92000.   ,  97100.,    97100./)
 atom( 81: 90)%tics(5) = (/ 111000.    , 117000.   , 123000.   , 129000. , 126000.  , &
                            143000.    , 149000.   , 149000.   , 174000. , 172000. /)
 atom( 91: 98)%tics(5) = (/ 153000.    , 161000.   , 169000.   , 165000. , 181000.  , &
                            179000.    , 182000.   , 196000. /)
 atom(201)%tics(5) = atom(1)%tics(5)


! 6. FER

 atom(  1: 10)%cam(6) = (/   0.4   ,    0.381 ,      0.839 ,    2.09  ,    4.55 ,  &
                             8.99  ,   14.9   ,    22.8    ,   31.3   ,   45.2   /)
 atom( 11: 20)%cam(6) = (/  58.2   ,   77.8   ,    95.9    ,  122.    ,  144.   ,  &
                           177.    ,  200.    ,   218.     ,  270.    ,  314.   /)
 atom( 21: 30)%cam(6) = (/ 332.    ,  358.    ,   399.     ,  492.    ,   61.6  ,  &
                            71.0   ,   78.5   ,    91.3    ,   96.8   ,  108.   /)
 atom( 31: 40)%cam(6) = (/ 116.    ,  127.    ,   139.     ,  149.    ,  165.   ,  &
                           176.    ,  193.    ,   210.     ,  229.    ,  247.   /)
 atom( 41: 50)%cam(6) = (/ 267.    ,  284.    ,   305.     ,  323.    ,  346.   ,  &
                           363.    ,  389.    ,   405.     ,  428.    ,  447.   /)
 atom( 51: 60)%cam(6) = (/ 471.    ,  483.    ,   522.     ,  540.    ,  569.   ,  &
                           586.    ,  618.    ,   561.     ,  448.    ,  455.   /)
 atom( 61: 70)%cam(6) = (/ 194.    ,  204.    ,   203.     ,  195.    ,  219.   ,  &
                           214.    ,  228.    ,   232.     ,  253.    ,  251.   /)
 atom( 71: 80)%cam(6) = (/ 280.    ,  277.    ,   283.     ,  301.    ,  327.   ,  &
                           327.    ,  340.    ,   357.     ,  361.    ,  339.   /)
 atom( 81: 90)%cam(6) = (/ 403.    ,  420.    ,   434.     ,  452.    ,  444.   ,  &
                           477.    ,  493.    ,   487.     ,  530.    ,  485.   /)
 atom( 91: 98)%cam(6) = (/ 482.    ,  528.    ,   552.     ,  498.    ,  581.   ,  &
                           590.    ,  592.    ,   607. /)
 atom(201)%cam(6) = atom(1)%cam(6)


 atom(  1: 10)%tics(6) = (/        0.670 ,      2.53  ,       9.67  ,      31.3  ,       81.8  ,  &
                                 179.    ,    346.    ,     606.    ,     986.   ,     1510. /)
 atom( 11: 20)%tics(6) = (/     2220.    ,   3140.    ,    4290.    ,    5710.   ,     7410.   ,  &
                                9420.    ,  11800.    ,    14400.   ,    17500.  ,    20900. /)
 atom( 21: 30)%tics(6) = (/    24700.    ,  28500.    ,   33700.    ,   42500.   ,     5620.   ,  &
                                6590.    ,   7680.    ,    8890.    ,   10200.   ,    11700. /)
 atom( 31: 40)%tics(6) = (/    13400.    ,  15300.    ,   17300.    ,   19500.   ,    21900.   ,  &
                               24500.    ,  27400.    ,   30500.    ,   33800.   ,    37400. /)
 atom( 41: 50)%tics(6) = (/    41200.    ,  45200.    ,   49500.    ,   54200.   ,    59100.   ,  &
                               64200.    ,  69700.    ,   75500.    ,   81700.   ,    88200. /)
 atom( 51: 60)%tics(6) = (/    95100.    , 102000.    ,  110000.    ,  118000.   ,   126000.   ,  &
                              134000.    , 143000.    ,  131000.    ,  108000.   ,   109000. /)
 atom( 61: 70)%tics(6) = (/    46700.    ,  51100.    ,   51100.    ,   51100.   ,    57800.   ,  &
                               57800.    ,  61300.    ,   64700.    ,   70900.   ,    73000. /)
 atom( 71: 80)%tics(6) = (/    80300.    ,  84900.    ,   84600.    ,   91500.   ,   102000.   ,  &
                              102000.    , 111000.    ,  112000.    ,  118000.   ,   119000. /)
 atom( 81: 90)%tics(6) = (/   136000.    , 148000.    ,  151000.    ,  157000.   ,   154000.   ,  &
                              175000.    , 182000.    ,  183000.    ,  200000.   ,   196000. /)
 atom( 91: 98)%tics(6) = (/   188000.    , 197000.    ,  217000.    ,  202000.   ,   243000.   ,  &
                              242000.    , 243000.    ,  253000. /)
 atom(201)%tics(6) = atom(1)%tics(6)


 ! 7. Cr
 atom(  1: 10)%cam(7) = (/         0.412  ,     0.498 ,     1.30 ,     3.44  ,    4.59  , &
                                  15.     ,    24.7   ,    37.8  ,    51.5   ,   74.1 /)
 atom( 11: 20)%cam(7) = (/        94.9    ,   126.    ,   155.   ,   196.    ,  230.    , &
                                 281.     ,   316.    ,   342.   ,   421.    ,  490.  /)
 atom( 21: 30)%cam(7) = (/       516.     ,   590.    ,    74.7  ,    86.8   ,   97.5   , &
                                 113.     ,   124.    ,   144.   ,   153.    ,  171.  /)
 atom( 31: 40)%cam(7) = (/       183.     ,   199.    ,   219.   ,   234.    ,  260.    , &
                                 277.     ,   303.    ,   328.   ,   358.    ,  386.  /)
 atom( 41: 50)%cam(7) = (/       416.     ,   442.    ,   474.   ,   501.    ,  536.    , &
                                 563.     ,   602.    ,   626.   ,   663.    ,  691.  /)
 atom( 51: 60)%cam(7) = (/       723.     ,   740.    ,   796.   ,   721.    ,  760.    , &
                                 570.     ,   225.    ,   238.   ,   238.    ,  251.  /)
 atom( 61: 70)%cam(7) = (/       294.     ,   279.    ,   309.   ,   298.    ,  332.    , &
                                 325.     ,   347.    ,   352.   ,   386.    ,  387.  /)
 atom( 71: 80)%cam(7) = (/       431.     ,   425.    ,   532.   ,   457.    ,  501.    , &
                                 499.     ,   520.    ,   541.   ,   551.    ,  541.  /)
 atom( 81: 90)%cam(7) = (/       597.     ,   643.    ,   666.   ,   691.    ,  680.    , &
                                 734.     ,   758.    ,   743.   ,   739.    ,  768.  /)
 atom( 91: 98)%cam(7) = (/       738.     ,   766.    ,   800.   ,   760.    ,  795.    , &
                                 812.     ,   852.    ,   871. /)
 atom(201)%cam(7) = atom(1)%cam(7)

 atom(  1: 10)%tics(7) = (/      0.689 ,       3.31 ,     15.  ,      51.4  ,    136. , &
                               299.    ,     575.   ,   1000.  ,    1620.   ,   2480. /)
 atom( 11: 20)%tics(7) = (/   3620.    ,    5090.   ,   6930.  ,    9160.   ,  11800. , &
                             15000.    ,   18600.   ,  22700.  ,   27400.   ,  32600. /)
 atom( 21: 30)%tics(7) = (/  38500.    ,   46900.   ,   6320.  ,    7500.   ,   8900. , &
                             10400.    ,   12200.   ,  14100.  ,   16100.   ,  18500. /)
 atom( 31: 40)%tics(7) = (/  21200.    ,   24100.   ,  27200.  ,   30700.   ,  34500. , &
                             38500.    ,   43000.   ,  47800.  ,   52900.   ,  58400. /)
 atom( 41: 50)%tics(7) = (/  64200.    ,   70500.   ,  77100.  ,   84100.   ,  91600. , &
                             99400.    ,  108000.   , 117000.  ,  126000.   , 136000. /)
 atom( 51: 60)%tics(7) = (/ 146000.    ,  157000.   , 168000.  ,  157000.   , 177000. , &
                            134000.    ,   52000.   ,  55400.  ,   57300.   ,  60000. /)
 atom( 61: 70)%tics(7) = (/  70800.    ,   66800.   ,  78900.  ,   78200.   ,  87600. , &
                             85900.    ,   93700.   ,  99300.  ,  108000.   , 113000. /)
 atom( 71: 80)%tics(7) = (/ 125000.    ,  132000.   , 131000.  ,  140000.   , 155000. , &
                            157000.    ,  170000.   , 166000.  ,  179000.   , 180000. /)
 atom( 81: 90)%tics(7) = (/ 222000.    ,  222000.   , 232000.  ,  199000.   , 237000. , &
                            270000.    ,  282000.   , 279000.  ,  279000.   , 296000. /)
 atom( 91: 98)%tics(7) = (/ 288000.    ,  303000.   , 314000.  ,  308000.   , 349000. , &
                            333000.    ,  349000.   , 363000. /)
 atom(201)%tics(7) = atom(1)%tics(7)

 return
 END subroutine definition_data_X

 end  module Xrays_data
