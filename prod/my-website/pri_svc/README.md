### Private Subnet 설치 시 주의 사항
1. prometheus, grafana의 data 디렉토리의 경우 반드시 777로 변경 필요
2. loki의 소유명 10001:10001로 변경하기 (rulestorage, var)
3. nextcloud 디렉토리의 config, custom_apps, data, themes의 경우 33:tape로 변경 필요
4. 먼저 실행(profile install 제외) 후 nextcloud의 config.php가 생기면 sample로 변경 필요 (실시간 반영이기에 따로 restart 할 필요 없음)
5. 이후 profile install 진행 후 전체 시작 (이때는 notify_push install 진행 필요 자세한 건 아래 내용 참조)
6. grafana import의 경우, node_exporter 기반 1860, 11074 / cAdvisor 기준 193, 179

### Nextcloud 설치 명령어 모음
1. php occ app:install notify_push || php occ app:enable notify_push \
   php occ notify_push:setup https://cloud.lucky-gun.com/push || true  (해당 명령어는 profile install 이후 가능합니다.) \
   php occ config:system:get appstoreenabled
3. php occ background:cron \
   php occ config:system:set maintenance_window_start --type=integer --value=17 \
   php occ config:system:get maintenance_window_start
4. php occ maintenance:mode --on \
   php occ maintenance:repair --include-expensive \
   php occ maintenance:mode --off
5. php occ config:system:set default_phone_region --value="KR"
6. php occ maintenance:mimetype:update-js || true
7. php occ app_api:daemon:register \
   docker_local "Docker local" docker-install http docker-socket-proxy:2375 \
   https://cloud.lucky-gun.com --set-default \
   --haproxy_password 'rlckrlrhkstk104!' \
   --net pri_svc_pv_net
8. php occ db:add-missing-indices
9. openssl rand 32 | base64 (외부저장소 이용시)

### mysql 작업하기
<pre><code>mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -h my_mysql -P 3306 -ugate_admin -pgate_pass mysql </code></pre>

## 만약 app 연결이 안되어있으면
php occ maintenance:mode --off \
php occ config:system:set appstoreenabled --type=boolean --value=true \
php occ config:system:set appstoreurl --value="https://apps.nextcloud.com/api/v1" \
php occ config:system:get appstoreenabled \
php occ config:system:get appstoreurl

