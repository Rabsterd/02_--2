/* 날짜 관련 함수 */

-- SYSDATE : 시스템에 현재 시간(년, 월, 일, 시, 분, 초)을 반환
SELECT SYSDATE FROM DUAL;

--SYSTIMESTAMP : SYSDATE + MS 단위 추가
SELECT SYSTIMESTAMP FROM DUAL;
-- TIMESTAMP : 특정 시간을 나타내거나 기록하기 위한 문자열

-- MONTH_BETWEEN(날짜, 날짜) : 두 날짜의 개월 수 차이 반환
SELECT ABS( ROUND(MONTHS_BETWEEN(SYSDATE, '2023-12-22'), 3) ) "수강 기간(개월)" FROM DUAL;   

-- EMPLOYEE 테이블에서 
-- 사원의 이름, 입사일, 근무한 개월 수, 근무 년차 조회

SELECT EMP_NAME, HIRE_DATE,
CEIL( MONTHS_BETWEEN( SYSDATE, HIRE_DATE ) ) "근무한 개월 수",  
CEIL( MONTHS_BETWEEN(SYSDATE, HIRE_DATE)/ 12) || '년차' "근무 년차"
FROM EMPLOYEE;

/* || : 연결 연산자 (문자열 이어쓰기)*/


-- ADD_MONTHS(날짜, 숫자) : 날짜에 숫자만큼의 개월 수를 더함(음수도 가능)
SELECT ADD_MONTHS(SYSDATE, 4) FROM DUAL;
SELECT ADD_MONTHS(SYSDATE, -1) FROM DUAL;


-- LAST_DAY(날짜) : 해당 달의 마지막 날짜를 구함
SELECT LAST_DAY(SYSDATE) FROM DUAL;
SELECT LAST_DAY('2020-02-01') FROM DUAL;


-- EXTRACT : 년, 월, 일 정보를 추출하여 리턴
-- EXTRACT(YEAR FROM 날짜) : 년도만 추출
-- EXTRACT(MONTH FROM 날짜) : 월만 추출
-- EXTRACT(DAY FROM 날짜) : 일만 추출


-- EMPLOYEE 테이블에서
-- 각 사원의 이름, 입사년도, 월, 일 조회
SELECT EMP_ID, EXTRACT(YEAR FROM HIRE_DATE) || '년' ||
EXTRACT(MONTH FROM HIRE_DATE) || '월' ||
EXTRACT(DAY FROM HIRE_DATE) || '일' AS 입사일
FROM EMPLOYEE;

----------------------------------------------------------------

/* 형변환 함수 */
-- 문자열(CHAR), 숫자(NUMBER), 날짜(DATE)끼리 형변환 가능

/* 문자열로 변환 */
-- TO_CHAR(날짜, [포맷]) : 날짜형 데이터를 문자형 데이터로 변경
-- TO_CHAR(숫자, [포맷]) : 숫자형 데이터를 문자형 데이터로 변경

-- <숫자 변환 시 포맷 패턴>
-- 9 : 숫자 한칸을 의미, 여러개 작성 시 오른쪽 정렬
-- 0 : 숫자 한칸을 의미, 여러개 작성 시 오른쪽 정렬 + 빈칸에 0 추가
-- L : 현재 DB에 설정된 나라의 화폐 기호

SELECT TO_CHAR(1234, '99999') FROM DUAL; -- ' 1234'
SELECT TO_CHAR(1234, '00000') FROM DUAL; -- '01234'
SELECT TO_CHAR(1234) FROM DUAL;

SELECT TO_CHAR(1000000, '9,999,999') || '원' FROM DUAL;

SELECT TO_CHAR(1000000, 'L9,999,999') FROM DUAL;

-- < 날짜 변환 시 포맷 패턴>
-- YYYY : 년도 / YY : 년도(짧게)
-- MM : 월
-- DD : 일
-- AM 또는 PM : 오전 / 오후 표시
-- HH : 시간 / HH24 : 24시간 표기법
-- MI : 분 / SS : 초
-- DAY : 요일(전체) / DY : 요일(요일명만 표시)

