-- ⚠️ 주의: 이 코드를 실행하면 모든 데이터가 삭제됩니다!

-- 1. 트리거 삭제 (함수와 연결된 고리 끊기)
drop trigger if exists on_auth_user_created on auth.users;

-- 2. 함수 삭제
drop function if exists public.handle_new_user();

-- 3. 테이블 삭제 (stones가 profiles를 참조하므로 stones 먼저 삭제)
drop table if exists public.stones;
drop table if exists public.profiles;

-- (참고: RLS 정책(Policy)은 테이블이 삭제되면 알아서 같이 사라집니다.)