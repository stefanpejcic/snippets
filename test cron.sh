# cron running?
pgrep cron
service cron status
# or crond for redhat, other distros above

# add line in crontab:
*/1 *   * * *   root   /bin/date >> /tmp/cronlog
