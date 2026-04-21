-- 1) root는 "컨테이너 내부(localhost) 전용"으로만 유지
ALTER USER 'root'@'localhost' IDENTIFIED BY '';

-- 혹시라도 만들어졌을 수 있는 원격 root들을 제거(존재해도 안전; 없으면 경고만)
DROP USER IF EXISTS 'root'@'%';
DROP USER IF EXISTS 'root'@'172.%';
DROP USER IF EXISTS 'root'@'10.%';
DROP USER IF EXISTS 'root'@'127.0.0.1';
DROP USER IF EXISTS 'root'@'::1';

-- (선택) 익명 사용자/테스트 DB 정리 - 보안 강화 관례
DELETE FROM mysql.user WHERE user='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db LIKE 'test%';
FLUSH PRIVILEGES;

-- 2) 도커 네트워크 대역에서만 붙는 전용 관리 계정 생성
--    예: DBGate가 붙을 계정. 호스트에 와일드카드 사용 가능
CREATE USER IF NOT EXISTS ''@'192.168.%' IDENTIFIED BY '';
GRANT ALL PRIVILEGES ON *.* TO ''@'192.168.%';
-- 필요 시 특정 DB로만 축소: GRANT ALL ON appdb.* TO ''@'172.22.%';

-- (선택) 네트워크 내부라도 전송 암호화를 강제하고 싶다면 아래 사용(서버 TLS 설정 필요)
-- ALTER USER ''@'172.22.%' REQUIRE SSL;

FLUSH PRIVILEGES;
