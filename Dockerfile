# Build with "docker build --pull --no-cache -t docker.codingcafe.org/sandbox/centos git@git.codingcafe.org:Sandbox/CentOS.git"

FROM centos/systemd
ADD ["setup.sh", "/etc/codingcafe/"]
ADD ["cache.repo", "/etc/yum.repos.d/"]
VOLUME ["/var/log"]
SHELL ["/bin/bash", "-c"]
RUN cp -f /etc/hosts /tmp && echo 10.0.0.10 {repo,git}.codingcafe.org > /etc/hosts && /etc/codingcafe/setup.sh && cat /tmp/hosts > /etc/hosts && rm -f /tmp/hosts