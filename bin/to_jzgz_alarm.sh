#!/bin/bash
####################################################################################
## 功能:对外FTP接口，
## 格式：UTF-8
##
####################################################################################
#set -x

#设置路径及环境变量
WLZY_HOME=/u01/wlzy/jzgz_alarm
BIN_DIR=${WLZY_HOME}/bin          	                           #用于存放可执行脚本或程序
BSQL_DIR=${BIN_DIR}/sql          	                             #用于存放可执行SQL
CFG_DIR=${WLZY_HOME}/cfg                                       #配置文件目录
CFG_FILE=${CFG_DIR}/jzgz_alarm.cfg111                                 #配置文件
LOG_DIR=${WLZY_HOME}/log          	                           #用于存放日志
DATA_DIR=${WLZY_HOME}/data          	                         #用于存放数据
SQL_DIR=${WLZY_HOME}/sql 	                                     #存放SQL的目录

#当天日期
_date=`date +'%Y%m%d'`
_ftime=`date +'%Y%m%d%H%M%S'`
_filetime=`date +'%Y%m%d'`

if [ ! -d ${BSQL_DIR} ]
then
		cd ${BIN_DIR}
		mkdir sql
fi

if [ ! -d ${DATA_DIR}/${_date} ]
then
		cd ${DATA_DIR}
		mkdir ${_date}
fi

if [ ! -d ${DATA_DIR}/jzgz_alarm ]
then
		cd ${DATA_DIR}
		mkdir jzgz_alarm
fi

#进入文件生成目录，执行完准备处理
cd ${DATA_DIR}/{$_date}
if [ -f ${CFG_FILE} ]
then
cat ${CFG_FILE} | grep -v '#' | while read line
	do
		txt_name=`echo ${line} | awk -F\| '{print $1}'`
		sql_name=`echo ${line} | awk -F\| '{print $2}'`
		echo "================================================================"            	  
		echo "开始执行...$sql_name......["`date +'%Y-%m-%d %H:%M:%S'`"]:"        							
		echo "================================================================"            	  
		#将sql模板拷贝到执行目录
		if [ -f ${SQL_DIR}/${sql_name} ]
		then 
		cp ${SQL_DIR}/${sql_name} ${BSQL_DIR}                  			          
		#替换日期和时间
		sed -i "s/_MY_DATE/${_date}/g" ${BSQL_DIR}/${sql_name} 											          
		sed -i "s/_FILE_NAME/${txt_name}${_ftime}/g" ${BSQL_DIR}/${sql_name}								
		#SPOOL数据
		sqlplus -s ${LOGN}/${LOGP}@${DSID}< ${BSQL_DIR}/${sql_name}
		fi    									    							          	
		echo "结束执行...$sql_name......["`date +'%Y-%m-%d %H:%M:%S'`"]"                 	    
	done
fi

echo "开始文件传送"
lftp -u 
cd upload
lcd ${DATA_DIR}/${_date}/
mput *.csv
by
EOF
echo "文件传送完成"
