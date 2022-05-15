rm -rf /opt/oracle/admin/XE/adump/*
rm -rf /opt/oracle/admin/XE/bdump/*
find /opt/oracle -type f -name *.trc -exec rm {} \;