-- 2023/08/04/ 10:06:34	금요일
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS DAY') FROM DUAL;

-- 08/04 (금)

SELECT TO_CHAR(SYSDATE, 'MM/DD (DY)') FROM DUAL;

--2023년 08월 04일 (금)
SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일" (DY)') FROM DUAL;
--> ""를 이용해서 단순한 문자로 인식시기면 해결됨

------------------------------------------------------------------

/* 날짜로 변환 TO_DATE */

-- TO_DATE(문자형 데이터, [포맷]) : 문자형 데이터를 날짜로 변경
-- TO_DATE(숫자형 데이터, [포맷]) : 숫자형 데이터를 날짜로 변경
--> 지정된 포맷으로 날짜를 인식함

SELECT TO_DATE('2022-09-23') FROM DUAL;
SELECT TO_DATE(20230102) FROM DUAL;

SELECT TO_DATE('230803 101832', 'YYMMDD HH24MISS') FROM DUAL;
--> 패턴을 적용해서 작성된 문자열의 각 문자가 어떤 날짜 형식인지 인지 시킴


-- Y 패턴 : 현재 세기(21세기 == 20XX년 == 2000년대)
-- R 패턴 : 1900년대 : 1세기를 기준으로 절반(50년) 이상인 경우 이전세기(1900년대) 
-- 					   절반(50년) 미만인 경우 현재 세기(2000년대)

SELECT TO_DATE('500505', 'YYMMDD') FROM DUAL;
SELECT TO_DATE('500505', 'RRMMDD') FROM DUAL;

-- EMPLOYEE 테이블에서 각 직원이 태어난 생년월일 조회

