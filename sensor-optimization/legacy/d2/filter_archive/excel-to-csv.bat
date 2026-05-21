FOR /f "delims=" %%i IN ('DIR *.xls* /b') DO to-csv.vbs "%%i" "%%i.csv"
