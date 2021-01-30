/* 
SQL INJECTION ILKEL (PRIMITIVE) YONTEMLER
*/
SELECT 1

SELECT '1'

SELECT (1)

SELECT ('1')

SELECT '("1")'

SELECT '2' - '1'

SELECT '2' + '1'

SELECT ('2') + ('1')

SELECT "'2'" + "'1'"

SELECT '"2"' + '"1"'

SELECT ("'2'") + ("'1'")

SELECT 2 + A

SELECT 2 + 'A'

SELECT 'B' + 'A'

SELECT '2' '1'

SELECT '2','1'

SELECT ('2'),('1')

SELECT ('"2"'),('"1"')

SELECT "('2')","('1')"

SELECT 2^2

SELECT '2' ^ '2'

SELECT 170 ^ 75  --XOR

SELECT !1

SELECT ('2')/('1')

SELECT ('"2"')/('"1"')

SELECT (2)*(1)

SELECT ('2')*('1')

SELECT (A)-(B)

SELECT ('A')-('B')

SELECT ('A')/('B')

SELECT ('A')*('B')