SELECT EMP_NAME, 
TO_CHAR( TO_DATE( SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-') -1 ), 'RRMMDD'), 'YYYY"년 "MM"월" DD"일" ') AS 생년월일
FROM EMPLOYEE;

--------------------------------------------------------------------

/* 숫자 형변환 */

-- TO_NUMBER(문자데이터, [포맷]) : 문자형 데이터 숫자 데이터로 변경

SELECT TO_NUMBER('1,000,000', '9,999,999') + 500000 FROM DUAL; 


/* NULL 처리 함수 */

-- NVL(컬럼명, 컬럼값이 NULL일때 바꿀 값) : NULL인 컬럼값을 다른값으로 변경

/* NULL과 산술 연산을 진행하면 결과는 무조건 NULL */

SELECT EMP_NAME, SALARY, NVL(BONUS, 0), SALARY + (SALARY * NVL(BONUS, 0) )
FROM EMPLOYEE;

-- NVL2(컬럼명, 바꿀값1, 바꿀값2)
-- 해당 컬럼의 값이 있으면 바꿀값1로 변경,
-- 해당 컬럼이 NULL이면 바꿀값2로 변경

-- EMPLYEE 테이블에서 보너스르 받으면 '0', 안받으면 'X' 조회
SELECT EMP_NAME, NVL2(BONUS, 'O', 'X') "보너스 수령"
FROM EMPLOYEE;

-----------------------------------------------------------------

/* 선택 함수 */
-- 여러 가지 경우에 따라 알맞은 결과를 선택하 수 있음

--DECODE(계산식 | 컬럼명, 조건값1, 선택값1, 조건값2, 선택값2 ..., 아무것도 일치하지 않을 때)
-- 비교하고자 하는 값 또는 컬럼이 조건식과 같으면 결과값 반환
-- 일치하는 값을 확인 (자바의 SWITCH 비슷)

-- 직원의 성별 구하기(남 : 1 / 여 : 2)
SELECT EMP_NAME,DECODE( SUBSTR(EMP_NO, 8, 1), '1', '남성', '2', '여성') 성별
FROM EMPLOYEE;

-- 직원의 급여를 인상하고자 한다.
-- 직급 코드가 J7인 직원은 20% 인상,
-- 직급 코드가 J6인 직원은 15% 인상,
-- 직급 코드가 J5인 직원은 10% 인상,
-- 그 외 직급은 5% 인상

SELECT EMP_NAME, JOB_CODE, SALARY,
DECODE(JOB_CODE, 'J7', '20%', 'J6', '15%', 'J5', '10%', '5%') 인상률,
DECODE(JOB_CODE, 'J7', SALARY * 1.2, 'J6', SALARY * 1.15, 'J5', SALARY * 1.1, SALARY * 1.05) "인상된 급여"
FROM EMPLOYEE;

-- CASE WHEN 조건식 THEN 결과값
--		WHEN 조건식 THEN 결과값
--		ELSE 결과값
-- END

-- 비교하고자하는 값 또는 컬럼이 조건식과 같으면 결과값 반환
-- 조건은 범위값 가능

-- EMPLOYEE 테이블에서
-- 급여가 500만원 이상이면 '대'
-- 급여가 300만 이상 500만 미만이면 '중'
-- 급여가 300만 미만 '소' 으로 조회

SELECT EMP_NAME, SALARY,
CASE  
	WHEN SALARY >= 5000000 THEN '대'
	WHEN SALARY >= 3000000 THEN '중'
	ELSE '소'
END "급여 받는 정도"
FROM EMPLOYEE;

-------------------------------------------------------------------

/* 그룹 함수*/
-- 하나 이상의 행을 그룹으로 묶어 연산하여 총합, 평균 등 하나의 결과 행으로 반환하는 함수

-- SUM(숫자가 기록된 컬럼명) : 합계
-- 모든 직원의 급여 합
SELECT SUM(SALARY) FROM EMPLOYEE;

-- AVG(숫자가 기록된 컬럼명) : 평균
-- 전 직원 급여 평균
SELECT ROUND( AVG(SALARY) ) FROM EMPLOYEE;

-- 부서코드가 'D9'인 사원들의 급여 합, 평균 조회
SELECT SUM(SALARY), ROUND(AVG(SALARY) ) 
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- MIN(컬럼명) : 최솟값
-- MAX(컬럼명) : 최대값
--> 타입 제한 없음(숫자 : 대 / 소, 날짜 : 과거 / 미래, 문자열 : 문자 순서)

-- 급여 최소값, 가장 빠른 입사일, 알파벳 순서가 가장 빠른 이메일
SELECT MIN(SALARY), MIN(HIRE_DATE), MIN(EMAIL)
FROM EMPLOYEE;

-- 급여 최대값, 가장 느린 입사일, 알파뱃 순서가 가장 느린 이메일
SELECT MAX(SALARY), MAX(HIRE_DATE), MAX(EMAIL)
FROM EMPLOYEE;


-- EMPLOYEE 테이블에서 급여를 가장 많이 받는 사원의 
-- 이름, 급여, 직급 코드 조회
SELECT EMP_NAME, SALARY, JOB_CODE 
FROM EMPLOYEE
WHERE SALARY = ( SELECT MAX(SALARY) FROM EMPLOYEE );
				-- 서브쿼리 + 그룹함수

-- * COUNT(* | 컬럼명) : 행의 개수를 헤아려서 리턴
-- COUNT([DISTINCT] 컬럼명) : 중복을 제거한 행 개수를 헤아려서 리턴
-- COUNT(*) : NULL을 포함한 전체 행 개수를 리턴
-- COUNT(컬럼명) : NULL을 제외한 실제 값이 기록된 행 개수를 리턴함

-- EMPLOYEE 테이블의 행의 개수
SELECT COUNT(*) FROM EMPLOYEE;

-- BONUS를 받는 사원의 수
SELECT COUNT(*) FROM EMPLOYEE
WHERE BONUS IS NOT NULL; -- 9명

SELECT COUNT(BONUS) FROM EMPLOYEE; -- 9명

SELECT DISTINCT DEPT_CODE FROM EMPLOYEE; -- 7 NULL 포함

SELECT COUNT(DISTINCT DEPT_CODE) FROM EMPLOYEE; -- 6 NULL 제외
-- COUNT(컬럼명)에 의해서 NULL을 제외한 실제 값이 있는 행의 개수만 조회

-- EMPLOYEE 테이블에서 성별이 남성인 사원의 수 조회
SELECT COUNT(*) 
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '1';




