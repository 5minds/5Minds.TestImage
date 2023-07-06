# 5Minds.Basics.TestImage

Bei diesem Image handelt es sich um das Default Docker Image für UI-Tests mit Robot Framework.

Die Tests werden in Chrome ausgeführt in einer auflösung von 1920x1080@24.

Beispiel `docker-compose.yml`
```
version: '3.5'
services:
  test:
    image: ghcr.io/5minds/testimage:0.0.2
    network_mode: host
    volumes:
      - ./integration-tests:/opt/robotframework/tests
      - ./testresults:/opt/robotframework/reports
    user: "${UID}:${GID}"
    privileged: true
    shm_size: 2gb
    extra_hosts:
      - "localhost:127.0.0.1"
    ipc: host
```

Die Robot Dateien bzw. alles was benötigt wird, kommt muss in das Verzeichnis "/opt/robotframework/tests" gemoutet werden.
Die Rebots kommen aus dem Verzeichnis "/opt/robotframework/reports"
